require!<[mongodb winston]>

# mongodb collection name
const ARTICLE = \article
const STATUTE = \statute

mongoUri = void

exports.setMongoUri = ->
    winston.info "Set mongoUri to #it"
    mongoUri := it

chainCloseDB = (db, cb) ->
    (err, res) ->
        db.close!
        cb err, res

exports.getArticle = (req, rsp) ->
    callback = (err, article) ->
        if err
            rsp.jsonp {
                isSuccess: false
                reason: err.toString!
            }
        else
            rsp.jsonp {
                isSuccess: true
                article: article
            }

    m = /^([^_]+)_([\d-]+)$/.exec req.params.query
    if not m => return callback new Error "query string #{req.params.query} format error"

    name = m.1
    article = m.2

    err, db <- mongodb.Db.connect mongoUri
    if err => return callback err
    callback := chainCloseDB db, callback

    err, collection <- db.collection STATUTE
    if err => return callback err

    err, data <- collection.find { name: $elemMatch: { name: name } } .toArray
    if err => return callback err

    if data.length != 1 => return callback new Error "Cannot find law #name"

    lyID = data[0].lyID

    err, collection <- db.collection ARTICLE
    if err => return callback err

    err, data <- collection.find { lyID: lyID, article: article } .toArray
    if err => return callback err

    if data.length != 1 => return callback new Error "Cannot find law #name artcile #article"

    ret =
        content: data[0].content

    return callback null, ret

exports.getSuggestion = (req, rsp) ->
    callback = (err, suggestion) ->
        if err
            rsp.jsonp {
                isSuccess: false
                reason: err.toString!
            }
        else
            rsp.jsonp {
                isSuccess: true
                suggestion: suggestion
            }

    # FIXME: How to validate regex to prevent regex bomb?
    keyword = req.params.query

    err, db <- mongodb.Db.connect mongoUri
    if err => return callback err
    callback := chainCloseDB db, callback

    err, collection <- db.collection STATUTE
    if err => return callback err

    cursor = collection.find {
        name: $elemMatch: { name: { $regex: keyword } } },
        { name: true }

    err, data <- cursor.limit 10 .toArray
    if err => return callback err

    suggestion = []
    for law in data
        if law.name != void
            for name in law.name
                suggestion.push { law: name.name }

    return callback null, suggestion


exports.getLaw = (req, rsp) ->
    callback = (err, law) ->
        if err
            rsp.jsonp {
                isSuccess: false
                reason: err.toString!
            }
        else
            rsp.jsonp {
                isSuccess: true
                law: law
            }

    lawName = req.params.query

    err, db <- mongodb.Db.connect mongoUri
    if err => return callback err
    callback := chainCloseDB db, callback

    err, collection <- db.collection STATUTE
    if err => return callback err

    err, law <- collection.find {
        name: $elemMatch: { name: lawName } } .toArray!
    if err => return callback err

    if law.length != 1
        return callback new Error "Found #{law.length} when query law name #lawName"

    law = law[0]

    ret =
        name: law.name
        lyID: law.lyID
        PCode: law.PCode

    return callback null, ret

exports.getLawNameList = (req, rsp) ->
    callback = (err, lawNameList) ->
        if err
            rsp.jsonp do
                isSuccess: false
                reason: err.toString!
        else
            rsp.jsonp do
                isSuccess: true
                name: lawNameList

    err, db <- mongodb.Db.connect mongoUri
    if err => return callback err
    callback := chainCloseDB db, callback

    err, collection <- db.collection STATUTE
    if err => return callback err

    err, data <- collection.find {}, { name: true, _id:false } .toArray!
    if err => return callback err

    lawNameList = []
    for law in data
        if law.name != void
            for name in law.name
                lawNameList.push name.name
    callback null, lawNameList

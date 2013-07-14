require!<[moment mongodb winston]>

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

const GET_ARTICLE_VER = 1
exports.getArticle = (req, rsp) ->
    callback = (err, article) ->
        if err
            winston.warn err.toString!
            rsp.jsonp do
                isSuccess: false
                ver: GET_ARTICLE_VER
                reason: err.toString!
        else
            rsp.jsonp do
                isSuccess: true
                ver: GET_ARTICLE_VER
                article: article

    name = req.param \name
    if name == void => return callback new Error "No name param"

    article = req.param \article
    if article == void => return callback new Error "No article param"
    if not /^\d+(?:-\d+)?$/.test article => return callback new Error "article format error"

    date = req.param \date
    if date == void
        date = (new Date() .toISOString! .split \T)[0]
    if not /^\d{4}-\d{2}-\d{2}$/.test date => return callback new Error "date format error"

    winston.info "getArticle name: #name, article: #article, date: #date"

    err, db <- mongodb.Db.connect mongoUri
    if err => return callback err
    callback := chainCloseDB db, callback

    err, collection <- db.collection STATUTE
    if err => return callback err

    err, law <- collection.find { name: $elemMatch: { name: name } }, { lyID: true } .toArray!
    if err => return callback err

    if law.length != 1
        return callback new Error "Found #{law.length} when query law name #name"

    lyID = law[0].lyID

    err, collection <- db.collection ARTICLE
    if err => return callback err

    err, data <- collection.find { article: article, lyID: lyID } .toArray!
    if err => return callback err

    var ret
    for item in data
        if not moment date .isBefore item.passed_date
            if ret == void or moment item.passed_date .isAfter ret.passed_date
                ret = do
                    name: name
                    article: article
                    passed_date: item.passed_date
                    content: item.content
    if ret == void => return callback new Error "Cannot find article"

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
        name: $elemMatch: { name: lawName } }, {
        name: true, lyID: true, PCode: true, history: true } .toArray!
    if err => return callback err

    if law.length != 1
        return callback new Error "Found #{law.length} when query law name #lawName"

    law = law[0]

    ret =
        name: law.name
        lyID: law.lyID
        PCode: law.PCode
        history: law.history

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

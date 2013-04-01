require!{async, mongodb, should, \../server/db}

# XXX: Hoping no one use this collection...
const MONGO_URI = \mongodb://localhost:27017/test-laweasyread
const MONGO_OPTS =
    w: 1

const DATA =
    statute:
        * name:
            * name: \中華民國憲法
              start_date: \1946-12-25
            ...
          history:
            * passed_date: \1946-12-25
              enactment_date: \1947-01-01
              enforcement_date: \1947.12.25
            ...
          lyID: \04101
        ...
    article:
        * article: \1
          lyID: \04101
          content: \中華民國基於三民主義，為民有、民治、民享之民主共和國。\n
          passed_date: \1946-12-25
        ...

createLoadCollectionTask = (db, name, data) ->
    (cb) ->
        (err, collection) <- db.collection name
        should.not.exist err

        (err, res) <- collection.insert data
        should.not.exist err
        cb null

loadTestData = (cb) ->
    err, db <- mongodb.Db.connect MONGO_URI, MONGO_OPTS
    should.not.exist err

    task = []
    for name, data of DATA
        task.push createLoadCollectionTask db, name, data

    (err, res) <- async.series task
    should.not.exist err

    db.close!
    cb null

createRemoveCollectionTask = (db, name) ->
    (cb) ->
        (err, collection) <- db.collection name
        should.not.exist err

        (err) <- collection.remove!
        should.not.exist err

        cb null

removeTestData = (cb) ->
    err, db <- mongodb.Db.connect MONGO_URI, MONGO_OPTS
    should.not.exist err

    task = []
    for name of DATA
        task.push createRemoveCollectionTask db, name

    (err, res) <- async.series task
    should.not.exist err

    db.close!
    cb null

main = ->
    (err) <- removeTestData
    should.not.exist err

    (err) <- loadTestData
    should.not.exist err

    db.setMongoUri MONGO_URI

    (err, res) <- db.getStatute { query: \中華民國憲法_1 }
    should.not.exist err
    res.content .should.equal DATA.article[0].content

    (err, res) <- db.getStatute { query: \中華民國憲法_ }
    should.exist err

    (err, res) <- db.getStatute { query: \憲法_1 }
    should.not.exist err
    res.should.eql {}

    (err, res) <- db.getSuggestion { query: \憲 }
    should.not.exist err
    res.should.eql [ \中華民國憲法 ]

    (err) <- removeTestData
    should.not.exist err

main!

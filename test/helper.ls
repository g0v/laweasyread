require!{async, child_process, mongodb}
laweasyread = require \../

servers = {};
databases = {};

const MONGO_OPTS =
    w: 1

getRandomNumber = (min, max) ->
    min + Math.round Math.random! * (max - min)

createDatabase = (data, callback) ->
    # FIXME: Assume there is nothing important in this database.
    mongo_uri = "mongodb://localhost/test-laweasyread-" +
        getRandomNumber 0, 999999

    (err, db) <- mongodb.Db.connect mongo_uri, MONGO_OPTS
    if err => callback err; return

    (err, res) <- db.dropDatabase
    if err => callback err; return

    (err) <- async.map (Object.keys data), (key, callback) ->
        (err, collection) <- db.collection key
        if err => callback err; return
        (err) <- collection.insert data[key]
        callback err

    databases[mongo_uri] = db

    callback null, mongo_uri

deleteDatabase = (mongo_uri, callback) ->
    db = databases[mongo_uri]

    (err) <- db.dropDatabase
    if err => callback err; return

    (err) <- db.close
    if err => callback err; return

    callback null

startServer = (data, callback) ->
    # FIXME: Assume port is available
    port = getRandomNumber 10000, 20000

    host = "http://localhost:#port/"

    (err, mongo_uri) <- createDatabase data
    if err => callback err, null; return

    (err, server) <- laweasyread.server.start {
        mongo_uri: mongo_uri
        port: port
    }

    servers[host] =
        server: server
        mongo_uri: mongo_uri

    callback null, host

stopServer = (host, callback) ->
    server = servers[host]

    server.server.close!
    (err) <- deleteDatabase server.mongo_uri
    if err => callback err; return

    callback null

exports.startServer = startServer
exports.stopServer = stopServer

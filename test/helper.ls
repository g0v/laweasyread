require!{async, child_process, mongodb}

servers = {};
databases = {};

const MONGO_OPTS =
    w: 1

getRandomNumber = (min, max) ->
    min + Math.round Math.random! * (max - min)

createDatabase = (data, callback) ->
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

exports.start_server = (data, callback) ->
    # FIXME: Assume port and collection are available
    port = 10000 + Math.round Math.random! * 10000

    host = "http://localhost:#port/"

    (err, mongo_uri) <- createDatabase data
    if err => callback err, null; return

    child = child_process.spawn \node, ["#__dirname/../start.js"
        \--mongo_uri, mongo_uri,
        \--port, port]

    child.stdout.on \data, (data) ->
        if data.toString! == /application started/
            servers[host] =
                mongo_uri: mongo_uri
                process: child
            callback null, host

exports.stop_server = (host, callback) ->
    server = servers[host]
    server.process.kill!

    (err) <- deleteDatabase server.mongo_uri
    if err => callback err; return

    callback null

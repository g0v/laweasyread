require!{async, child_process, mongodb, \../server/index}

servers = {};

const MONGO_OPTS =
    w: 1

exports.start_server = (data, callback) ->
    # FIXME: Assume port and collection are available
    port = 10000 + Math.round Math.random! * 10000

    host = "http://localhost:#port/"
    database = "test-laweasyread-#port"
    mongo_uri = "mongodb://localhost/#database"

    (err, db) <- mongodb.Db.connect mongo_uri, MONGO_OPTS
    if err => callback err, null ; return

    (err, res) <- db.dropDatabase
    if err => callback err, null; return

    (err) <- async.map (Object.keys data), (key, callback) ->
        (err, collection) <- db.collection key
        if err => callback err; return
        (err) <- collection.insert data[key]
        callback err

    if err => callback err, null; return

    child = child_process.spawn \node, ["#__dirname/../server/start.js",
        \--mongo_uri, mongo_uri,
        \--port, port]

    child.stdout.on \data, (data) ->
        if data.toString! == /application started/
            servers[host] =
                db: db
                process: child
            callback null, host

exports.stop_server = (host, callback) ->
    server = servers[host]

    server.process.kill!

    (err) <- server.db.dropDatabase
    if err => callback err

    (err) <- server.db.close
    if err => callback err

    callback null

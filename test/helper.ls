require!{child_process, \pow-mongodb-fixtures, \../server/index}

servers = {};

exports.start_server = (data, callback) ->
    # FIXME: Assume port and collection are available
    port = 10000 + Math.round Math.random! * 10000

    host = "http://localhost:#port/"
    collection = "test-laweasyread-#port"

    fixture = powMongodbFixtures.connect collection

    (err) <- fixture.clearAndLoad data
    if err => callback err, null ; return

    server =
        collection: collection

    server = child_process.spawn \node, ["#__dirname/../server/start.js",
        \--mongo_uri, "mongodb://localhost/#collection",
        \--port, port]

    server.stdout.on \data, (data) ->
        if data.toString! == /start application/
            servers[host] =
                collection: collection
                process: server
                fixture: fixture
            callback null, host

exports.stop_server = (host, callback) ->
    servers[host].process.kill!
    (err) <- servers[host].fixture.clear# servers[host].collection
    callback err

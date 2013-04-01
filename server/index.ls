require!{express, \./db}
STATIC_URI = \/

API_URI = \/api
API_URI_STATUTE = API_URI + \/statute/:query

exports.start = (config) ->
    app = express!

    app.use express.logger \dev

    console.log "static dir is #{config.static_dir}"
    app.use STATIC_URI, express.static config.static_dir

    db.setMongoUri config.mongo_uri

    app.get STATIC_URI, (req, res) ->
        res.redirect \/index.html

    app.get API_URI_STATUTE, (req, res) ->
        (err, ret) <- db.getStatute req.params
        if err
            console.error err
            ret = {}
        res.jsonp ret

    console.log "start application"
    console.log "port: #{config.port}"
    app.listen config.port

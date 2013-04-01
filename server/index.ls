require!{express, \./db}
app = express!

API_URI = \/api
API_URI_STATUTE = API_URI + \/statute/:query

exports.start = (config) ->
    db.setMongoUri config.mongo_uri

    app.get API_URI_STATUTE, (req, res) ->
        (err, ret) <- db.getStatute req.params
        if err
            console.error err
            ret = {}
        res.jsonp ret

    console.log "start application"
    console.log "port: #{config.port}"
    app.listen config.port

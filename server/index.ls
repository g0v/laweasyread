require!{express, \./db}
STATIC_URI = \/

const API_URI = \/api
const API_TABLE =
    \statute/:query :
        func: db.getStatute
        default: {}
    \suggestion/:query :
        func: db.getSuggestion
        default: []

get_api_callback = (info) ->
    (req, res) ->
        (err, ret) <- info.func req.params
        if err
            console.error err
            ret = info.default
        res.jsonp ret

exports.start = (config) ->
    app = express!
    app.use express.compress!
    app.use express.logger \dev
    app.set \views config.views_dir
    app.set 'view engine' 'jade'

    console.log "static dir is #{config.static_dir}"
    app.use express.static(config.static_dir)

    db.setMongoUri config.mongo_uri

    do
        (req, res) <- app.get STATIC_URI
        res.render \index

    for api, info of API_TABLE
        app.get "#API_URI/#api", get_api_callback info

    console.log "start application"
    console.log "port: #{config.port}"
    app.listen config.port

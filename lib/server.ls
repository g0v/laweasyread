require!{express, http, \./route}
STATIC_URI = \/

const API_URI = \/api

exports.start = (config, callback) ->
    if callback == void => callback = ->

    config.views_dir = config.views_dir or "#__dirname/../views"
    config.static_dir = config.static_dir or "#__dirname/../public"

    app = express!
    app.use express.compress!
    app.use express.logger \dev
    app.use(express.favicon());
    app.set \views config.views_dir
    app.set 'view engine' 'jade'

    console.log "static dir is #{config.static_dir}"
    app.use express.static config.static_dir

    route.setMongoUri config.mongo_uri

    do
        (req, res) <- app.get STATIC_URI
        res.render \index

    app.get "#API_URI/article/:query", route.getArticle
    app.get "#API_URI/law/:query", route.getLaw
    app.get "#API_URI/suggestion/:query", route.getSuggestion

# error handling
    do
        (req, res) <- app.use!
        res.render \404.jade

    do
        (err, req, res, next) <- app.use!
        console.error(err.stack);
        res.render \500.jade

    server = http.createServer app
    <- server.listen config.port
    console.log "application started on port #{config.port}"
    callback null, server

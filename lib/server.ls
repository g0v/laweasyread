require!<[express http winston \./route]>
STATIC_URI = \/

const API_URI = \/api

exports.start = (config, callback) ->
    if callback == void => callback = ->

    winston.clear!
    winston.add winston.transports.File, { filename: "#__dirname/../log" }

    # Default values if not set.
    config.views_dir = config.views_dir or "#__dirname/../views"
    config.static_dir = config.static_dir or "#__dirname/../public"

    app = express!

    app.use express.logger do
        stream:
            write: (msg) -> winston.info msg

    app.use express.compress!
    app.use express.favicon!

    app.set \views, config.views_dir
    app.set 'view engine', 'jade'
    app.locals.pretty = config.dev

    winston.info "static dir is #{config.static_dir}"
    app.use express.static config.static_dir

    app.get STATIC_URI, (req, res) ->
        res.render \index, { dev: config.dev }

    route.setMongoUri config.mongo_uri
    app.set 'json spaces', if config.dev => 4 else 0

    app.get "#API_URI/article", route.getArticle
    app.get "#API_URI/law", route.getLawNameList
    app.get "#API_URI/law/:query", route.getLaw
    app.get "#API_URI/suggestion/:query", route.getSuggestion

    app.use (req, res) ->
        res.render \404.jade

    app.use (err, req, res, next) ->
        winston.err err.stack
        res.render \500.jade

    server = http.createServer app
    <- server.listen config.port
    winston.info "application started on port #{config.port}"
    callback null, server

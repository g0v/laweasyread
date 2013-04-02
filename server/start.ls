require!{optimist, \./index}

config = optimist.default {
    mongo_uri: process.env.MONGO_URI or \mongodb://localhost:27017/laweasyread
    port: process.env.PORT or 3000
    static_dir: __dirname + \/../public
    views_dir: __dirname + \/../views
} .argv

index.start config

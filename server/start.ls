require!{optimist, \./index}

config = optimist.default {
    mongo_uri: process.env.MONGO_URI or \mongodb://localhost:27017/laweasyread
    port: process.env.PORT or 3000
} .argv

index.start config

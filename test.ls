require!{\exec-sync, fs}

files = fs.readdirSync "#__dirname/test"

for file in files
    path = "#__dirname/test/#file"
    console.log "Run #path"
    execSync "./node_modules/.bin/lsc #path"

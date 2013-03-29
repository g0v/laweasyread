require!{fs}

files = fs.readdirSync "#__dirname/test"

for file in files
    if file != /\.ls$/ => continue

    path = "#__dirname/test/#file"

    console.log "Run #path"
    require path

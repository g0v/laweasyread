require!{express, './lib/twlaw'}
app = express!

process.env.MONGOLAB_URI or \mongodb://localhost:27017/laweasyread |> twlaw.setMongoUri

msg = "API endpoint at <p>/laws/(law_abbr_name)</p>"

app.get '/' (req, res) ->
    res.send msg

app.get '/laws/:query' (req, res) ->
    (err, ret) <- twlaw.getStatute req.params
    if err
        console.log err
        ret = {}
    res.jsonp ret

(process.env.PORT or 3000) |> app.listen
"application starts" |> console.log

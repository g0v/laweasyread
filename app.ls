require!{express, './lib/twlaw'}
app = express!

msg = "API endpoint at <p>/laws/(law_abbr_name)</p>"

app.get '/' (req, res) ->
    res.send msg

app.get '/laws/:query' (req, res) ->
    twlaw.get_law req.params, (strJson) ->
        res.jsonp strJson 

(process.env.PORT or 3000) |> app.listen
"application starts" |> console.log

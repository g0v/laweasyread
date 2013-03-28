require!{express, './lib/twlaw'}
app = express!

msg = "API endpoint at <p>/laws/(law_abbr_name)</p>"

app.get '/' (req, res) ->
  res.send msg

app.get '/laws/:query' (req, res) ->
  res.jsonp twlaw.get_law req.params

app.listen process.env.PORT || 3000

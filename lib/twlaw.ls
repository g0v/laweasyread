require! mongodb
mongoUri = process.env.MONGOLAB_URI or 'mongodb://localhost:27017/laweasyread' 

exports.get_law_fake = (params) ->
    law: params.query
    content: "行為之處罰，以行為時之法律有明文規定者為限。拘束人身自由之保安處分，亦同。"
    link: "http://law.moj.gov.tw/LawClass/LawSingle.aspx?Pcode=C0000001&FLNO=1"


exports.get_law = (params, cb) ->
    law = params.query
    err, db <- mongodb.Db.connect mongoUri
    err, collection <- db.collection 'laweasyread_fake' 
    err, data <- collection.find({"law":law}).toArray
    strJson:""
    strJson = '{"law":"'+law+'","content":"'+data[0].content+'","link":"'+data[0].link+'"}'
    strJson |> console.log 
    cb strJson
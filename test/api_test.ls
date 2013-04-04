require!{request, should, \./helper}
test = it

const DATA =
    statute:
        * name:
            * name: \中華民國憲法
              start_date: \1946-12-25
            ...
          history:
            * passed_date: \1946-12-25
              enactment_date: \1947-01-01
              enforcement_date: \1947.12.25
            ...
          lyID: \04101
        ...
    article:
        * article: \1
          lyID: \04101
          content: \中華民國基於三民主義，為民有、民治、民享之民主共和國。\n
          passed_date: \1946-12-25
        ...

host = void

before (done) ->
    this.timeout 10000
    (err, str) <- helper.start_server DATA
    should.not.exist err
    host := str
    done!

describe "Test /api/statute/", ->
    describe "Good input", ->
        test "中華民國憲法_1", (done) ->
            (err, rsp, body) <- request { uri: host + \api/statute/中華民國憲法_1 }
            should.not.exist err
            JSON.parse body .content .should.eql DATA.article[0].content
            done!

    describe "Bad input", ->
        test "中華民國憲法_", (done) ->
            (err, rsp, body) <- request { uri: host + \api/statute/中華民國憲法_ }
            should.not.exist err
            JSON.parse body .should.eql {}
            done!

        test "憲法_1", (done) ->
            (err, rsp, body) <- request { uri: host + \api/statute/憲法_1 }
            should.not.exist err
            JSON.parse body .should.eql {}
            done!

describe "Test /api/suggestion/", ->
    describe "Good input", ->
        test "憲", (done) ->
            (err, rsp, body) <- request { uri: host + \api/suggestion/憲 }
            should.not.exist err
            JSON.parse body .should.eql [\中華民國憲法]
            done!

after (done) ->
    (err) <- helper.stop_server host
    done!

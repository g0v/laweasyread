require!{chai, request, \./helper}
expect = chai.expect

describe 'DataSet 1', (,) ->
    const DATA =
        statute:
            * name:
                * name: \中華民國憲法
                  start_date: \1946-12-25
                ...
              history:
                * \1946-12-25 : '制定175條，國民政府令公布\n中華民國35年12月25日國民大會通過'
                  \1947-01-01 : '公布'
                  \1947-12-25 : '施行'
              lyID: \04101
              PCode: \A0000001
            ...
        article:
            * article: \1
              lyID: \04101
              content: \中華民國基於三民主義，為民有、民治、民享之民主共和國。\n
              passed_date: \1946-12-25
            ...
    host = void
    this.timeout 10000ms

    before (done) ->
        err, str <- helper.startServer DATA
        expect err .to.not.exist
        host := str
        done!

    describe 'Test /api/law', (,) ->
        describe 'Good input', (,) ->
            it '中華民國憲法', (done) ->
                err, rsp, body <- request { uri: host + \api/law/中華民國憲法 }
                expect err .to.not.exist
                expect JSON.parse body .to.eql do
                    isSuccess: true,
                    law:
                        name:
                            * name: \中華民國憲法
                              start_date: \1946-12-25
                            ...
                        history:
                          * \1946-12-25 : '制定175條，國民政府令公布\n中華民國35年12月25日國民大會通過'
                            \1947-01-01 : '公布'
                            \1947-12-25 : '施行'
                        lyID: \04101
                        PCode: \A0000001
                done!

        describe 'Bad input', (,) ->
            it '中華民國', (done) ->
                err, rsp, body <- request { uri: host + \api/law/中華民國 }
                expect err .to.not.exist
                expect (JSON.parse body .isSuccess) .to.eql false
                done!

    describe 'Test /api/article', (,) ->
        describe 'Good input', (,) ->
            it 'name + article', (done) ->
                err, rsp, body <- request { uri: host + \api/article?name=中華民國憲法&article=1 }
                expect err .to.not.exist
                expect JSON.parse body .to.eql do
                    isSuccess: true
                    article:
                        passed_date: \1946-12-25
                        content: \中華民國基於三民主義，為民有、民治、民享之民主共和國。\n
                done!

            it 'name + article + date', (done) ->
                err, rsp, body <- request { uri: host + \api/article?name=中華民國憲法&article=1&date=1946-12-25 }
                expect err .to.not.exist
                expect JSON.parse body .to.eql do
                    isSuccess: true
                    article:
                        passed_date: \1946-12-25
                        content: \中華民國基於三民主義，為民有、民治、民享之民主共和國。\n
                done!

        describe 'Bad input', (,) ->
            it 'bad name', (done) ->
                err, rsp, body <- request { uri: host + \api/article?name=憲法&article=1 }
                expect err .to.not.exist
                expect (JSON.parse body .isSuccess) .to.be.false
                done!

            it 'bad article', (done) ->
                err, rsp, body <- request { uri: host + \api/article?name=憲法&article=1- }
                expect err .to.not.exist
                expect (JSON.parse body .isSuccess) .to.be.false
                done!

            it 'bad date', (done) ->
                err, rsp, body <- request { uri: host + \api/article?name=憲法&article=1&date=1946-12-24 }
                expect err .to.not.exist
                expect (JSON.parse body .isSuccess) .to.be.false
                done!

    describe 'Test /api/suggestion/', (,) ->
        describe 'Good input', (,) ->
            it '憲', (done) ->
                err, rsp, body <- request { uri: host + \api/suggestion/憲 }
                expect err .to.not.exist
                expect JSON.parse body .to.eql do
                    isSuccess: true
                    suggestion:
                        * law: \中華民國憲法
                        ...
                done!

    describe "Test bad occation", (,) ->
        describe "404 page", (,) ->
            it "get the 404 page", (done) ->
                err, rsp, body <- request { uri: host + \api/bad-api-xxx }
                expect err .to.not.exist
                expect body.indexOf \Sorry .not.be.below(0)
                done!

    after (done) ->
        err <- helper.stopServer host
        done!

describe 'DataSet 2', (,) ->
    const DATA =
        statute:
            * name:
                * name: \中華民國憲法
                ...
            * name:
                * name: \國民政府內政部組織法
                * name: \內政部組織法
            ...
    host = void
    this.timeout 10000ms

    before (done) ->
        err, str <- helper.startServer DATA
        expect err .to.not.exist
        host := str
        done!

    describe 'Test /api/law', (,) ->
        it 'Query all law names', (done) ->
            err, rsp, body <- request { uri: host + \api/law }
            expect err .to.not.exist
            expect JSON.parse body .to.eql do
                isSuccess: true
                name:
                    * \中華民國憲法
                    * \國民政府內政部組織法
                    * \內政部組織法
            done!

    after (done) ->
        err <- helper.stopServer host
        done!

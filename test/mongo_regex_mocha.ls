require!{chai, request, \./helper}
expect = chai.expect

describe 'Test regex in mongo', (,) ->
    const DATA =
        statute:
            * name:
                * name: \a * 100
                ...
            ...
    var host

    before (done) ->
        this.timeout 10000
        err, str <- helper.startServer DATA
        expect err .to.not.exist
        host := str
        done!

    describe 'catastriphic regex in PCRE', (,) ->
        it '(a+a+)+b', (done) ->
            err, rsp, body <- request { uri: host + 'api/suggestion/(a+a+)+b' }
            expect err .to.not.exist
            res = JSON.parse body
            expect JSON.parse body .to.eql do
                isSuccess: true
                suggestion: []
            done!

    after (done) ->
        err <- helper.stopServer host
        done!

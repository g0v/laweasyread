require!<[chai]>
test = it
should = chai.should!

parse = require \.. .parse

const DATA =
    * decimal: 1
      roman: \I
    * decimal: 4
      roman: \IV
    * decimal: 5
      roman: \V
    * decimal: 9
      roman: \IX
    * decimal: 10
      roman: \X
    * decimal: 40
      roman: \XL
    * decimal: 50
      roman: \L
    * decimal: 90
      roman: \XC
    * decimal: 100
      roman: \C
    * decimal: 400
      roman: \CD
    * decimal: 500
      roman: \D
    * decimal: 900
      roman: \CM
    * decimal: 1000
      roman: \M

describe "Test roman to integer", ->
    test "Good roman", (done) ->
        for data in DATA
            parse.roman_to_integer data.roman.toUpperCase! .should.equal data.decimal
            parse.roman_to_integer data.roman.toLowerCase! .should.equal data.decimal
        done!

describe "Test integer to roman", ->
    test "Good integer", (done) ->
        for data in DATA
            parse.integer_to_roman data.decimal .should.equal data.roman
        done!

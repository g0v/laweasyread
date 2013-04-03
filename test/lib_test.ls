require!{should, \../lib/parse}
test = it

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
    describe "Good roman", ->
        for data in DATA
            test "#{data.roman} should be #{data.decimal}", (done) ->
                parse.roman_to_integer data.roman.toUpperCase! .should.equal data.decimal
                parse.roman_to_integer data.roman.toLowerCase! .should.equal data.decimal
                done!

describe "Test integer to roman", ->
    describe "Good integer", ->
        for data in DATA
            test "#{data.decimal} should be #{data.roman}", (done) ->
                parse.integer_to_roman data.decimal .should.equal data.roman
                done!

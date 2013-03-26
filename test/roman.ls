require!{\romanize-component, should}

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

for data in DATA
  romanizeComponent data.decimal .should.equal data.roman

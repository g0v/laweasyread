require!{\romanize-component, \deromanize-component}

exports.roman_to_integer = ->
    deromanizeComponent(it)

exports.integer_to_roman = ->
    romanizeComponent(it)

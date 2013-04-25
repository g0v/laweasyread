angular.module \laweasyread.services <[ngResource]>
.factory \Suggestions [
    \$resource
    ($resource) ->
        $resource '/api/suggestion/:query'
]
.factory \lawInfo [
    \$resource
    ($resource) ->
        $resource '/api/law/:query'
]
.factory \getLawNameList [
    \$resource
    ($resource) -> $resource \/api/law
]

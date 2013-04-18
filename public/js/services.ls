angular.module \laweasyread.services <[ngResource]> 
.factory \Suggestions [
	\$resource
	($resource) ->
		$resource '/api/suggestion/:query'
]
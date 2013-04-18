
angular.module \laweasyread.controllers, []
.controller \TypeaheadCtrl, [
    \$scope, \$resource
    ($scope, $resource)->
        Suggestions = $resource '/api/suggestion/:query'
        $scope.laws = []
        (res) <- Suggestions.get {query: '法'}
        for item in res.suggestion
            $scope.laws.push(item.law)
]

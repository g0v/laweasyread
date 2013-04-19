angular.module \laweasyread.controllers, []
.controller \TypeaheadCtrl, [
    \$scope, \Suggestions
    ($scope, Suggestions) ->
        $scope.laws = []
        res <- Suggestions.get {query: '法'}
        if res.isSuccess
            for item in res.suggestion
                $scope.laws.push item.law
]

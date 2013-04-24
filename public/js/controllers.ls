angular.module \laweasyread.controllers, []
.controller \TypeaheadCtrl, [
    \$scope, \Suggestions, \lawInfo
    !($scope, Suggestions, lawInfo) ->
        $scope.laws = []
        do
            res <- Suggestions.get {query: '法'}
            if res.isSuccess
                for item in res.suggestion
                    $scope.laws.push item.law

        lawName <- $scope.$watch \lawSelected
        if lawName
            res <- lawInfo.get {query: lawName}
            if res.isSuccess
                $scope.aboutLaw = res.law

]



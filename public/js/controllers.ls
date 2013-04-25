angular.module \laweasyread.controllers, []
.controller \TypeaheadCtrl, [
    \$scope, \getLawNameList, \lawInfo
    !($scope, getLawNameList, lawInfo) ->
        $scope.laws = []
        getLawNameList.get {}, (res) ->
            if res.isSuccess
                for item in res.name
                    $scope.laws.push item

        lawName <- $scope.$watch \lawSelected
        if lawName
            res <- lawInfo.get {query: lawName}
            if res.isSuccess
                $scope.aboutLaw = res.law

]



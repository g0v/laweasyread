laweasyread = angular.module \laweasyread, ['ngResource', 'ui.bootstrap']

do
    ($scope, $resource) <-! laweasyread.controller \TypeaheadCtrl
    $scope.lawSelected = void
    # $scope.laws_stub = ['PHP', 'MySQL', 'SQL', 'PostgreSQL', 'HTML', 'CSS', 'HTML5', 'CSS3', 'JSON']
    Suggestions = $resource '/api/suggestion/:query'
    $scope.laws = []
    (res) <- Suggestions.get {query: '法'}
    for item in res.suggestion
        $scope.laws.push(item.law)
    #$scope.laws |> console.log

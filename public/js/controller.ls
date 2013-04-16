
 angular.module \laweasyreadControllers, [] .controller \TypeaheadCtrl ($scope, $resource)->  
    # $scope.laws_stub = ['PHP', 'MySQL', 'SQL', 'PostgreSQL', 'HTML', 'CSS', 'HTML5', 'CSS3', 'JSON']
    Suggestions = $resource '/api/suggestion/:query'
    $scope.laws = []
    (res) <- Suggestions.get {query: '法'}
    for item in res.suggestion
        $scope.laws.push(item.law)
    #$scope.laws |> console.log


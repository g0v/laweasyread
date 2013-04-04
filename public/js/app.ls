laweasyread = angular.module \laweasyread, ['ui.bootstrap']

do
    ($scope) <-! laweasyread.controller \TypeaheadCtrl
    $scope.lawSelected = void
    $scope.laws = ['PHP', 'MySQL', 'SQL', 'PostgreSQL', 'HTML', 'CSS', 'HTML5', 'CSS3', 'JSON']



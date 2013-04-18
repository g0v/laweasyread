angular.module \laweasyread, <[laweasyread.controllers ngResource ui.bootstrap]> .config(['$routeProvider', ($routeProvider) ->
    $routeProvider.
        when('/api/suggestion/:query' controller: \TypeaheadCtrl).
        otherwise redirectTo: '/'
]);

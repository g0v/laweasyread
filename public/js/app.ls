angular.module \laweasyread, <[laweasyread.controllers laweasyread.services ui.bootstrap]> .config(['$routeProvider', ($routeProvider) ->
    $routeProvider.
        when('/api/suggestion/:query' controller: \TypeaheadCtrl).
        otherwise redirectTo: '/'
]);

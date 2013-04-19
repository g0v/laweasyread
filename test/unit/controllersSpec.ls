test = it

describe 'Test laweasyread.controllers', ->
    beforeEach ->
        module \laweasyread.controllers

    describe 'TypeaheadCtrl', ->

        test 'Get law list successful from Suggestion Services', ->
            var ctrl
            var scope
            Suggestions =
                get: jasmine.createSpy!

            inject ($rootScope, $controller) ->
                scope := $rootScope.$new!
                ctrl := $controller \TypeaheadCtrl, {
                    $scope: scope
                    Suggestions: Suggestions
                }

            expect scope.laws .toEqual []
            expect Suggestions.get .toHaveBeenCalledWith { query: \法 }, jasmine.any Function

describe 'Test laweasyread.controllers', (...) ->
    beforeEach ->
        module \laweasyread.controllers

    describe 'TypeaheadCtrl', (...) ->
        var ctrl
        var scope
        var callback
        Suggestions =
            get: ->

        beforeEach inject ($rootScope, $controller) ->
            spyOn Suggestions, \get .andCallFake ->
                callback := arguments.1

            scope := $rootScope.$new!
            ctrl := $controller \TypeaheadCtrl, do
                $scope: scope
                Suggestions: Suggestions

        it 'Get law list success', ->
            expect scope.laws .toEqual []
            expect Suggestions.get .toHaveBeenCalledWith { query: \法 }, jasmine.any Function

            callback do
                isSuccess: true
                suggestion: [ { law: "law_#num" } for num from 0 to 9 ]

            expect scope.laws .toEqual [ "law_#num" for num from 0 to 9 ]

        it 'Get law list failed', ->
            expect scope.laws .toEqual []
            expect Suggestions.get .toHaveBeenCalledWith { query: \法 }, jasmine.any Function

            callback do
                isSuccess: false

            expect scope.laws .toEqual []

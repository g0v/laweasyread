test = it

describe 'Test laweasyread.controllers', ->
    beforeEach ->
        module \laweasyread.controllers

    describe 'TypeaheadCtrl', ->

        test 'Get law list success', ->
            var ctrl
            var scope
            var callback
            Suggestions =
                get: ->

            spyOn Suggestions, \get .andCallFake ->
                callback := arguments.1

            inject ($rootScope, $controller) ->
                scope := $rootScope.$new!
                ctrl := $controller \TypeaheadCtrl, {
                    $scope: scope
                    Suggestions: Suggestions
                }

            expect scope.laws .toEqual []
            expect Suggestions.get .toHaveBeenCalledWith { query: \法 }, jasmine.any Function

            callback {
                isSuccess: true
                suggestion: [ { law: "law_#num" } for num from 0 to 9 ]
            }

            expect scope.laws .toEqual [ "law_#num" for num from 0 to 9 ]

        test 'Get law list failed', ->
            var ctrl
            var scope
            var callback
            Suggestions =
                get: ->

            spyOn Suggestions, \get .andCallFake ->
                callback := arguments.1

            inject ($rootScope, $controller) ->
                scope := $rootScope.$new!
                ctrl := $controller \TypeaheadCtrl, {
                    $scope: scope
                    Suggestions: Suggestions
                }

            expect scope.laws .toEqual []
            expect Suggestions.get .toHaveBeenCalledWith { query: \法 }, jasmine.any Function

            callback {
                isSuccess: false
            }

            expect scope.laws .toEqual []

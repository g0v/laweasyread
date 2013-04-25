describe 'Test laweasyread.controllers', (...) ->
    beforeEach ->
        module \laweasyread.controllers

    describe 'TypeaheadCtrl', (...) ->
        var ctrl
        var scope
        var callback
        getLawNameList =
            get: ->
        lawInfo =
            get: ->

        beforeEach inject ($rootScope, $controller) ->
            spyOn getLawNameList, \get .andCallFake ->
                callback := arguments.1

            scope := $rootScope.$new!
            ctrl := $controller \TypeaheadCtrl, do
                $scope: scope
                getLawNameList: getLawNameList
                lawInfo: lawInfo

        it 'Get law list success', ->
            expect scope.laws .toEqual []
            expect getLawNameList.get .toHaveBeenCalledWith {}, jasmine.any Function

            callback do
                isSuccess: true
                name: [ "law_#num" for num from 1 to 20 ]

            expect scope.laws .toEqual [ "law_#num" for num from 1 to 20 ]

        it 'Get law list failed', ->
            expect scope.laws .toEqual []
            expect getLawNameList.get .toHaveBeenCalledWith {}, jasmine.any Function

            callback do
                isSuccess: false

            expect scope.laws .toEqual []

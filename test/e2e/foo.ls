should = chai.should!
test = it

describe \Array, ->
    describe '#indexOf()', ->
        test 'should return -1 when the value is not present', ->
            [1,2,3].indexOf 5 .should.eql -1;
            [1,2,3].indexOf 0 .should.eql -1;

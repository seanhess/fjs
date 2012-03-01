var assert = require('assert')
var f = require('./index')

describe('functional utils', function() {
    describe("partial application", function() {
        it('should apply stuff', function() {
            function add(a, b) {
                return a + b
            }

            function sub(a, b) {
                return a - b
            }

            var add2 = add.partial(2)
            assert.equal(add2(3), 5)

            var twoSub = sub.partial(2)
            assert.equal(twoSub(1), 1)

            var sub2 = sub.partialr(2)
            assert.equal(sub2(4), 2)
        })
    })
})
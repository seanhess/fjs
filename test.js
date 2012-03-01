var assert = require('assert')
var f = require('./index')
var _ = f._

describe('fjs', function() {
    describe("partial application", function() {

        function add(a, b) {
            return a + b
        }

        function sub(a, b) {
            return a - b
        }

        it('should apply left', function() {

            var add2 = add.partial(2)
            assert.equal(add2(3), 5)

            var twoSub = sub.partial(2)
            assert.equal(twoSub(1), 1)
        })

        it("should apply right", function() {
            var sub2 = sub.partialr(2)
            assert.equal(sub2(4), 2)
        })

        it("should apply with holes", function() {
            function joinSomeStrings(a,b,c) {
                return a + b + c
            }

            var joinWithDot = joinSomeStrings.partial(_, ".")
            assert.equal(joinWithDot("a", "b"), "a.b")

            joinWithDot = joinSomeStrings.partial(_, ".", _)
            assert.equal(joinWithDot("a", "b"), "a.b")
        })
    })
})
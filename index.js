
// WARNING! // This adds a few methods to Function.prototype as soon as you require it
// should I also allow you to pass in nulls to skip values? (or undefined)

Function.prototype.partial = function() {
    var f = this
    var args = Array.prototype.slice.call(arguments)
    return function(x) {
        return f.apply(null, args.concat(x))
    }
}

Function.prototype.partialr = function() {
    var f = this
    var args = Array.prototype.slice.call(arguments)
    return function(x) {
        return f.apply(null, [x].concat(args))
    }
}

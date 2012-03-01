
// WARNING! // This adds a few methods to Function.prototype as soon as you require it
// should I also allow you to pass in nulls to skip values? (or undefined)


// I think it's much more likely you'll want to apply with holes than it is that you'll 
// want to partially apply a null. You can always use undefined if you care :)

// oh, wait, this is really bad. What if the VARIALBES are null

exports._ = "fjs hole"

Function.prototype.partial = function() {
    var f = this
    var args = Array.prototype.slice.call(arguments)
    return function() {
        var innerArgs = Array.prototype.slice.call(arguments)

        // if any are null, pull elements off the front of innerArgs to fill them
        for (var i = 0; i < args.length; i++) {
            if (args[i] === exports._) {
                args[i] = innerArgs.shift()
            }
        }

        return f.apply(null, args.concat(innerArgs))
    }
}

// don't wory about holes here
Function.prototype.partialr = function() {
    var f = this
    var args = Array.prototype.slice.call(arguments)
    return function() {
        var innerArgs = Array.prototype.slice.call(arguments)
        return f.apply(null, innerArgs.concat(args))
    }
}

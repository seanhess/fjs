
// WARNING! // This adds a few methods to Function.prototype as soon as you require it

exports._ = "fjs hole"

// pass exports._ into partial to mean "stick a variable here". Variables will fill those holes
// or just apply left like normal
function partial() {
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
function partialr() {
    var f = this
    var args = Array.prototype.slice.call(arguments)
    return function() {
        var innerArgs = Array.prototype.slice.call(arguments)
        return f.apply(null, innerArgs.concat(args))
    }
}

// define on the prototype if it doesn't exist yet
if (!Function.prototype.partial) {
    Object.defineProperty(Function.prototype, "partial", {
        value: partial,
        enumerable: false
    })

    Object.defineProperty(Function.prototype, "partialr", {
        value: partialr,
        enumerable: false
    })
}

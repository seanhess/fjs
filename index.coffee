
## CURRY #########################################################
# makes it so you can call f with fewer than required arguments
# if you do, it returns a new function, with the initial arguments partially applied
exports.curry = curry = (f) ->

  call = (args...) ->

    # if we have at least as many arguments as our f supports
    # then call it
    if args.length >= f.length
      f args...

    # otherwise, return a function with the arguments partially applied
    else (args2...) ->
      innerArgs = args.concat(args2)
      call innerArgs...


# you don't really need partial here. This doesn't support partialr, or holes, but they're not actually that useful. Add support if you need them later

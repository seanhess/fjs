
# See README!

fjs = (_) ->
  # CURRY makes a function so you can call it with fewer arguments
  # it will turn add = (a,b) -> a+b into add = (a) -> (b) -> a+b
  # so you can call #2 with add(2)(4)
  curry = (f) ->
    call = (args...) ->

      # if we have at least as many arguments as our f supports
      # then call it
      if args.length >= f.length
        f args...

      # otherwise, return a function with the arguments partially applied
      else (args2...) ->
        innerArgs = args.concat(args2)
        call innerArgs...

  ## OBJECTS 
  # functional eqivalents to object-y stuff
  # you only need these so you can write point-free and compose
  # example
    # getName = get 'name'
    # getName(obj) is equivalent to obj.name
  get = curry (name, obj) -> obj[name]
  set = curry (name, value, obj) ->
    obj[name] = value
    return obj

  # Call a function on an object. 
  # curry this by hand, since curry doesn't work with optional arguments. Note that you can only curry this once!
  # example
    # woot = call 'woot'
    # woot(obj) is equivalent to obj.woot()
  call = (name, args...) ->
    (obj, innerArgs...) ->
      # get a better type error out when you fail
      if not obj[name]? or not _.isFunction(obj[name])
        throw new Error("Object #{obj} has no method #{name}")
      obj[name](args.concat(innerArgs)...)

  objects = {get, set, call}


  ## DEBUG
  log = (arg) ->
    console.log arg
    return arg

  debug = {log}

  ## BASICS
  eq = curry (a,b) -> b == a
  lt = curry (a,b) -> b < a
  lte = curry (a,b) -> b <= a
  gt = curry (a,b) -> b > a
  gte = curry (a,b) -> b >= a

  add = curry (a,b) -> b+a
  sub = curry (a,b) -> b-a # subtract a FROM b
  mult = curry (a,b) -> b*a
  div = curry (a,b) -> b/a

  negate = (a) -> !a

  basics = {eq, lt, lte, gt, gte, add, sub, mult, div, negate}

  ## UNDERSCORE
  # collections
  # we want to re-export these as a part of fjs. They come from underscore because it's there
  # underscore has the arguments in the wrong order. In order to do point-free functional programming we need to have the functions take their data last
  memoize = _.memoize
  compose = _.compose

  # these have optional arguments. flip by hand
  # example:
    # add2 = (item) -> item + 2
    # underscore version: map [1,2,3], add2
    # fjs version: 
      # map add2, [1,2,3]
      # add2ToEverything = map add2 <--- not possible in underscore
  find    = curry (iterator, list) -> _.find list, iterator
  map     = curry (iterator, list) -> _.map list, iterator
  filter  = curry (iterator, list) -> _.filter list, iterator
  each    = curry (iterator, list) -> _.each list, iterator
  min     = curry (iterator, list) -> _.min list, iterator
  max     = curry (iterator, list) -> _.max list, iterator
  sortBy  = curry (iterator, list) -> _.sortBy list, iterator
  groupBy = curry (iterator, list) -> _.groupBy list, iterator
  invoke  = curry (iterator, list) -> _.invoke list, iterator

  reduce  = curry (iterator, memo, list) -> _.reduce list, iterator, memo

  # first/head do NOT allow you to pass N, the number to grab. use "take" below instead
  head = first = _.first
  last = _.last
  tail = rest = _.rest

  us = {find, map, filter, reduce, memoize, compose, min, max, each, head, first, last, tail, rest, sortBy, groupBy, invoke}



  ## ARRAYS
  # non-destructive reverse
  reverse = (arr) -> arr.concat().reverse()

  # you MUST call this with a number. Returns the first N elements of an array
  take = curry (n, arr) -> first arr, n

  arrays = {reverse, take}

  # export!
  _.extend {curry}, objects, basics, us, arrays, debug

if define?.amd?
  define(['underscore'], (_) -> fjs _)

else if module?.exports?
  _ = require 'underscore'
  module.exports = fjs _



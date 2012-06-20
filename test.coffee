
# I want to run tests directly on this!
# just a mocha test. Doesn't say how it's run

assert = require 'assert'
_ = require 'underscore'

fjs = require './index'
call = fjs.call
curry = fjs.curry

describe 'fjs', ->

  describe 'curry', ->
    it 'should curry sum', ->
      add = curry (a, b) -> a + b
      add2 = add(2)

      assert.equal add(2,3), 5
      assert.equal add2(3), 5

  describe 'method', ->
    it 'should call something with this', ->
      name = (obj) -> obj.name
      henry = {name: "henry"}
      henry.getName = fjs.method name
      assert.equal henry.getName(), "henry"

  describe 'compose', ->
    it 'should throw an error if function is null', ->
      two = (thing) -> thing + "!"
      try
        stuff = fjs.compose two, one
      catch e
        err = e
      one = -> "one"
      assert.ok err, "no compose error"

  describe 'chain', ->
    it 'should work like compose', ->
      first = (array) -> array[0]
      name = (item) -> item.name

      items = [{name: "sean"}]

      composeValue = _.compose(name, first)(items)
      assert.equal composeValue, "sean", "compose incorrect"

      chainValue = fjs.chain(first, name)(items)
      assert.equal chainValue, "sean", "chain incorrect"

    it 'should throw an error if function is null', ->
      two = (thing) -> thing + "!"
      try
        stuff = fjs.chain two, one
      catch e
        err = e
      one = -> "one"
      assert.ok err, "no chain compose null error"

  describe 'series', ->
    it 'should do multiple async methods', (done) ->
      getData = (cb) -> process.nextTick -> cb null, "bob"
      getDetails = (id, cb) -> process.nextTick -> cb null, {id: id, message: "hi " + id}

      fjs.series getData, getDetails, (err, data) ->
        assert.ifError err
        assert.ok data
        assert.equal data.id, "bob"
        assert.equal data.message, "hi bob"
        done()

    it 'should handle sync methods', (done) ->
      getData = () -> "bob"
      getDetails = (id) -> {id: id, message: "hi " + id}

      fjs.series fjs.toAsync(getData), fjs.toAsync(getDetails), (err, data) ->
        assert.ifError err
        assert.ok data
        assert.equal data.id, "bob"
        assert.equal data.message, "hi bob"
        done()

    it 'should escape early on errors', (done) ->
      giveError = (cb) -> cb new Error "failed", {name: "woot"}
      dontCall = (data, cb) ->
        throw new Error "Should not have called this method"
      fjs.series giveError, dontCall, (err, data) ->
        assert.ok err
        assert.ok !data
        done()

    it 'should work with curry', (done) ->

      asyncAdd = curry (n, num, cb) ->
        cb null, num+n

      mult = curry (n, num) ->
        num*n

      fjs.series asyncAdd(2, 2), fjs.toAsync(mult(2)), (err, num) ->
        assert.ifError err
        assert.equal num, 8
        done()

    it 'should behave like compose and let you make one for use later', (done) ->
      console.log "NEXT"
      getData = (cb) -> process.nextTick -> cb null, "bob"
      getDetails = (id, cb) -> process.nextTick -> cb null, {id: id, message: "hi " + id}

      getDataDetails = fjs.makeSeries getData, getDetails
      getDataDetails (err, data) ->
        assert.ifError err
        assert.ok data
        assert.equal data.id, "bob"
        assert.equal data.message, "hi bob"
        done()

    it 'should scream if any methods do not exist in make series', (done) ->
      hello = (name, cb) -> cb null, ("hello, "+name)

      try
        doStuff = fjs.makeSeries asdf, hello
      catch e
        err = e

      assert.ok err, "should have thrown error"
      asdf = (cb) -> cb null, "asdf"
      done()

    it 'should return error if any methods do not exist in series', (done) ->
      hello = (name, cb) -> cb null, ("hello, "+name)

      fjs.series asdf, hello, (err, data) ->
        assert.ok err, 'no error'
        done()

      asdf = (cb) -> cb null, "asdf"

  describe 'call', ->
    it 'should call functions on the object', ->
      obj =
        name: "sean"
        getName: -> obj.name
        something: -> obj.called = true

      something = call 'something'
      something(obj)
      assert.ok obj.called, 'did not call something'

      getName = call 'getName'
      assert.equal getName(obj), 'sean', 'did not return function value'

    it 'should pass arguments through on the final call', ->
      obj = echo: (a) -> a
      echo = call 'echo'
      assert.equal echo(obj, 'a'), 'a', 'did not send arguments'

    it 'should apply arguments', ->
      obj = echo: (a) -> a
      echoHi = call 'echo', 'hi'
      assert.equal echoHi(obj), 'hi', 'did not apply arguments'
      
  describe 'objects', ->
    it 'should get and set', ->
      obj = {name: 'sean'}
      getName = fjs.get 'name'
      setName = fjs.set 'name'
      setNameBob = fjs.set 'name', 'bob'

      assert.equal getName(obj), 'sean'

      setName('henry', obj)
      assert.equal getName(obj), 'henry'

      setNameBob(obj)
      assert.equal getName(obj), "bob"


  describe 'basics', ->
    it 'eq', -> assert.equal fjs.eq(5,5), true
    it 'lt', -> assert.equal fjs.lt(4,5), false, "5 is not < 4"
    it 'lte', -> assert.equal fjs.lte(4,4), true

    it 'sub', -> assert.equal fjs.sub(3,8), 5, "8-3 is 5"

  describe 'underscore', ->
    it 'should work with data last', ->
      sub1 = fjs.sub(1)
      arr = fjs.map sub1, [1,2,3]
      assert.deepEqual arr, [0,1,2]

    it 'should filter', ->
      small = fjs.filter fjs.lt(3), [1,2,3,4]
      assert.deepEqual small, [1,2]

    it 'should min/max', ->
      objs = [{value:3}, {value:2}]
      minValue = fjs.min fjs.get('value')
      assert.deepEqual {value:2}, minValue objs

    it 'each should run with all args', ->
      bucket = []
      items = [1,2,3]
      fillBucket = (n) -> bucket.push n

      fjs.each fillBucket, items
      assert.deepEqual [1,2,3], bucket

    it 'each should curry', ->
      bucket = []
      items = [1,2,3]
      fillBucket = (n) -> bucket.push n

      fillBucketWithItems = fjs.each fillBucket

      assert.ok fillBucketWithItems, "result of applying each is undefined"
      fillBucketWithItems items

      assert.deepEqual [1,2,3], bucket

    it 'map should curry', ->
      add2 = fjs.add(2)
      add2ToItems = fjs.map add2

      assert.ok add2ToItems, "result of applying map is undefined"
      assert.deepEqual [3,4,5], add2ToItems([1,2,3])

  describe 'arrays', ->
    it 'should take (and curry)', ->
      assert.deepEqual fjs.take(2)([1,2,3]), [1,2]

    it 'should reverse without modifying', ->
      arr = [1,2,3]
      assert.deepEqual fjs.reverse(arr), [3,2,1]
      assert.deepEqual arr, [1,2,3]

  describe 'find', ->
    it 'should work with map on an empty array', ->
      seeking = [2,3]
      values = []
      isValue = curry (target, value) -> value is target
      findValue = curry (values, target) -> fjs.find isValue(target), values
      found = fjs.map findValue(values), seeking
      assert.deepEqual [undefined, undefined], found






## FJS: Functional Utils For Javascript

Functional Utilties for Javascript.

### Reasons

See this talk for motivation and some good examples. http://www.slideshare.net/drboolean/pointfree-functional-programming-in-javascript [Code Samples](https://github.com/DrBoolean/PointfreeJSTalk)

There are two main concepts this library uses. Currying (or partial application), and Point-free code, or higher-order programming

### Point-Free / Higher-order functions

We can do some powerful stuff by writing functions that create other functions. 

    TODO: add example

To define a function, we don't always have to actually make a function. Instead, we can rename an existing function. For example: 

    TODO: add example

### Currying / Partial Application


### Compose

    TODO: add example

## API

#### Curry

Allows you to easily curry functions. This means that if you call the curried version of a function with fewer arguments that it requires, it returns a function to call with the remaining arguments. The function short-circuits if you call it with the correct number of arguments, meaning that it doesn't affect performance unless it has to. 

See: http://en.wikipedia.org/wiki/Currying

The syntax looks best in coffeescript, because you can just prefix a function definition with curry. 

    curry = require('fjs').curry

    # just wrap your function in curry() and it will do the rest
    add = curry (a, b) -> a + b
    add2 = add(2)

    assert.equal add(2,3), 5
    assert.equal add2(3), 5
    assert.equal add(2)(3), 5

    assert.deepEqual [1,2,3].map(add(2)), [3,4,5]


#### Simple Stuff

We need some simple functions so we can call object actions as functions instead of doing it with a "."

    // get
    getName = get 'name'
    getName(obj) == obj.name

    // set
    setNameIsBob = set 'name', 'bob'
    setNameIsBob(obj)
    obj.name = 'bob'

    // call
    getName = call 'getName'
    getName(obj) == obj.getName()

    TODO: add example of application on set/call
    TODO: basics (eq, etc), and why. Example of why it's useful

#### Underscore Functions

[Underscore.js](http://underscorejs.org/) is awesome, but it puts the data first. For example, `underscore.map` is of type: `(list, iterator) ->`. This makes it nearly impossible to do point-free javascript. They're also not curried. For this reason, the following functions are taken from underscore, but they have their data last

Their types are all the same:

    find(iterator, list)

* find
* map
* filter 
* reducep
* each 
* min 
* max

You can curry these, for example:

    add2 = (n) -> n + 2
    add2ToEverything = map add2
    add2ToEverything [1,2,3]

We also export the following as-is for convenience

* head/first
* last
* tail/rest
* compose


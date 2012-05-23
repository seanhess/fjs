### FJS: Functional Utils For Javascript

Functional Utilties for Javascript

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



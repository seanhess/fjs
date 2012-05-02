### FJS: Functional Utils For Javascript

Functional Utilties for Javascript

#### Curry
    curry = require('fjs').curry

    add = curry (a, b) -> a + b
    add2 = add(2)

    assert.equal add(2,3), 5
    assert.equal add2(3), 5
    assert.equal add(2)(3), 5

    assert.deepEqual [1,2,3].map(add(2)), [3,4,5]



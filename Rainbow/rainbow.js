// Approximate racket functions
function circle(color) {
    print(`${color} circle`)
}
function square(color) {
    print(`${color} square`)
}
function print(shape) {
    console.log(shape)
}
// Cuz javascript doesn't have functional primitives
function first(list) {
    return list[0]
}
function rest(list) {
    return list.slice(1)
}

// Helper to cycle through the functions
function cycle(list) {
    return rest(list).concat(first(list))
}

// The actual function
function rainbow(...functions) {
    let colors = ['red', 'orange', 'yellow', 'green', 'blue', 'indigo', 'violet']
    function rainbowRecursive(functions, colors) {
        if (colors.length === 0) {
            return
        }
        first(functions)(first(colors))
        rainbowRecursive(cycle(functions), rest(colors))
    }
    rainbowRecursive(functions, colors)
}

rainbow(circle, square)
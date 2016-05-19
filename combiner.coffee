Common = require('./common')

class Combiner extends Common
  constructor: (@left, @right, @method) ->

  valueAt: (time) ->
    @method(@left.valueAt(time), @right.valueAt(time))

  @add: (left, right) -> new Combiner(left, right, (a,b) -> a + b)
  @subtract: (left, right) -> new Combiner(left, right, (a,b) -> a - b)
  @multiply: (left, right) -> new Combiner(left, right, (a,b) -> a * b)
  @divide: (left, right) -> new Combiner(left, right, (a,b) -> a / b)
  @exponent: (left, right) -> new Combiner(left, right, (a,b) -> a ** b)
  @modulo: (left, right) -> new Combiner(left, right, (a,b) -> a % b)
  @mix: (left, right) ->
    new Combiner(left, right, (a,b) ->
      # Normalise between 0 and 1
      a = (a + 1) / 2
      b = (b + 1) / 2
      z = if a < 0.5 and b < 0.5 then 2*a*b else 2*(a+b) - (2*a*b) - 1
      # Convert back
      return (z * 2) - 1
    )

module.exports = Combiner
Combiner = require('./combiner')

class Common
  combine: (type, other) ->
    switch type
      when 'add', 'plus' then Combiner.add(this, other)
      when 'sub', 'subtract', 'minus' then Combiner.subtract(this, other)
      when 'mul', 'multiply', 'times' then Combiner.multiply(this, other)
      when 'div', 'divide' then Combiner.divide(this, other)
      when 'exp', 'exponent', 'pow', 'power' then Combiner.exponent(this, other)
      when 'mod', 'modulo', 'rem', 'remainder' then Combiner.modulo(this, other)
      when 'mix' then Combiner.mix(this, other)
      else raise "Invalid combiner type #{type}"

  add: (other) -> @combine('add', other)
  subtract: (other) -> @combine('sub', other)
  divide: (other) -> @combine('div', other)
  multiply: (other) -> @combine('mul', other)
  exponent: (other) -> @combine('exp', other)
  modulo: (other) -> @combine('mod', other)
  mix: (other) -> @combine('mix', other)

  # Todo: phase shifter (pointless for oscillators as we have a phase lock...)

module.exports = Common

Combiner.prototype.__proto__ = Common.prototype
_ = require('underscore-node')

pi2 = Math.PI * 2;
tableLength = 1024
sinTable = _.times(tableLength, (i)-> Math.sin((pi2 * i) / tableLength))
cosTable = _.times(tableLength, (i)-> Math.cos((pi2 * i) / tableLength))

module.exports = class Oscillator
  constructor: (func, freq = 0)->
    @freq = freq
    @phase = 0
    @setFunction(func)
    this


  setFunction: (func)=>
    @func = switch func
      when 'sin', 'sine' then @sine
      when 'cos', 'cosine' then @cosine
      when 'sq', 'square' then @square
      when 'tri', 'triangle' then @triangle
      when 'saw', 'sawtooth' then @sawtooth
      else
        if _.isFunction(func)
          func
        else if _.isFunction(func.valueAt) # Chaining our library together...
          func.valueAt
        else
          console.log('Cannot set oscillator function to passed object', func)
          null
    this

  valueAt: (time)=>
    f = @freq.valueAt(time)
    i = @phase
    @phase = (@phase + (f / SampleRate)) % 1.0

    val = @func(i)

    return val

  sine: (phase) ->
    sinTable[Math.floor(phase * tableLength)]
  cosine: (phase) ->
    cosTable[Math.floor(phase * tableLength)]
  square: (phase) ->
    if phase <= 0.5 then 1 else -1
  triangle: (phase) ->
    if phase <= 0.25 then phase * 4
    else if phase <= 0.50 then 1 - (phase - 0.25) * 4
    else if phase <= 0.75 then 0 - (phase - 0.5) * 4
    else (phase - 0.75) * 4 - 1
  sawtooth: (phase) ->
    phase * 2 - 1

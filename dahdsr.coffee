class DAHDSREnvelope
  delay: 0
  attack: 0
  hold: 0
  decay: 0
  sustain: 0
  release: 0

  pressed: false # Not pressed
  pressedAt: null
  releasedAt: null
  releaseStart: null

  constructor: (@delay, @attack, @hold, @decay, @sustain, @release) ->

  tap: (time = @last) ->
    @pressedAt = time
    @releasedAt = time

  press: (time = @last) ->
    @pressed = true
    @pressedAt = time
    @releasedAt = null

  release: (time = @last) ->
    @pressed = false
    @releasedAt = time

  valueAt: (time) ->
    @last = time
    return 0 if @pressedAt == null

    # Find our place in the timeline...
    # Todo: cache state and do a simple switch?
    if @releaseStart == null
      offset = time - @pressedAt
      if offset < @delay
        return 0 # Delay holds at 0
      offset -= @delay

      if offset < @attack
        return offset / @attack # Ramp from 0 to 1 in attack time
      offset -= @attack

      if offset < @hold
        return 1 # Hold at 1
      offset -= @hold

      if offset < @decay
        return 1 - ((1 - @sustain) * (offset / @decay)) # Ramp from hold to sustain level...
      offset -= @decay

      # Sustain...
      if @pressed
        return @sustain

      # We need to start release here, set release start
      @releaseStart = time

    offset = time - @releasedAt
    if offset > @release
      @pressedAt = @releasedAt = @releaseStart = null # Clean up
      return 0

    return @sustain - ((offset / @release) * @sustain)

module.exports = DAHDSREnvelope
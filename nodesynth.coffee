_ = require('underscore-node')

Readable = require('stream').Readable;
Speaker = require('@jlaw90/speaker')
util = require('util')

# Change some built-in prototypes to allow interaction with the library
Number.prototype.valueAt = (time)-> this
Function.prototype.valueAt = (time) -> this(time)

exports.Oscillator = require('./oscillator')

exports.Synth = class extends Readable
    constructor: (opts) ->
        super({});
        options = {
            sampleRate: 44100,
            bitDepth: 16,
            channels: 1,
            bufferSize: 512
        }
        @options = _.extend(options, opts)

        @sampleRate = @options.sampleRate
        @timeStep = 1.0 / @sampleRate
        @channels = @options.channels
        @bitDepth = @options.bitDepth
        @source = null # Null default source
        @time = 0
        @buffer = new Buffer(@options.bufferSize)
        @multiplier = Math.floor((1 << @bitDepth) / 2) - 1; # Number to multiply a float in the range -1 to 1 by

        @speaker = new Speaker({
            channels: @channels,
            bitDepth: @bitDepth,
            sampleRate: @sampleRate,
            signed: true,
            float: false,
            samplesPerFrame: 10
        })
        this

    play: () =>
        this.pipe(@speaker)
        this

    stop: () =>
        this.unpipe(@speaker)
        this

    _read: (size) ->
        # Set some globals (oscillator needs to know sample rate, set every _read in case there are multiple
        # nodesynths...)
        global.SampleRate = @sampleRate

        if @source == null or !_.isFunction(@source.valueAt)
            @buffer.fill(0)
        else
           # Fill our audio buffer
           for i in [0...@buffer.length] by @bitDepth / 8
               val = this.source.valueAt(this.time)
               converted = val * @multiplier # Convert to correct integer range for our format
               for ri in [0...(@bitDepth / 8)] # Write in little endian order...
                   @buffer[i + ri] = (converted >> (ri * 8)) & 0xff;

               @time += @timeStep

        @push(@buffer) # Push our audio buffer to the 'Readable' internal buffer...
        true # Return true to indicate there is more data available

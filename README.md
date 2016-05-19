###Setup
Please make sure you have your environment configured to be able to install native node.js packages (required for audio support).

Run ``npm install nodesynth`` from the directory you'll be working in to download and install this package and all dependencies.

Then you can start ``node`` and play!

### Usage
Require nodesynth in your JavaScript file like so: ``require('nodesynth')``

From here, you only need to initialise a ``Synth`` object, set it's ``source`` property and call ``play``

A small example:

```javascript
var NodeSynth = require('nodesynth');

var ns = new NodeSynth.Synth({bitDepth: 16, sampleRate: 44100});
ns.play();

ns.source = new NodeSynth.Oscillator('sin', function(t){return 440 + ((t * 50) % 220)});
```

The library is built to be chainable, so you can pass an ``Oscillator`` as the ``frequency`` argument to the
``Oscillator`` constructor for example.

##### Oscillator
The ``Oscillator`` class takes two arguments to it's constructor, a ``function`` and the ``frequency``

Valid values for ``function`` are:
* 'sin' or 'sine' for a sine wave
* 'cos' or 'cosine' for a cosine wave
* 'sq' or 'square' for a square wave
* 'tri' or 'triangle' for a triangle wave
* 'saw' or 'sawtooth' for a sawtooth wave
* Any function that accepts a ``phase`` parameter
* Any library object that has a ``valueAt(time)`` function

Note that ``phase`` is a value between 0 and 1 depending on the position of the current oscillation cycle.  It will go from 0 to 1 at a rate of ``frequency`` times per second.

##### Note
There is an optional ``Note`` class that when required will pollute the global namespace with some useful variables such as A4, C3 - instances of a Note with their ``valueAt(time)`` parameter

Example:
```javascript
var NodeSynth = require('nodesynth');
require('nodesynth/notes'); // Optional

var ns = new NodeSynth.Synth();
ns.play();

ns.source = new NodeSynth.Oscillator('sq', A4.perfect_unison());
```

##### Combining
All built-in library objects (Oscillator, Combiner) inherit functions from the ``Common`` class, which has methods such as ``mix``, ``add``.

add, subtract, divide, multiply, exponent and modulo all explain their mathematical function.

``mix`` uses an algorithm to smoothly interleave the left and right hand sides to ensure they don't overflow the -1 and +1 boundaries of the audio signal.

An example (interesting alarm sound):
```javascript
var NodeSynth = require('nodesynth');

require('nodesynth/notes');

var ns = new NodeSynth.Synth();
ns.play();

var o1 = new NodeSynth.Oscillator('sin', A4);
var o2 = new NodeSynth.Oscillator('sin', B5).multiply(new NodeSynth.Oscillator('sq', 1).add(1).multiply(0.5));

ns.source = o1.mix(o2);
```
This example creates a LFO square wave (1Hz), adds 1 to the amplitude (the wave is between -1 and +1, adding 1 moves it to 0-2 range) and then multiplies that by 0.5 (normalising it to between 0 and 1).

This LFO square wave is then multiplied by a sinewave oscillator at frequency B5, the result of which is that the square wave will cancel out the B5 sine wave when in the low position (B5 * 0 = 0), and play the sine wave normally when in the high position (B5 * 1 = B5).  The combination of these functions is stored in variable o2.

o1 and o2 are then mixed and output to the speaker.

Try changing the oscillator functions and see how that affects the audio output.

### Todo
* ~~Add a simple ``Note`` abstraction for doing stuff like ``new NodeSynth.Oscillator('square', C4)``~~
* Add an ``Instrument`` abstraction with ADSR envelope
* Add a ``Sequence`` abstraction for describing a sequence of notes, times, strengths, etc.
* Add a ``Scale`` class with utility methods (first, second, tonic, subtonic, phygrian, )
* Add a ``Sampler`` for reading waveforms, performing FFT to get the frequency and rebuilding waveforms with the IFFT to modulate them
* ~~Add mixing functions such as ``add``, ``subtract``, ``multiply``, ``mix``, etc. (and mix them in...)~~
* Work out why there is so much latency (buffer size is small and so is ``samplesPerFrame``...)
* Investigate using MIDI inputs to control parameters
* Lots more...

### Nastiness
This library adds a ``valueAt(time)`` function to the ``Function`` and ``Number`` prototype's.
May do away with this in future, but it definitely simplifies some backend stuff.
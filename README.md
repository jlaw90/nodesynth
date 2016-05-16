###Setup
Please make sure you have your environment configured to be able to install native node.js packages (required for audio support).

Run ``npm install nodesynth`` from the directory you'll be working in to download and install this package and all dependencies.

Then you can start ``node`` and play!

### Usage
Require nodesynth in your JavaScript file like so: ``require('nodesynth')``

From here, you only need to initialise a ``Synth`` object, set it's ``source`` property and call ``play``

A small example:

    var NodeSynth = require('./lib/nodesynth');

    var ns = new NodeSynth.Synth({bitDepth: 16, sampleRate: 44100});
    ns.play();

    ns.source = new NodeSynth.Oscillator('sin', function(t){return 440 + ((t * 50) % 220)});

The library is built to be chainable, so you can pass an ``Oscillator`` as the ``frequency`` argument to the
``Oscillator`` constructor for example.

### Todo
* Add a simple ``Note`` abstraction for doing stuff like ``new NodeSynth.Oscillator('square', C4)``
* Add a ``Scale`` class with utility methods (first, second, tonic, subtonic, phygrian, )
* Add mixing functions
* Work out why there is so much latency (buffer size is small and so is ``samplesPerFrame``...)

### Nastiness
This library adds a ``valueAt(time)`` function to the ``Function`` and ``Number`` prototype's.
May do away with this in future, but it definitely simplifies some backend stuff.
chromaticInterval = 2 ** (1.0 / 12.0)

chromaticNotes = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B']

intervalMap = [
  ['perfect_unison', 'unison', 'P1', 'diminished_second', 'd2'],
  ['minor_second', 'm2', 'augmented_unison', 'A1', 'semitone', 'S'],
  ['major_second', 'M2', 'diminished_third', 'd3', 'tone', 'whole_tone', 'T'],
  ['minor_third', 'm3', 'augmented_second', 'A2'],
  ['major_third', 'M3', 'diminished_fourth', 'd4'],
  ['perfect_fourth', 'fourth', 'P4', 'augmented_third', 'A3'],
  ['tritone', 'diminished_fifth', 'd5', 'augmented_fourth', 'A4', 'TT'],
  ['perfect_fifth', 'fifth', 'P5', 'diminished_sixth', 'd6'],
  ['minor_sixth', 'm6', 'augmented_fifth', 'A5'],
  ['major_sixth', 'M6', 'diminished_seventh', 'd7'],
  ['minor_seventh', 'm7', 'augmented_sixth', 'A6'],
  ['major_seventh', 'M7', 'diminished_octave', 'd8'],
  ['perfect_octave', 'octave', 'P8', 'augmented_seventh', 'A7']
];

# An immutable note class
class Note
  constructor: (note, octave) ->
    @note = note.toUpperCase()
    @octave = octave

    raise "Invalid note value: #{note}" unless chromaticNotes.indexOf(@note) != -1
    raise "Invalid octave: #{octave}, must be >= 0" if octave < 0

    # Calculate frequency (notes are relative to A4 (440Hz))
    rn = -(chromaticNotes.indexOf('A') - chromaticNotes.indexOf(@note))
    ro = @octave - 4
    steps = (ro * 12) + rn
    @freq = 440 * (chromaticInterval**steps)

  valueOf: () -> @freq

  valueAt: (t) => @freq

  transpose: (semitones) ->
    oct = @octave
    ni = chromaticNotes.indexOf(@note)
    ni += semitones
    while ni >= chromaticNotes.length
      oct += 1
      ni -= chromaticNotes.length

    while ni < 0
      oct -= 1
      ni += chromaticNotes.length

    @constructor.retrieve(chromaticNotes[ni], oct)

  next: () -> @transpose(1)
  previous: () -> @transpose(-1)
  nextOctave: () -> @transpose(12)
  previousOctave: () -> @transpose(-12)

  toString: () -> "#{@note}#{@octave}"

  @retrieve: (note, octave) ->
    note = note.toUpperCase()
    name = note.replace('#', 'Sharp') + octave

    if not global[name]?
      global[name] = new Note(note, octave)

    global[name]

# Declare the interval mapping methods...
for names,interval in intervalMap
  for name in names
    Note.prototype[name] = () -> @transpose(interval)


#Define the notes from octave 0 to 9
for i in [0...9]
  for n in chromaticNotes
    Note.retrieve(n, i)
module.exports = Note;
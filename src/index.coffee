Alphabet = [
  '.'
  'abcdefghijklmnopqrstuvwxyz'
  '0123456789'
  '{}()<>[]'
  '=+-*/%^'
  '&?!:;'
  '#@_~$`|'
].join('')

Chunk  = 5
Offset = Math.pow(2,30)

Zero  = Alphabet[0]
Radix = Alphabet.length
Space = Math.pow(Radix,(Chunk-1))

Validater = new RegExp("^[#{Alphabet}]*$")
Chunker = new RegExp(".{1,#{Chunk}}",'g')
Striper = new RegExp("^[#{Zero}]*")


HDName =
  encode: (index) -> @_separate(index).map((s) => s.map((c) => @_reverse(@_encode(c - Offset))).join('')).join(Zero)

  decode: (name) -> @_flatten(name.split(Zero).map((k) => @_chunk(k+Zero).map((c) => @_decode(@_reverse(c)) + Offset)))

  _encode: (i) -> if (i) then HDName._encode(Math.floor(i/Radix)) + Alphabet[i % Radix] else ''

  _decode: (n) -> n.split('').reverse().reduce(((m,d,i) -> m + (Math.pow(Radix, i) * Alphabet.indexOf(d))), 0)

  _chunk: (str) -> str.match(Chunker)

  _flatten: (arr) -> [].concat(arr...)

  _reverse: (str) -> str.split('').reverse().join('')

  _separate: (arr) ->
    arr.reduce((m, c, i) =>
      m[m.length-1].push(c)
      m.push([]) if c < (Space + Offset) and i < arr.length - 1
      m
    , [[]])

exports = module.exports = HDName

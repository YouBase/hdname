chai = require 'chai'
expect = chai.expect

HDName = require '../src'

describe 'NamedKey', ->
  before ->
    @name = 'hello'
    @index = [1328595272, 1073741824]

    @longname = 'helloworld'
    @longindex = [1328595272, 1144071127, 1073741824]

    @zeroname = 'hello.world'
    @zeroindex = [1328595272, 1073741824, 1144071127, 1073741824]

    @defaultOffset = Math.pow(2,30)
    @maxDocumentIndex = Math.pow(32,5)

  describe 'encode', ->
    it 'should encode an index as a name', ->
      expect(HDName.encode(@index)).to.eql(@name)

    it 'should encode a long index as a name', ->
      expect(HDName.encode(@longindex)).to.eql(@longname)

    it 'should encode a multi key index as a name', ->
      expect(HDName.encode(@zeroindex)).to.eql(@zeroname)

  describe 'decode', ->
    it 'should decode a name as an index', ->
      expect(HDName.decode(@name)).to.eql(@index)

    it 'should decode a long name as an index', ->
      expect(HDName.decode(@longname)).to.eql(@longindex)

    it 'should decode a "." separated  name as an index', ->
      expect(HDName.decode(@zeroname)).to.eql(@zeroindex)

    it 'should decode the first part of a "." separated name as the name by itself', ->
      expect(HDName.decode(@zeroname).slice(0,2)).to.eql(@index)

  describe '_encode', ->
    it 'should convert 64 to a.', ->
      expect(HDName._encode(64)).to.eql('a.')

  describe '_decode', ->
    it 'should max out at  (2^31)-1 by default', ->
      expect(HDName._decode('|||||')).to.eql(Math.pow(2,30)-1)

  describe '_chunk', ->
    it 'should break a string into groups of 5 characters', ->
      expect(HDName._chunk(@longname)).to.eql(['hello', 'world'])

  describe '_flatten', ->
    it 'should make an array of arrays into an array of the values in each sub array', ->
      expect(HDName._flatten([[1,2,3], [4,5]])).to.eql([1,2,3,4,5])

  describe '_reverse', ->
    it 'should reverse the characters in a string', ->
      expect(HDName._reverse('hello')).to.eql('olleh')

  describe '_separate', ->
    it 'should break after @maxDocumentIndex', ->
      expect(HDName._separate(@zeroindex).length).to.equal(2)

should = require('chai').should()
Table = require '../lib/model/table.coffee'

describe 'Model/Table', ->
  X = Table.MOVE_X
  O = Table.MOVE_O

  describe '#constructor', ->
    table3x3 = '''___
                  ___
                  ___
              '''

    table5x5 = '''_____
                  _____
                  _____
                  _____
                  _____
               '''

    table1x1 = '_'
    table0x0 = ''

    it 'should create an empty 3x3 table', ->
      table = new Table(3,3)
      table.toString().should.eql table3x3

    it 'should create an empty 5x5 table', ->
      table = new Table 5,5
      table.toString().should.eql table5x5

    it 'should create an empty 1x1 table', ->
      table = new Table 1,1
      table.toString().should.eql table1x1

    it 'should create an empty 0x0 table', ->
      table = new Table 0,0
      table.toString().should.eql table0x0

    it 'should have first turn is X as default', ->
      table = new Table 3,3
      table.firstTurn.should.equal Table.MOVE_X

    it 'should have first turn as inputted (case insensitive)', ->
      table = new Table 3,3, 'O'
      table.firstTurn.should.equal Table.MOVE_O

      table = new Table 3,3, 'X'
      table.firstTurn.should.equal Table.MOVE_X

      table = new Table 3,3, 'o'
      table.firstTurn.should.equal Table.MOVE_O

      table = new Table 3,3, 'x'
      table.firstTurn.should.equal Table.MOVE_X

    it 'shouldn\'t have first turn other than X,O', ->
      table = new Table 3,3, 'Y'
      table.firstTurn.should.equal Table.MOVE_X

      table = new Table 3,3, 'a'
      table.firstTurn.should.equal Table.MOVE_X

  describe '#clean', ->
    table = new Table 3,3, 'x'
    emptyTable3x3 = '___\n___\n___'

    it 'should clean empty table', ->
      table.clean()
      table.toString().should.eql emptyTable3x3

    it 'should clean playing table and reset turns', ->
      table.clean()
      table.turn.should.equal Table.MOVE_X

      table.put 1,1
      table.clean()
      table.turn.should.equal Table.MOVE_X

  describe '#put', ->
    table = new Table 3,3, 'x'

    afterEach -> table.clean()

    it 'should put correctly first turn', ->
      table.put 0,0
      table.toString().should.eql '''X__
                                     ___
                                     ___'''

    it 'should throws error Out of Range', ->
      fn = ()-> table.put -1, 0
      fn.should.throw 'Out of Range'

      fn = ()-> table.put 0, -1
      fn.should.throw 'Out of Range'

      fn = ()-> table.put -1, -1
      fn.should.throw 'Out of Range'

      fn = ()-> table.put 3, 1
      fn.should.throw 'Out of Range'

      fn = ()-> table.put 2, 3
      fn.should.throw 'Out of Range'

    it 'should put correctly on every turn', ->
      table.put 0,0 # x
      table.put 0,1 # o
      table.put 0,2 # x
      table.put 1,0 # o
      table.put 1,1 # x
      table.put 1,2 # o
      table.put 2,0 # x
      table.put 2,1 # o
      table.put 2,2 # x

      table.toString().should.eql 'XOX\nOXO\nXOX'

    it "shouldn't put same position twice", ->
      fn = ->
        table.put 0,0
        table.put 0,0

      fn.should.throw 'Already Exists'


  describe "#getRowOf", ->
    it "should return as many as 9 slots when possible", ->
      table = new Table 11,11
      x = 1
      table.put x,y for y in [0..10]
      #console.log 'table\n01234567890123\n' + table.toString()

      row = table.getRowOf x, 5
      row.length.should.equal 9
      row.should.eql [O,X,O, X,O,X, O,X,O]

      row = table.getRowOf x, 2
      row.length.should.equal 7
      row.should.eql [X, O,X,O, X,O,X]

      row = table.getRowOf x, 9
      row.length.should.equal 6
      row.should.eql [O,X,O, X,O,X]

  describe "#getColOf", ->
    it "should return as many as 9 slots when possible", ->
      table = new Table 11,11
      y = 1
      table.put x,y for x in [0..10]
      console.log 'table\n01234567890123\n' + table.toString()

      row = table.getColOf 5, y
      row.length.should.equal 9, "x=5, y=#{y}"
      row.should.eql [O,X,O, X,O,X, O,X,O]

      row = table.getColOf 2, y
      row.length.should.equal 7, "x=2, y=#{y}"
      row.should.eql [X, O,X,O, X,O,X]

      row = table.getColOf 9, y
      row.length.should.equal 6, "x=9, y=#{y}"
      row.should.eql [O,X,O, X,O,X]

  describe "#getBackwardDiagonal", ->
    it "should return as many as 9 slots when possible", ->
      table = new Table 11,11
      x = 0
      y = 3
      try
        table.put x++,y++ for i in [0..10]
      catch ex

      x = 0
      y = 0
      try
        table.put x++,y++ for i in [0..10]
      catch ex


      x = 6
      y = 0
      try
        table.put x++,y++ for i in [0..10]
      catch ex

      console.log 'table\n01234567890123\n' + table.toString()

#      row = table.getRowOf x, 5
#      row.length.should.equal 9
#      row.should.eql [O,X,O, X,O,X, O,X,O]
#
#      row = table.getRowOf x, 2
#      row.length.should.equal 7
#      row.should.eql [X, O,X,O, X,O,X]
#
#      row = table.getRowOf x, 9
#      row.length.should.equal 6
#      row.should.eql [O,X,O, X,O,X]
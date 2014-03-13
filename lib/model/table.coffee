class Table
  MOVE_X = @MOVE_X = 'X'
  MOVE_O = @MOVE_O = 'O'
  MOVE_EMPTY = @MOVE_EMPTY = '_'
  MAX = 5

  switchTurn = (table)->
    table.turn = if table.turn is MOVE_X then MOVE_O else MOVE_X


  constructor: (@x=20, @y=20, @firstTurn=MOVE_X)->
    ## @x: row number, @y: col num
    @table = []
    return if x == y == 0
    @clean()

    @firstTurn = @firstTurn.toUpperCase()
    if @firstTurn isnt MOVE_O then @firstTurn = MOVE_X
    @turn = @firstTurn

  clean: (empty = MOVE_EMPTY)->
    table = []
    for x in [1..@x]
      array = []
      table.push array
      for y in [1..@y]
        array.push empty

    @table = table
    @turn = @firstTurn
    return

  toString: ()->
    rows = @table.map (row)-> row.join ''
    rows.join '\n'

  put: (x,y)->
    throw new Error "Out of Range" unless 0 <= x < @x and 0 <= y < @y
    throw new Error "Already Exists" if @table[x][y] isnt MOVE_EMPTY
    @table[x][y] = @turn
    switchTurn this

  getRowOf: (x,y)->
    row = @table[x]
    min = y - MAX + 1
    max = y + MAX - 1

    min = if min < 0 then 0 else min
    max = if max >= @x then @x-1 else max

    #console.log 'min, max', min, max
    row[min..max]

  getColOf: (x,y)->
    col = (row[y] for index,row of @table)
    #console.log 'col', col

    min = x - MAX + 1
    max = x + MAX - 1

    min = if min < 0 then 0 else min
    max = if max >= @y then @y-1 else max

    #console.log 'min, max', min, max
    col[min..max]


module.exports = Table

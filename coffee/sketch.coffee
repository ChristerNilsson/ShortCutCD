ROWS = 3
COLS = 4
CHOICES = [] 

ADD = 2
MUL = 2
DIV = 2
MAX = 20
COST = 10
PLAYERS = 12

level = 1
players = []
target = 0
solution = null

class Player
	constructor : (@start, @row, @col, @keys) ->
		@bg = if (@row+@col) % 2 == 0 then "#ff0" else "#f00"

		@w = width * 0.25
		@left = @w * @col 
		@xmiddle = @left + @w / 2

		@h = height * 0.25
		@up = @h * @row
		@ymiddle = @up + @h / 2

		@history = []
		@tid = 0
		@startTid = new Date()

		@index = 0

	draw : ->
		if @start == target
			fill "#0f0"
			textSize 0.05*height
			textAlign CENTER,CENTER
			sc 0
			rect @left,@up,@w,@h
			fc 0
			sc()
			text @keys, @xmiddle, @ymiddle
			text @tid,  @xmiddle, @ymiddle+0.25*@h
		else
			fill @bg
			textSize 0.05*height
			textAlign CENTER,CENTER
			sc 0
			rect @left,@up,@w,@h
			fc 0
			sc()
			text @start,          @xmiddle, @ymiddle-0.25*@h
			text @keys,           @xmiddle, @ymiddle
			text CHOICES[@index], @xmiddle, @ymiddle+0.25*@h

	operate : (newValue) ->
		@history.push @start
		@start = newValue
		if @start == target then @stoppTid = new Date()

	click : (key) ->
		if @start == target then return		
		keys = _.clone @keys
		key = key.toUpperCase()
		if key == keys[0].toUpperCase() then @index = (@index + 1) % CHOICES.length
		if key == keys[1].toUpperCase() 
			if @index == 0 and @history.length > 0 then @start = @history.pop()
			if @index == 1 then	@operate @start * MUL
			if @index == 2 then	@operate @start + ADD
			if @index == 3 and @start % DIV == 0 then @operate @start / DIV

		if @start == target
			@stoppTid = new Date()
			@tid = myRound (@stoppTid - @startTid)/1000 + COST * @history.length, 3

myRound = (x,n) -> round(x*10**n)/10**n

createTarget = (level, start) ->
	op = (from,nr) ->
		if nr not of comeFrom
			b.push nr
			comeFrom[nr] = from
	a = [start]
	comeFrom = {}
	comeFrom[start] = 0
	for i in range level
		b = []
		for nr in a
			op nr,nr + ADD 
			op nr,nr * MUL
			if nr % DIV == 0 then op nr,nr / DIV 
		a = _.uniq b
	target = _.sample a
	result = []
	while target != 0
		result.unshift target
		target = comeFrom[target]
	console.log comeFrom
	result

newGame = (delta=0) ->
	players = []
	level += delta
	if level < 1 then level = 1
	startTid = new Date()
	start = _.random 1,MAX
	solution = createTarget level, start
	target = _.last solution
	keys = 'QWERTYUIASDFGHJKZXCVBNM,'
	if PLAYERS == 2 then keys = 'QWIO'
	if PLAYERS == 3 then keys = 'QWTYOP'
	for i in range PLAYERS
		row = floor i / 4
		col = i % 4
		players.push new Player start,row,col, keys[2*i] + keys[2*i+1]

setup = ->
	createCanvas windowWidth,windowHeight
	params = _.extend {ADD:2, MUL:2, DIV:2, MAX:20, COST:10, PLAYERS:12}, getParameters()
	ADD = int params.ADD
	MUL = int params.MUL
	DIV = int params.DIV
	MAX = int params.MAX
	COST = int params.COST
	PLAYERS = int params.PLAYERS
	CHOICES = "undo *#{MUL} +#{ADD} /#{DIV}".split ' '
	newGame()

draw = ->
	bg 1
	player.draw() for player in players
	sc()
	text target, width * 0.5, 0.75*height + 0.33*players[0].h
	text "level: #{level}", width * 0.5, 0.75*height + 0.67*players[0].h

keyPressed = -> 
	if key == 'Enter' then console.log solution
	else if key == "ArrowUp" then newGame 1
	else if key == "ArrowDown" then newGame -1
	else player.click key for player in players

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

class Player
	constructor : (@start, @target, @row, @col, @keys) ->
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
		if @start == @target
			fill "#0f0"
			textSize 0.05*height
			textAlign CENTER,CENTER
			sc 0
			rect @left,@up,@w,@h
			fc 0
			text @keys, @xmiddle, @ymiddle
			text @tid,  @xmiddle, @ymiddle+50
		else
			fill @bg
			textSize 0.05*height
			textAlign CENTER,CENTER
			sc 0
			rect @left,@up,@w,@h
			fc 0
			text @start,           @xmiddle, @ymiddle-50
			text @keys,            @xmiddle, @ymiddle
			text CHOICES[@index], @xmiddle, @ymiddle+50

	operate : (newValue) ->
		@history.push @start
		@start = newValue
		if @start == @target then @stoppTid = new Date()

	click : (key) ->
		if @start == @target then return		
		keys = _.clone @keys
		key = key.toUpperCase()
		if key == keys[0].toUpperCase() then @index = (@index + 1) % CHOICES.length
		if key == keys[1].toUpperCase() 
			if @index == 0 and @history.length > 0 then @start = @history.pop()
			if @index == 1 then	@operate @start + ADD
			if @index == 2 then	@operate @start * MUL
			if @index == 3 and @start % DIV == 0 then @operate @start / DIV

		if @start == @target
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
	for i in range PLAYERS
		row = floor i / 4
		col = i % 4
		players.push new Player start,target,row,col, keys[2*i] + keys[2*i+1]

setup = ->
	createCanvas windowWidth,windowHeight
	params = getParameters()
	console.log params
	ADD = params.ADD || 2
	MUL = params.MUL || 2
	DIV = params.DIV || 2
	MAX = params.MAX || 20
	COST = params.COST || 10
	PLAYERS = params.PLAYERS || 12

	CHOICES = "undo +#{ADD} *#{MUL} /#{DIV}".split ' '
	newGame()

draw = ->
	bg 1
	player.draw() for player in players
	sc()
	text players[0].target, width * 0.5, 0.8*height
	text "level: #{level}", width * 0.5, 0.9*height

keyPressed = -> 
	if key == "ArrowUp" then newGame 1
	else if key == "ArrowDown" then newGame -1
	else player.click key for player in players

ROWS = 3
COLS = 4
CHOICES = 'undo +2 *2 /2'.split ' '
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
			if @index == 1 then	@operate @start + 2
			if @index == 2 then	@operate @start * 2
			if @index == 3 and @start % 2 == 0 then  @operate @start / 2

		if @start == @target
			@stoppTid = new Date()
			@tid = myRound (@stoppTid - @startTid)/1000 + 10 * @history.length, 3

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
			op nr,nr + 2
			op nr,nr * 2
			if nr % 2 == 0 then op nr,nr / 2
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
	start = _.random 1,20
	solution = createTarget level, start
	target = _.last solution
	keys = 'QWERTYUIASDFGHJKZXCVBNM,'
	for row in range ROWS
		for col in range COLS
			index = COLS*row+col
			players.push new Player start,target,row,col, keys[2*index] + keys[2*index+1]

setup = ->
	createCanvas windowWidth,windowHeight
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

# + * /
# 7    Start {7:0}
# 9    14                                1 operation   {7:0, 9:7, 14:7}
# 11    18         16        28 (7)      2 operationer {7:0, 9:7, 14:7, 11:9, 18:9, 16:14, 28:14}
# 13 22 20 36 (9) (18) 32 8 30 56 (14)   3 operationer {7:0, 9:7, 14:7, 11:9, 18:9, 16:14, 28:14, 13:11, 22:11, 20:18, 36:16, 32:16, 8:16, 30:28, 56:28}

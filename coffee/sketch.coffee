# W    A    S    D
# up   left down right
# undo +2   *2   /2

level = 1
players = []

class Player
	constructor : (@start, @target, @left, @right, @bg, @keys) ->
		@history = []
		@tid = 0
		@middle = (@left + @right) / 2
		@startTid = new Date()

	draw : ->
		fill @bg
		textSize 30
		textAlign CENTER,CENTER
		rect @left * width,0,width / 2,height
		fc 0
		x1 = @middle - 0.1
		x2 = @middle + 0.1
		y1 = 0.2
		y2 = 0.4
		text @start,         width * x1, y1 * height 
		text @target,        width * x2, y1 * height
		text @history.length,width * x1, y2 * height
		text @tid/1000,      width * x2, y2 * height
		@help()

	help : ->
		textSize 0.05*height
		lst = (key.replace("Arrow","") for key in @keys)
		x1 = @middle - 0.15
		x2 = @middle 
		x3 = @middle + 0.15
		y1 = 0.6
		y2 = 0.8
		text "Undo: " + lst[0], width * x2, y1 * height
		text "+2: "   + lst[1], width * x1, y2 * height
		text "*2: "   + lst[2], width * x2, y2 * height
		text "/2: "   + lst[3], width * x3, y2 * height

	operate : (newValue) ->
		@history.push @start
		@start = newValue
		if @start == @target then @stoppTid = new Date()

	click : (key) ->
		if @start == @target then return
		key = key.toUpperCase()
		if key == @keys[0].toUpperCase() and @history.length > 0 then @start = @history.pop()
		if key == @keys[1].toUpperCase() then	@operate @start + 2
		if key == @keys[2].toUpperCase() then	@operate @start * 2
		if key == @keys[3].toUpperCase() and @start % 2 == 0 then @operate @start / 2
		if @start == @target
			@stoppTid = new Date()
			@tid = @stoppTid - @startTid + 10000 * @history.length


createTarget = (level, start) ->

	op = (nextValue) ->
		if nextValue not in visited 
			b.push nextValue
			visited.push nextValue

	a = [start]
	visited = [start]
	for i in range level
		b = []
		for nr in a
			op nr+2
			op nr*2
			if nr%2==0 then op nr/2	

		b = _.uniq b
		[a,b] = [b,a]
	_.sample a

setup = ->
	createCanvas windowWidth,windowHeight
	startTid = new Date()
	level = 3
	start = _.random 1,20
	target = createTarget level, start
	players.push new Player start,target,0.00,0.50, "#ff0", "W A S D".split ' '
	players.push new Player start,target,0.50,1.00, "#f00", "ArrowUp ArrowLeft ArrowDown ArrowRight".split ' '

draw = -> player.draw() for player in players
keyPressed =()-> player.click key for player in players

# + * /
# 7    Start
# 9    14                                1 operation
# 11    18         16        28 (7)      2 operationer
# 13 22 20 36 (9) (18) 32 8 30 56 (14)   3 operationer



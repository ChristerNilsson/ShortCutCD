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
		textSize 0.05*height
		textAlign CENTER,CENTER
		rect @left * width,0,width * (@right-@left),height
		fc 0
		x1 = @middle - 0.05
		x2 = @middle + 0.05
		y1 = 0.2
		y2 = 0.4
		text @start,         width * @middle, y1 * height 
		# text @target,        width * x2, y1 * height
		text level - @history.length, width * x1, y2 * height
		text @tid/1000,      width * x2, y2 * height
		@help()

	help : -> hlp @keys, @middle

	operate : (newValue) ->
		@history.push @start
		@start = newValue
		if @start == @target then @stoppTid = new Date()

	click : (key) ->
		keys = _.clone @keys
		if keys[0] == "🡑" then keys[0] = "ArrowUp" # 🡑 🡐 🡓 🡒
		if keys[1] == "🡐" then keys[1] = "ArrowLeft" 
		if keys[2] == "🡓" then keys[2] = "ArrowDown" 
		if keys[3] == "🡒" then keys[3] = "ArrowRight" 
		if @start == @target then return
		
		key = key.toUpperCase()
		if key == keys[0].toUpperCase() and @history.length > 0 then @start = @history.pop()
		if key == keys[1].toUpperCase() then	@operate @start + 2
		if key == keys[2].toUpperCase() then	@operate @start * 2
		if key == keys[3].toUpperCase() and @start % 2 == 0 then @operate @start / 2
		if @start == @target
			@stoppTid = new Date()
			@tid = @stoppTid - @startTid + 10000 * @history.length

hlp = (keys, middle)->
	textSize 0.05*height
	lst = keys # (key.replace("Arrow","") for key in @keys)
	x1 = middle - 0.05
	x2 = middle 
	x3 = middle + 0.05
	y1 = 0.6
	y2 = 0.8
	text lst[0], width * x2, y1 * height
	text lst[1], width * x1, y2 * height
	text lst[2], width * x2, y2 * height
	text lst[3], width * x3, y2 * height

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
	players.push new Player start,target,0.00,0.20, "#ff0", "W A S D".split ' '
	players.push new Player start,target,0.20,0.40, "#f00", "T F G H".split ' '	
	players.push new Player start,target,0.60,0.80, "#0f0", "I J K L".split ' '
	players.push new Player start,target,0.80,1.00, "#0ff", "🡑 🡐 🡓 🡒".split ' '

draw = -> 
	bg 1
	for player in players
		player.draw() 
	sc()
	hlp "Undo +2 *2 /2".split(' '), 0.5  # ["Undo", '+2',,,]
	text players[0].target,        width * 0.5, 0.2*height


	

keyPressed =()-> player.click key for player in players		

# + * /
# 7    Start
# 9    14                                1 operation
# 11    18         16        28 (7)      2 operationer
# 13 22 20 36 (9) (18) 32 8 30 56 (14)   3 operationer



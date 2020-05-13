# W    A    S    D
# up   left down right
# undo +2   *2   /2

class Player
	constructor : (@left, @right, @bg, @keys) ->
		@start = 3
		@target = 2
		@history = []
		@tid = 0
		@middle = (@left+@right)/2

	draw : ->
		fill @bg
		rect @left*width,0,width/2,height
		fc 0
		text @start,width*(@middle-0.10),100
		text @target,width*(@middle+0.10),100
		text @history.length,width*(@middle-0.10),200
		text @tid/1000,width*(@middle+0.10),200

		@help()

	help : ->
		text @keys[0]

	operate : (newValue) ->
		@history.push @start
		@start = newValue

	click : (key) ->
		if @start == @target then return
		key = key.toUpperCase()
		if key == @keys[0] and @history.length > 0 then @start = @history.pop()
		if key == @keys[1] then	@operate @start+2
		if key == @keys[2] then	@operate @start*2
		if key== @keys[3] and @start % 2 == 0 then @operate @start/2
		if @start == @target then @tid = (new Date()) - timestart

timestart = new Date()
players = []

setup = ->
	createCanvas windowWidth,windowHeight
	players.push new Player 0.00,0.50, "#ff0", "W A S D".split ' ' # ["W","A","S","D"]
	players.push new Player 0.50,1.00, "#f00", "ARROWUP ARROWLEFT ARROWDOWN ARROWRIGHT".split ' '
	#timestart = new Date()

draw = ->
	textSize 30
	#bg 0.5
	for player in players
		player.draw()
	
keyPressed =()->
	console.log keyCode,key
	for player in players
		player.click key 


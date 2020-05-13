# W    A    S    D
# up   left down right
# undo +2   *2   /2

level = 1

class Player
	constructor : (@start, @target, @left, @right, @bg, @keys) ->
		@history = []
		@tid = 0
		@middle = (@left+@right)/2
		@startTid = new Date()
		#@stoppTid = new Date()

	draw : ->
		fill @bg
		textSize 30
		textAlign CENTER,CENTER
		rect @left*width,0,width/2,height
		fc 0
		text @start,width*(@middle-0.10),0.2*height 
		text @target,width*(@middle+0.10),0.2*height
		text @history.length,width*(@middle-0.10),0.4*height
		text @tid/1000,width*(@middle+0.10),0.4*height

		@help()

	help : ->
		textSize 0.05*height
		lst = (key.replace(/Arrow/g,"") for key in @keys)
		text "Undo: "+lst[0], width*(@middle),0.6*height
		text "+2: "+lst[1], width*(@middle-0.15),0.8*height
		text "*2: "+lst[2], width*(@middle),0.8*height
		text "/2: "+lst[3], width*(@middle+0.15),0.8*height
		
	operate : (newValue) ->
		@history.push @start
		@start = newValue
		if @start==@target then @stoppTid = new Date()

	click : (key) ->
		if @start == @target then return
		key = key.toUpperCase()
		if key == @keys[0].toUpperCase() and @history.length > 0 then @start = @history.pop()
		if key == @keys[1].toUpperCase() then	@operate @start+2
		if key == @keys[2].toUpperCase() then	@operate @start*2
		if key== @keys[3].toUpperCase() and @start % 2 == 0 then @operate @start/2
		if @start == @target
			@stoppTid=new Date()
			@tid = @stoppTid - @startTid + 10000 * @history.length

#timestart = new Date()
players = []

createNumbers = (level, start) ->
	lst0 = [start]
	for i in range level
		#console.log lst0
		lst1 = []
		for number in lst0
			lst1.push number+2
			lst1.push number*2
			if number%2==0 then lst1.push number/2
		lst1 = _.uniq lst1	
		[lst0,lst1] = [lst1,lst0] 
	[start, _.sample lst0]

setup = ->
	createCanvas windowWidth,windowHeight
	startTid = new Date()
	level = 3
	[start,target] = createNumbers level, _.random 1,20 
	players.push new Player start,target,0.00,0.50, "#ff0", "W A S D".split ' ' # ["W","A","S","D"]
	players.push new Player start,target,0.50,1.00, "#f00", "ArrowUp ArrowLeft ArrowDown ArrowRight".split ' '
	#timestart = new Date()

draw = ->
	#bg 0.5
	for player in players
		player.draw()
	
keyPressed =()->
	console.log keyCode,key
	for player in players
		player.click key 

# + * /
# 3    Start
# 5    6                                1 operation
# 7    10         8        12 (3)       2 operationer
# 9 14 12 20 (5) (10) 16 4 (14) 24 (6)  3 operationer


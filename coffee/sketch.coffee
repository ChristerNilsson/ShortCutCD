KEYS = "undo +2 *2 /2".split ' '

level = 0
players = []
buttons = []

# to make this multiplayer with Browser Preview
d = new Date()
seed = 60*d.getHours() + d.getMinutes()
fract = (x) -> x - Math.floor x
myRandom = -> fract 10000 * Math.sin seed++
myRandint = (a,b) -> int a + (b-a) * myRandom()

class Button
	constructor : (@x,@y,@prompt,@click) ->
		@x *= width
		@y *= height
		@r = 0.07 * height
	draw : ->
		fc()
		sc 0
		circle @x,@y,@r
		fc 0
		sc()
		text @prompt,@x,@y
	inside: (mx,my) -> dist(mx,my,@x,@y) < @r

class Player
	constructor : (@start, @target, @left, @right, @bg, @name) ->
		@history = []
		@tid = 0
		@middle = (@left + @right) / 2
		@startTid = new Date()
		x = @middle 
		@count = 0
		buttons.push new Button x,0.51,KEYS[0], => @click 0
		buttons.push new Button x,0.65,KEYS[1], => @click 1
		buttons.push new Button x,0.79,KEYS[2], => @click 2
		buttons.push new Button x,0.93,KEYS[3], => @click 3

	draw : ->
		if @start==@target then fill "#0f0" else fill @bg
		textSize 0.04*height
		textAlign CENTER,CENTER
		rect @left * width,0,width * (@right-@left),height
		fc 0
		text @name,                   width * @middle, 0.05 * height
		text @start,                  width * @middle, 0.15 * height
		text @target,                 width * @middle, 0.20 * height
		text level - @history.length, width * @middle, 0.30 * height
		text @tid/1000,               width * @middle, 0.40 * height

	operate : (newValue) ->
		@count++
		@history.push @start
		@start = newValue
		if @start == @target then @stoppTid = new Date()

	click : (index) ->
		if @start == @target then return
		if index==0 and @history.length > 0 then @start = @history.pop()
		if index==1 then	@operate @start + 2
		if index==2 then	@operate @start * 2
		if index==3 and @start % 2 == 0 then @operate @start / 2
		if @start == @target
			@stoppTid = new Date()
			@tid = @stoppTid - @startTid + 10000 * @count #history.length

createTarget = (level, start) ->
	op = (nr) -> if nr not in visited then b.push nr
	a = [start]
	visited = [start]
	for i in range level
		b = []
		for nr in a
			op nr + 2
			op nr * 2
			if nr % 2 == 0 then op nr / 2
		b = _.uniq b
		visited = visited.concat b
		[a,b] = [b,a]
	a[myRandint 0,a.length-1]

setup = ->
	createCanvas windowWidth,windowHeight
	newGame 1

draw = ->
	bg 1
	for player in players
		player.draw()
	for button in buttons
		button.draw()

newGame = (delta) ->
	level += delta
	if level == 0 then level = 1
	startTid = new Date()
	start = myRandint 1,20
	target = createTarget level, start
	players = []
	players.push new Player start,target,0.00,0.10, "#ff0", 'Alex'
	players.push new Player start,target,0.10,0.20, "#f00", 'Lowe'
	players.push new Player start,target,0.20,0.30, "#f0f", 'Mark'
	players.push new Player start,target,0.30,0.40, "#0ff", 'Tim'
	players.push new Player start,target,0.40,0.50, "#ff0", 'Christer'
	players.push new Player start,target,0.50,0.60, "#f00", 'F'
	players.push new Player start,target,0.60,0.70, "#f0f", 'G'
	players.push new Player start,target,0.70,0.80, "#0ff", 'H'
	players.push new Player start,target,0.80,0.90, "#f0f", 'I'
	players.push new Player start,target,0.90,1.00, "#0ff", 'J'

keyPressed = -> 
	if key == ' ' then newGame 0 
	if key in 'uU+' then newGame 1
	if key in 'dD-' then newGame -1

mousePressed = ->
	for button in buttons
		if button.inside mouseX,mouseY then button.click()

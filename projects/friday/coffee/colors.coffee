stageWidth = Crafty.stage.elem.offsetWidth
stageHeight = Crafty.stage.elem.offsetHeight
SPEED = 5

Crafty.sprite(1, "imgs/triangle.png",
    red: [0, 0, 60, 60]
    #orange: [60, 0, 60, 60]
    yellow: [60, 0, 60, 60]
    #green: [180, 0, 60, 60]
    blue: [120, 0, 60, 60]
    #purple: [300, 0, 60, 60]
)
Crafty.background "#FFFFFF"


options =
    maxParticles: 10
    size: 5
    speed: 1
    # Lifespan in futurerames
    lifeSpan: 10
    # Angle is calculated                         clockwise: 12pm is 0deg, 3pm is 90deg etc.
    angle: 210
    startColour: [255, 0, 0, 1]
    endColour: [0, 0, 0, 0]
    # Only applies when fastMode is off, specifies how sharp the gameradients are drawn
    sharpness: 10
    # Random spread from origin
    spreadX: 0
    spreadY: 0

    # How many frames should this                 last
    duration: -1
    # Will draw squares instead of circle gradientsts
    fastMode: false
    gravity: { x: 0, y: 0.2 }
    # sensible valxues are 0-3
    jitter: 0


Crafty.e("2D, Canvas, Player, red, Collision")
    .attr(
        x: stageWidth * .5 - 30
        y: stageHeight - 140
        z: 6
        currentColor: "red"
        setColor: (color) ->
            @removeComponent @currentColor if @currentColor?
            @currentColor = color
            @addComponent @currentColor

    )
    .collision([30,0], [60,60], [0,60])


Crafty.e("2D, Canvas, Color")
    .attr(
        x: 0
        y: stageHeight - 50
        z: 2
        w: stageWidth
        h: 50
    )
    .color("#969696")

Crafty.e("2D, Canvas, Color, Mouse")
    .attr(
        x: stageWidth*0.5 - 80
        y: stageHeight - 45
        z: 8
        w: 40
        h: 40
    )
    .bind "Click", ->
        player = Crafty("Player")
        player.setColor "red"
    .color("red")

Crafty.e("2D, Canvas, Color, Mouse")
    .attr(
        x: stageWidth*0.5 - 20
        y: stageHeight - 45
        z: 9
        w: 40
        h: 40
    )
    .bind "Click", ->
        player = Crafty("Player")
        player.setColor "yellow"
    .color("yellow")

Crafty.e("2D, Canvas, Color, Mouse")
    .attr(
        x: stageWidth*0.5 + 40
        y: stageHeight - 45
        z: 10
        w: 40
        h: 40
    )
    .bind "Click", ->
        player = Crafty("Player")
        player.setColor "blue"
    .color("blue")

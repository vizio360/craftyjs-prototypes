combinations = [
    {
        trigger: "#FFFF00"
        target: "#00FF00"
    },
    {
        trigger: "#FF0000"
        target: "#FF7D00"
    },
    {
        trigger: "#0000FF"
        target: "#FF00FF"
    }
]

createBlock = (params) ->
    {x, y, trigger, target} = params
    Crafty.e("Target, 2D, Canvas, Color, Collision, Particles")
        .attr(
            x: 0
            y: y
            w: stageWidth
            h: 60
        )
        .bind "EnterFrame", ->
            if @_y > stageHeight
                @unbind "EnterFrame"
                @destroy()
            @y += SPEED
        .color(target)
        .collision()
        .particles(obstacleParticlesOptions)
        Crafty.e("2D, Canvas, Color, Collision")
        .attr(
            x: 0
            y: y+60
            w: stageWidth
            h: 25
        )
        .bind "EnterFrame", ->
            if @_y > stageHeight
                @unbind "EnterFrame"
                @destroy()
            @y += SPEED
        .color(trigger)

setInterval ->
    comb = combinations[Math.floor(Math.random()*2)]
    createBlock
        x:0
        y:-70
        trigger: comb.trigger
        target: comb.target
, 2000

obstacleParticlesOptions =
    maxParticles: 100
    size: 10
    speed: 1
    # Lifespan in futurerames
    lifeSpan: 29
    lifeSpanRandom: 7
    # Angle is calculated                         clockwise: 12pm is 0deg, 3pm is 90deg etc.
    angle: 0
    startColour: [0, 255, 0, 1]
    endColour: [0, 0, 0, 0]
    # Only applies when fastMode is off, specifies how sharp the gameradients are drawn
    sharpness: 20
    # Random spread from origin
    spreadX: stageWidth
    spreadY: 8

    # How many frames should this                 last
    duration: -1
    # Will draw squares instead of circle gradientsts
    fastMode: false
    gravity: { x: 0, y: 0 }
    # sensible valxues are 0-3
    jitter: 0

sheepRadius = 50
stageWidth = Crafty.stage.elem.offsetWidth
stageHeight = Crafty.stage.elem.offsetHeight
haxis = new Crafty.math.Vector2D 0, -1

getInputValue = (id) ->
    el = document.getElementById id
    el.value

target = new Crafty.math.Vector2D stageWidth+30, Math.random()*stageHeight

Crafty.sprite(1, "imgs/sheep100.png", simg: [0, 0])

limitTo = (vector, limit) ->
    if vector.magnitude() > limit
        vector.scaleToMagnitude limit
    return vector

MAX_SPEED = 3.5
MAX_FORCE = 0.07
MAX_REPULSION_MAGNITUDE = MAX_SPEED
steer_to = (target, location, velocity) ->
    target.subtract location
    d = target.magnitude()
    steer = new Crafty.math.Vector2D 0,0
    if d > 0
        target.normalize()
        if d < 70
            target.scaleToMagnitude MAX_SPEED*(d/100.0)
        else
            target.scaleToMagnitude MAX_SPEED

        target.subtract velocity
        target = limitTo target, MAX_FORCE
        steer = target.clone()
    return steer

flock = (nb, location, velocity) ->
    repulsion = new Crafty.math.Vector2D 0, 0
    globalTarget = target.clone()
    globalTarget.subtract location
    targetWeight = getInputValue("targetWeight")
    globalTarget.x *= targetWeight
    globalTarget.y *= targetWeight
    if nb is false
        obj =
            newVelocity: globalTarget
            repulsion: repulsion
        return obj

    alignMean = new Crafty.math.Vector2D 0, 0
    nbAvgPos = new Crafty.math.Vector2D 0, 0
    separateMean = new Crafty.math.Vector2D 0, 0
    boidLocation = new Crafty.math.Vector2D 0, 0
    repulsionCount = 0
    for n in nb
        nPos = new Crafty.math.Vector2D n.obj._centerX, n.obj._centerY
        if n.obj.has("Repellent")
            t = location.clone()
            t.subtract nPos
            dd = t.magnitude()
            t.normalize()
            #t.scaleToMagnitude(MAX_REPULSION_MAGNITUDE/dd)
            t.scaleToMagnitude(MAX_SPEED*3)
            repulsion.add t
            repulsionCount++
            continue

        sub = nPos.clone()
        sub.subtract(location)
        angle = sub.angleBetween velocity
        angle = angle * 180 / Math.PI
        continue if Math.abs(angle) > 170
       
        alignMean.add n.obj.velocity
        nbAvgPos.add nPos

        # separation
        boidLocation.x = n.obj._centerX
        boidLocation.y = n.obj._centerY
        d = location.distance boidLocation
        tmp = location.clone()
        if d > 0 and d < 50
            tmp.subtract boidLocation
            tmp.normalize()
            tmp.x /= d
            tmp.y /= d
            separateMean.add tmp

    alignMean.x /= nb.length
    alignMean.y /= nb.length
    alignment = limitTo alignMean, MAX_FORCE

    nbAvgPos.x = nbAvgPos.x / nb.length
    nbAvgPos.y = nbAvgPos.y / nb.length
    cohesion = steer_to nbAvgPos, location, velocity

    separateMean.x /= nb.length
    separateMean.y /= nb.length
    separation = separateMean

    if repulsionCount > 0
        repulsion.x /= repulsionCount
        repulsion.y /= repulsionCount


    cohesionWeight = getInputValue("cohesionWeight")
    cohesion.x *= cohesionWeight
    cohesion.y *= cohesionWeight
    alignmentWeight = getInputValue("alignmentWeight")
    alignment.x *= alignmentWeight
    alignment.y *= alignmentWeight
    separationWeight = getInputValue("separationWeight")
    separation.x *= separationWeight
    separation.y *= separationWeight
    repulsionWeight = getInputValue("repulsionWeight")
    repulsion.x *= repulsionWeight
    repulsion.y *= repulsionWeight



    alignment.add cohesion
    separation.add alignment
    separation.add repulsion
    separation.add globalTarget
    return newVelocity: separation, repulsion: repulsion
    
    

createE = (x,y,components) ->
    Crafty.e(components)
        .attr(
            x: x
            y: y
            w: 64
            h: 64
            alpha: 1.0
            #velocity: new Crafty.math.Vector2D(Math.sin(Math.random()*75+45), Math.cos(Math.random()*75+45)).scaleToMagnitude(Math.ceil(Math.random()*MAX_SPEED))
            velocity: new Crafty.math.Vector2D(1, 0).scaleToMagnitude(Math.ceil(Math.random()*MAX_SPEED))
        )
        .bind "EnterFrame", ->
            nb = @hit "Collidable"

            location = new Crafty.math.Vector2D @_centerX, @_centerY
            accelleration = flock nb, location, @velocity

            pp = accelleration.newVelocity
            if accelleration.repulsion.magnitude() > 0
                pp.add accelleration.repulsion
                pp.x /= 2
                pp.y /= 2

            @velocity.add accelleration.newVelocity
            @repulsion = accelleration.repulsion
            @velocity = limitTo @velocity, MAX_SPEED

            if @x < 0
                @x = stageWidth
            else if @x > stageWidth
                @x = 0
                
            if @_centerY + @velocity.y < 0
                @velocity.y *= -1
            else if @_centerY + @velocity.y > stageHeight
                @velocity.y *= -1

            @x += @velocity.x
            @y += @velocity.y


            

        .collision(new Crafty.circle(50, 50, 50))
        #.origin(sheepRadius, sheepRadius)
        .color("green")

            
for p in [0..10]
    createE(Math.random()*10+30, Math.random()*200+50, "2D, GetCenter, DebugVelocity, Canvas, Sheep, Collidable, Color, Collision")

createRepellant = (x, y) ->
    Crafty.e("Repellent, 2D, GetCenter, Canvas, Collidable, Color, Collision")
        .attr(
            x: x - 75
            y: y - 75
            w: 150
            h: 150
            alpha: 0.5
            velocity: new Crafty.math.Vector2D(0, 0)
        )
        .color("red")
        .collision(new Crafty.circle(75, 75, 75))
        .origin("center")
        .timeout(->
            this.destroy()
        , getInputValue("repTimeout")*1000)

Crafty.addEvent this, Crafty.stage.elem, "click", (data)->
    createRepellant data.x, data.y


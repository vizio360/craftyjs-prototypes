Crafty.c "DebugVelocity",
    init: ->
        if Crafty.support.canvas
            c = document.getElementById('DebugVelocity')

            unless c
                c = document.createElement("canvas")
                c.id = 'DebugVelocity'
                c.width = Crafty.viewport.width
                c.height = Crafty.viewport.height
                c.style.position = 'absolute'
                c.style.left = "0px"
                c.style.top = "0px"
                c.style.zIndex = '1000'
                Crafty.stage.elem.appendChild(c)

            ctx = c.getContext('2d')
            drawed = 0
            total = Crafty("DebugVelocity").length
            @requires("2D").bind "EnterFrame", =>
                return unless @velocity
                if (drawed == total)
                    ctx.clearRect(0, 0, Crafty.viewport.width, Crafty.viewport.height)
                    drawed = 0
                ctx.beginPath()
                tmpX = Crafty.viewport.x + @_centerX
                tmpY = Crafty.viewport.y + @_centerY
                if @repulsion
                    ctx.strokeStyle = "#FF0000"
                    ctx.moveTo tmpX,tmpY
                    rep = @repulsion.clone()
                    rep.normalize()
                    rep.scaleToMagnitude(50)
                    ctx.lineTo tmpX + rep.x, tmpY + rep.y
                ctx.strokeStyle = "#00FF00"
                ctx.rect(tmpX-5, tmpY-5, 10, 10)
                ctx.fillRect()
                ctx.strokeStyle = "#000000"
                ctx.moveTo tmpX,tmpY
                vel = @velocity.clone()
                vel.normalize()
                vel.scaleToMagnitude(50)
                ctx.lineTo tmpX + vel.x, tmpY + vel.y
                ctx.stroke()
                drawed++

Crafty.c "GetCenter",
    _centerX: 0
    _centerY: 0
    init: ->
        @bind "Move", ->
            @_centerX = @_x + @_w * 0.5
            @_centerY = @_y + @_h * 0.5

describe "2D", ->
    
    it "calculates angle between two vector with 0,0 as ref", ->
        

        v1 = new Crafty.math.Vector2D 2,2
        v2 = new Crafty.math.Vector2D 1,0
        angle = v1.angleBetween v2
        angle = angle * 180 / Math.PI
        expect(angle).toEqual(-45)
        
    it "gets the angle to another vector", ->
        v1 = new Crafty.math.Vector2D 1,0
        v2 = new Crafty.math.Vector2D 0,1
        angle = v2.angleBetween v1
        console.log angle
        angle = angle * 180 / Math.PI
        expect(angle).toEqual(90)
        
        


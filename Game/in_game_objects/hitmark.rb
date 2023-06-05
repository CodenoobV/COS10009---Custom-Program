class Hitmark

    attr_reader :exploded
  
    def initialize(window, x, y)
        @x = x
        @y = y
        @radius = 30
        @exploded = false        
        @images = Gosu::Image.load_tiles('images/explosions.png', 60, 60)
        @current_state = 0
    end
  
    def draw
        if @current_state < @images.count
            @images[@current_state].draw(@x - @radius, @y - @radius, 2)
            @current_state += 1
        else
            @exploded = true
        end
    end
  end
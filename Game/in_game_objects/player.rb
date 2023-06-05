require_relative 'constants'
class Player
    attr_reader :x, :y, :size

    def initialize(window)
        @x = 480
        @y = 200
        @momentum_x = 0
        @momentum_y = 0
        @size = 30
        @image = Gosu::Image.new('images/player.png')
        
    end

    def forward
        @momentum_y -= SHIP_ACCELERATION
    end

    def backward
        @momentum_y += SHIP_ACCELERATION
    end

    def right
        @momentum_x += SHIP_ACCELERATION
    end

    def left
        @momentum_x -= SHIP_ACCELERATION
    end

    def move
        @x += @momentum_x
        @y += @momentum_y
        @momentum_x *= SHIP_FRICTION
        @momentum_y *= SHIP_FRICTION

        if @x > WIDTH - @size
            @momentum_x = 0
            @x = WIDTH - @size
        end
  
        if @x < 0 + @size
            @momentum_x = 0
            @x = 0 + @size
        end
  
        if @y > HEIGHT - @size
            @momentum_y = 0
            @y = HEIGHT - @size
        end
    end

    def draw
        @image.draw(@x - @size, @y - @size, 1)
    end
end

class Bullet
    attr_reader :x, :y, :size

    def initialize(window, x, y)
    end 
end
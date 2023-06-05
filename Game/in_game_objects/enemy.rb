class Enemy
    attr_reader :x, :y, :radius
    def initialize(window,x,y)
        @radius = 30
        @x = x
        @y = y
        @image = Gosu::Image.new('images/enemies.png')
    end
    
    def draw
        @image.draw(@x - @radius, @y - @radius, 1)
    end

    def move
        @y += ENEMY_SPEED
    end
end
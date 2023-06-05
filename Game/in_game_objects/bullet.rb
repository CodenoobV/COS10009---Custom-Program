require_relative 'constants'
class Bullet
    attr_reader :x, :y, :size

    def initialize(window, x, y)
        @x = x
        @y = y
        @image = Gosu::Image.new('images/bullet.png')
        @size = 16
    end

    def out_of_bounds
        top = 0 - @size
        bot = HEIGHT + @size
        (@y > top) and (@y < bot)
    end

    def draw
        @image.draw(@x - @size, @y - @size, 1)
    end

    def move
        @y -= BULLET_SPEED
    end
end

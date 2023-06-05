require 'gosu'
require './in_game_objects/constants'
require './in_game_objects/player'
require './in_game_objects/enemy'
require './in_game_objects/bullet'
require './in_game_objects/hitmark'

class Game < Gosu::Window
    def initialize
        super(WIDTH, HEIGHT)
        self.caption = 'Space Shooter'
        @startup_image = Gosu::Image.new('images/startup.png')
        @gameover_image = Gosu::Image.new('images/game_over.png')
        @font = Gosu::Font.new(20)
        @background_music = Gosu::Song.new('audio/background.ogg')
        @state = 1
        @background_music.volume = 0.2
        @background_music.play
    end

    def initialize_game
        @state = 2

        @score = 0
        @score_display = Gosu::Font.new(self, Gosu::default_font_name, 50)
        @back_img = Gosu::Image.new('images/space.png')

        @shooting_sound = Gosu::Sample.new("audio/laser4.mp3")
        @hitmarker_sound = Gosu::Sample.new("explosions/explosion04.wav")
        @death_sound = Gosu::Sample.new("explosions/explosion09.wav")

        @player = Player.new(self)
        @enemy = []
        @bullets = []
        @hitmarker = []

        index = 0
        while index < SPAWN_RATE do
            size = 4
            low = 2
            high = 9

            gen = []

            while gen.length() < size
                rand_num = rand(low..high)

                unless gen.include?(rand_num)
                    gen.push(rand_num)
                end
            end

            gen.each do |gen|
                @enemy.push Enemy.new(self, gen*100, 1-200*index)
            end

            index +=1
        end
    end

    def initialize_ending(scenario)
        @state = 3

        @message_font = Gosu::Font.new(30)
        
        @user_input = "Press R to Retry, S to Start Again, Q to quit."
        @message = ""
        @extra_mess = "Before dying, you knocked out #{@score} enemies."

        case scenario
        when :out_of_bounds
            @message = "You entered the radioactive zone and died."
        when :knocked_down
            @message = "You got knocked out by an enemy."
        when :reached
            @message = "The enemies have reached the remaining survivors."
            @extra_mess = "You knocked out #{@score} enemies."
        end
    end
    
    def button_down(id)
        case @state
        when 1
            initialize_game
        when 3 
            case id
            when Gosu::KbR
                initialize_game
            when Gosu::KbQ
                close
            end
        when 2
            if id == Gosu::KbSpace
                @shooting_sound.play
                @bullets.push Bullet.new(self, @player.x, @player.y)
            end
        end
    end

    def update_play

        #CHECK FOR USER MOVEMENT
        if button_down?(Gosu::KbUp)
            @player.forward
        end
        if button_down?(Gosu::KbDown)
            @player.backward
        end
        if button_down?(Gosu::KbRight)
            @player.right
        end
        if button_down?(Gosu::KbLeft)
            @player.left 
        end

        #UPDATE EVERYTHING THAT NEEDS TO BE UPDATED
        @player.move

        @enemy.dup.each do |enemy|
            if enemy.y > HEIGHT + enemy.radius
                @enemy.delete enemy
            end
        end
      
        @enemy.each do |enemy| 
            enemy.move
        end

        @bullets.dup.each do |bullet|
            if !bullet.out_of_bounds
                @bullets.delete bullet
            end
        end

        @bullets.dup.each do |bullet|
            bullet.move
        end

        @hitmarker.dup.each do |explosion|
            if explosion.exploded
                @hitmarker.delete explosion
            end
        end

        #CHECK FOR COLLISIONS/HIT/MISS
        @enemy.dup.each do |enemy|
            @bullets.dup.each do |bullet|
                distance = Gosu.distance(enemy.x, enemy.y, bullet.x, bullet.y)
                if distance < enemy.radius + bullet.size
                    @enemy.delete enemy
                    @bullets.delete bullet
                    @score = @score + 1
                    @hitmarker_sound.play
                    @hitmarker.push Hitmark.new(self, enemy.x, enemy.y)
                end
            end
        end

        @enemy.each do |enemy|
            distance = Gosu.distance(enemy.x, enemy.y, @player.x, @player.y)

            if enemy.y > HEIGHT
                initialize_ending(:reached)
            end

            if distance < @player.size + enemy.radius
                @death_sound.play
                initialize_ending(:knocked_down)
            end
        end

        if @player.y < -@player.size
            initialize_ending(:out_of_bounds)
        end
    end

    def update
        case @state
        when 2
            update_play
        end
    end    

    def draw
        case @state
        when 1
            draw_start
        when 2
            draw_game
        when 3
            draw_end
        end
    end

    def draw_start
        @startup_image.draw(0, 0, 0)
    end 

    def draw_game
        @back_img.draw(0, 0, 0)
        @player.draw()
        @enemy.each do |enemy| 
            enemy.draw
        end
        @bullets.each do |bullet|
            bullet.draw
        end
        @hitmarker.each do |explosion|
            explosion.draw
        end
        @score_display.draw(@score, 20, 20, 1)
    end

    def draw_end
        @gameover_image.draw(0, 0, 0)
        @message_font.draw(@message, 30, 30, 1, 1, 1, Gosu::Color::WHITE)
        @message_font.draw(@extra_mess, 30, 70, 1, 1, 1, Gosu::Color::WHITE)
    end
end

window = Game.new
window.show
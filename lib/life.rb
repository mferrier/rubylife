require 'rubygems'
require 'activesupport'
require 'rubygame'
require 'lib/core_extensions'
require 'lib/life/board'
require 'lib/life/cell'

module Life
  mattr_reader :board
  
  class << self
    def start!
      Rubygame.init()
      screen        = Rubygame::Screen.new([800, 600])
      screen.title  = "Conway's Game of Life"
      queue         = Rubygame::EventQueue.new
      clock         = Rubygame::Clock.new { |clock| clock.target_framerate = 30 }
      background    = Rubygame::Surface.new(screen.size)
      background.fill([0,0,0])
      background.blit(screen, [0,0])
      screen.update()
      
      loop do
        puts "tick! #{Time.now.to_s}"
        clock.tick()
        
        quit = false
        
        queue.each do |event|
          case(event)
          when Rubygame::QuitEvent
            quit = true
          when Rubygame::KeyDownEvent
            case event.key 
            when Rubygame::K_ESCAPE
              quit = true
            end
          # when Rubygame::MouseMotionEvent
          #   quit = true
          # when Rubygame::MouseDownEvent
          #   quit = true
          # when Rubygame::MouseUpEvent
          #   quit = true
          end
        end # event handling
        
        break if quit
        
        background.blit(screen, [0, 0])
        screen.update()
        screen.title = "framerate: #{clock.framerate.to_s}"

      end # main loop
      puts "terminated!"
      Rubygame.quit()
      
    end # start!()
  end # class methods
  
end

# class << self
#   def start!
#     reset! unless @@board
#     clear!
#     @@board.render!
#     
#     1000.times do
#       @@board.calculate!
#       clear!
#       @@board.render!
#       #wait!
#     end
#   end
#   
#   def reset!
#     @@board = Board.new(100,40)
#   end
#   
#   def clear!
#     puts "\n"*20
#   end
#   
#   def wait!
#     sleep 0.05
#   end
# end

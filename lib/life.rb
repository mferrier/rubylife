require 'rubygems'
require 'activesupport'
require 'rubygame'
require 'lib/core_extensions'
require 'lib/life/board'
require 'lib/life/cell'

module Life
  mattr_reader :board, :background, :screen, :queue, :clock
  
  class << self
    def start!
      Rubygame.init()
      
      @@board         = Board.new(100,40)
      
      @@screen        = Rubygame::Screen.new([board.width*7, board.height*7])
      @@screen.title  = "Conway's Game of Life"
      @@queue         = Rubygame::EventQueue.new
      @@clock         = Rubygame::Clock.new { |clock| clock.target_framerate = 30 }
      @@background    = Rubygame::Surface.new(screen.size)
      
      background.fill([0,0,0])

      quit = false
      
      until quit do
        board.calculate!
        render_board!
        background.blit(screen, [0,0])
        screen.title = "Conway's Life (#{clock.framerate.round} fps)"
        screen.update()
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
      end # main loop
      puts "terminated!"
      Rubygame.quit()
      
    end # start!()
    
    def render_board!
      (0..board.height-1).each do |y|
        (0..board.width-1).each do |x|
          cell    = board.columns[x][y]
          color   = (cell.alive? ? [255,255,255] : [0,0,0])
      
          # for circle
          # center  = [cell.x*4, cell.y*4]
          # radius  = 2
          # background.draw_circle_s(center, radius, color)
          
          # for square
          p1 = [(cell.x*7)-3, (cell.y*7)-3]
          p2 = [(cell.x*7)+3, (cell.y*7)+3]
          background.draw_box_s(p1, p2, color)
        end
      end
    end

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

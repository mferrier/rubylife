require 'rubygems'
require 'activesupport'
require 'rubygame'
require 'lib/core_extensions'
require 'lib/life/board'
require 'lib/life/cell'

module Life
  mattr_reader :board, :background, :screen, :queue, :clock
  COLOR_ALIVE = [255,255,255].freeze
  COLOR_DEAD  = [0,0,0].freeze
  CELL_WIDTH  = 7
  CELL_HEIGHT = 7
  
  class << self
    def start!
      Rubygame.init()
      
      @@board         = Board.new(100,40)
      
      @@screen        = Rubygame::Screen.new([board.width*CELL_WIDTH, board.height*CELL_HEIGHT])
      @@screen.title  = "Conway's Game of Life"
      @@queue         = Rubygame::EventQueue.new
      @@clock         = Rubygame::Clock.new { |clock| clock.target_framerate = 30 }
      @@background    = Rubygame::Surface.new(screen.size)
      
      background.fill([0,0,0])

      quit = false
      
      until quit do
        render_board!
        background.blit(screen, [0,0])
        screen.title = "Conway's Life (#{clock.framerate.round} fps)"
        screen.update()
        clock.tick()
        board.calculate!
        
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
      board.each_cell do |cell|
        color   = (cell.alive? ? COLOR_ALIVE : COLOR_DEAD)
        x1  = cell.x*CELL_WIDTH
        y1  = cell.y*CELL_HEIGHT
        x2  = x1 + (CELL_WIDTH-1)
        y2  = y1 + (CELL_HEIGHT-1)
        
        background.draw_box_s([x1,y1], [x2,y2], color)
      end
    end

  end # class methods
  
end
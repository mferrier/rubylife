require 'rubygems'
require 'activesupport'
require 'rubygame'
require 'lib/core_extensions'
require 'lib/life/board'
require 'lib/life/cell'

module Life
  mattr_reader :board, :background, :screen, :queue, :clock
  BOARD_WIDTH  = 100
  BOARD_HEIGHT = 40
  COLOR_ALIVE  = [255,255,255].freeze
  COLOR_DEAD   = [0,0,0].freeze
  CELL_WIDTH   = 7
  CELL_HEIGHT  = 7
  
  class << self
    def start!
      Rubygame.init()
      
      @@board         = Board.new(BOARD_WIDTH, BOARD_HEIGHT)
      
      @@screen        = Rubygame::Screen.new([board.width*CELL_WIDTH, board.height*CELL_HEIGHT])
      @@queue         = Rubygame::EventQueue.new
      @@clock         = Rubygame::Clock.new {|clock| clock.target_framerate = 30 }
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
      
    ensure
      Rubygame.quit()
    end # start!()
    
    def render_board!
      board.each_cell do |cell|
        next unless cell.changed_last_gen
        
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
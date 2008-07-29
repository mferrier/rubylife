require 'lib/life/gui/button'
module Life
  module GUI
    COLOR_ALIVE       = [255,255,255].freeze
    COLOR_DEAD        = [0,0,0].freeze
    CELL_WIDTH        = 7
    CELL_HEIGHT       = 7
    CLOCK_FRAMERATE   = 30
    
    MENU_HEIGHT = 25
    MENU_COLOR  = [50,0,0]
    
    mattr_reader  :board, :background, :menu, :screen, :queue, :clock, :initialized, 
                  :buttons, :font, :last_painted_cell, :paused, :quit, :stepping
    alias_method :initialized?, :initialized
    
    class << self
      
      def init
        @@screen        = Rubygame::Screen.new([board.width*CELL_WIDTH, (board.height*CELL_HEIGHT)+MENU_HEIGHT])
        
        @@queue         = Rubygame::EventQueue.new
        @@clock         = Rubygame::Clock.new {|clock| clock.target_framerate = CLOCK_FRAMERATE }
        
        @@menu          = Rubygame::Surface.new([screen.width, MENU_HEIGHT])
        @@menu.fill(MENU_COLOR)
        
        @@background    = Rubygame::Surface.new([screen.width, screen.height-MENU_HEIGHT])
        @@background.fill(COLOR_DEAD)
        
        @@buttons = [] <<
          Button.new("Start",     Button::DEFAULT_WIDTH*0,  0) { unpause! } <<
          Button.new("Stop",      Button::DEFAULT_WIDTH*1,  0) { pause! } <<
          Button.new("Step",      Button::DEFAULT_WIDTH*2,  0) { unpause!; @@stepping = true } <<
          Button.new("Save",      Button::DEFAULT_WIDTH*3,  0) { board.save! } <<
          Button.new("Load",      Button::DEFAULT_WIDTH*4,  0) { board.revert!; render_board_and_update() } <<
          Button.new("Clear",     Button::DEFAULT_WIDTH*5,  0) { pause!; board.clear!; render_board_and_update() } <<
          Button.new("Scramble",  Button::DEFAULT_WIDTH*6,  0) { board.scramble! } <<
          Button.new("Quit",      Button::DEFAULT_WIDTH*7,  0) { @@quit = true }
          #Button.new("Debug",Button::DEFAULT_WIDTH*6, 0) { require 'ruby-debug'; debugger } <<
        
        @@buttons.each{|b| b.blit(@@menu) }
        @@screen.update
        pause!
        @@stepping = false
        @@initialized   = true
      end
      
      def board=(b)
        @@board = b
      end
      
      def event_loop
        init() unless initialized
        
        loop do
          return if @@quit
          render_board_and_update()
          board.calculate! unless @@paused
          
          if @@stepping
            pause!
            @@stepping = false
          end
          
          queue.each do |event|
            case(event)
            when Rubygame::QuitEvent
              @@quit = true
            when Rubygame::KeyDownEvent
              case event.key 
              when Rubygame::K_ESCAPE
                @@quit = true
              when ?q || ?Q
                @@quit = true
              end
            when Rubygame::MouseMotionEvent
              mouse_dragged(event) if event.buttons.include?(1)
            when Rubygame::MouseDownEvent
              mouse_down(event)
            when Rubygame::MouseUpEvent
              # any time the mouse button comes up, paint_mode goes
              # back to draw (rather than erase)
              @@paint_mode = true
            end
          end # queue
        end # main loop
      ensure
        Rubygame.quit()
        Kernel.exit()
      end # event_loop
      
      def mouse_dragged(event)
        if (cell = cell_at(*event.pos)) && cell != @@last_painted_cell
          paint_cell(cell)
        end
      end
      
      def mouse_down(event)
        if button = @@buttons.detect{|b| b.clicked?(*event.pos)}
          button.clicked!
        elsif cell = cell_at(*event.pos)
          # set the paint mode to the opposite of the cell's state
          @@paint_mode = !cell.alive? 
          paint_cell(cell)
        end        
      end
      
      def paint_cell(cell)
        @@last_painted_cell = cell
        cell.state = @@paint_mode
      end
      
      def render_board
        board.each_cell do |cell|
          render_cell(cell) if cell.changed_last_gen
        end
      end
      
      def render_cell(cell)
        color = (cell.alive? ? COLOR_ALIVE : COLOR_DEAD)
        x1    = cell.x*CELL_WIDTH
        y1    = cell.y*CELL_HEIGHT
        x2    = x1 + (CELL_WIDTH-1)
        y2    = y1 + (CELL_HEIGHT-1)
        
        # subtract one from x2 and y2 for cell borders
        background.draw_box_s([x1,y1], [x2-1,y2-1], color)        
      end
      
      def update_screen
        menu.blit(screen, [0,0])
        background.blit(screen, [0,MENU_HEIGHT])
        screen.title =  (@@paused ? "* PAUSED * " : '') + 
                        "Cellular Automata (generation #{board.generation}, #{clock.framerate.round} fps)"
        screen.update()
        clock.tick()
      end
      
      def draw_gridlines
      end
      
      # returns the cell at pos x,y, or nil if there is no cell there
      def cell_at(x,y)
        # make sure it isn't a menu click
        return false unless x > 0 && y > MENU_HEIGHT
        
        cell_x = x / CELL_WIDTH
        cell_y = (y-MENU_HEIGHT) / CELL_HEIGHT
        
        board.columns[cell_x][cell_y]
      end
      
      def pause!
        @@paused = true
      end
      
      def unpause!
        @@paused = false
      end
      
      def render_board_and_update
        render_board()
        update_screen()
      end
      
    end # class methods
  end # GUI
end # Life

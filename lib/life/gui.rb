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
    
    mattr_reader  :background, :menu, :screen, :queue, :clock, :initialized, 
                  :buttons, :font, :last_cell_clicked, :paused, :quit
    alias_method :initialized?, :initialized
    
    class << self
      
      def init(board)
        @@screen        = Rubygame::Screen.new([board.width*CELL_WIDTH, (board.height*CELL_HEIGHT)+MENU_HEIGHT])
        
        @@queue         = Rubygame::EventQueue.new
        @@clock         = Rubygame::Clock.new {|clock| clock.target_framerate = CLOCK_FRAMERATE }
        
        @@menu          = Rubygame::Surface.new([screen.width, MENU_HEIGHT])
        @@menu.fill(MENU_COLOR)
        
        @@background    = Rubygame::Surface.new([screen.width, screen.height-MENU_HEIGHT])
        @@background.fill(COLOR_DEAD)
        
        @@buttons = [] <<
          Button.new("Clear",0,0) { board.clear! } <<
          Button.new("Scramble",Button::DEFAULT_WIDTH, 0) { board.scramble! } <<
          Button.new("Start",Button::DEFAULT_WIDTH*2, 0) { @@paused = false } <<
          Button.new("Stop",Button::DEFAULT_WIDTH*3, 0) { @@paused = true } <<
          Button.new("Quit",Button::DEFAULT_WIDTH*4, 0) { @@quit = true }
        
        @@buttons.each{|b| b.blit(@@menu) }
        @@screen.update
        @@paused = true
        @@initialized   = true
      end
      
      def event_loop(board)
        init(board) unless initialized
        
        paused = false
      
        loop do
          return if @@quit
          render_board(board)
          update_screen()
          board.calculate! unless @@paused
          
          queue.each do |event|
            case(event)
            when Rubygame::QuitEvent
              @@quit = true
            when Rubygame::KeyDownEvent
              case event.key 
              when Rubygame::K_ESCAPE
                @@quit = true
              when ?s || ?S
                board.scramble!
              when ?c || ?C
                board.clear!
              when ?q || ?Q
                @@quit = true
              when ?p || ?P
                 @@paused = !@@paused
              end
            when Rubygame::MouseMotionEvent
              if event.buttons.include?(1) && (cell = cell_at(board, *event.pos)) && cell != @@last_cell_clicked
                @@last_cell_clicked = cell
                cell.state = true
              end
            when Rubygame::MouseDownEvent
              #
            when Rubygame::MouseUpEvent
              if button = @@buttons.detect{|b| b.clicked?(*event.pos)}
                button.clicked!
              elsif cell = cell_at(board, *event.pos)
                cell_clicked!(cell)
              end
            end
          end # queue
        end # main loop
      ensure
        puts "terminating!"
        Rubygame.quit()
      end # event_loop
      
      def mouse_moved(event)
      end
      
      def mouse_clicked(event)
      end
      
      def render_board(board)
        board.each_cell do |cell|
          render_cell(cell) if cell.changed_last_gen
        end
      end # render board
      
      def render_cell(cell)
        color = (cell.alive? ? COLOR_ALIVE : COLOR_DEAD)
        x1    = cell.x*CELL_WIDTH
        y1    = cell.y*CELL_HEIGHT
        x2    = x1 + (CELL_WIDTH-1)
        y2    = y1 + (CELL_HEIGHT-1)
        
        background.draw_box_s([x1,y1], [x2,y2], color)        
      end
      
      def update_screen
        menu.blit(screen, [0,0])
        background.blit(screen, [0,MENU_HEIGHT])
        screen.title = (@@paused ? "* PAUSED * " : '') + "Cellular Automata (#{clock.framerate.round} fps)"
        screen.update()
        clock.tick()
      end
      
      # returns the cell at pos x,y, or nil if there is no cell there
      def cell_at(board,x,y)
        # make sure it isn't a menu click
        return false unless x > 0 && y > MENU_HEIGHT
        
        cell_x = x / CELL_WIDTH
        cell_y = (y-MENU_HEIGHT) / CELL_HEIGHT
        
        board.columns[cell_x][cell_y]
      end
      
      def cell_clicked!(cell)
        cell.state = true
      end
      
    end # class methods
  end # GUI
end # Life

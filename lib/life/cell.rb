module Life
  class Cell
    attr_reader :x, :y, :board, :state, :next_state, :neighbours
    alias_method :alive?, :state

    def initialize(x,y,board)
      @x, @y, @board = x, y, board
      @state = (rand(2) == 1) # randomly on or off
    end

    def calculate!
      alives = neighbours.select{|c| c.alive?}.size rescue (require 'ruby-debug'; debugger)
      
      if alive?
        if alives < 2 || alives > 3
          @next_state = false
        end
      else
        if alives == 3
          @next_state = true
        end
      end
    end
    
    def evolve!
      @state = @next_state
    end
    
    def neighbours
      @neighbours ||= @board.neighbours(self)
    end
    
    def inspect
      "Cell(#{x},#{y})"
    end
    
  end
end
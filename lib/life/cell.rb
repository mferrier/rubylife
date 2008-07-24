module Life
  class Cell
    attr_reader :x, :y, :board, :state, :next_state, :neighbours, :changed_last_gen
    alias_method :alive?, :state

    # conway
    STAY_ALIVE = [2,3]
    BIRTH      = [3]

    # mikeway
    # STAY_ALIVE = [3, 6]
    # BIRTH      = [6]

    def initialize(x,y,board)
      @x, @y, @board = x, y, board
      @state = @next_state = (rand(5) == 1) # randomly on or off, more likely to be off
      @needs_update = true
      @changed_last_gen = true
    end
    
    def calculate!
      return unless neighbours.any?{|c| c.changed_last_gen}
      alives = neighbours.select{|c| c.alive?}.size
      
      if alive?
        if !STAY_ALIVE.include?(alives)
          @next_state = false
        end
      else
        if BIRTH.include?(alives)
          @next_state = true
        end
      end
    end
    
    def evolve!
      if @state != @next_state
        @changed_last_gen = true
        @state = @next_state
      else
        @changed_last_gen = false
      end
    end
    
    def neighbours
      @neighbours ||= @board.neighbours(self)
    end
    
    def inspect
      "Cell(#{x},#{y})"
    end
    
  end
end
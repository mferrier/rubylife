module Life
  class Cell
    attr_reader :x, :y, :board, :state, :next_state, :neighbours, :changed_last_gen
    alias_method :alive?, :state

    # conway
    STAY_ALIVE = [2,3]
    BIRTH      = [3]

    # liquid-y
    # STAY_ALIVE = [2,4,6,8]
    # BIRTH      = [3,5,8]
    
    # STAY_ALIVE = [3,4]
    # BIRTH      = [2]
        
    def initialize(x,y,board)
      @x, @y, @board = x, y, board
      @state = @next_state = false
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
    
    def state=(s)
      @changed_last_gen = true
      @state = s
    end
    
    def clear!
      @changed_last_gen = true
      @state = @next_state = false
    end
    
  end
end
module Life
  class Board
    attr_reader :width, :height, :generation, :columns, :saved_columns
    
    def initialize(width, height)
      @width, @height = width, height
      @generation = 0
      @columns = []
      @saved_columns = []
      
      (0..width-1).each do |x|
        column = []
        (0..height-1).each do |y|
          column << Cell.new(x,y,self)
        end
        @columns << column
      end
      
      # preload neighbours
      each_cell(&:neighbours)
    end
    
    def clear!
      each_cell{|c| c.clear!}
      @generation = 0
    end
    
    def scramble!
      each_cell{|c| c.state = (rand(2) == 1)}
    end
    
    def calculate!(evolve = true)
      each_cell do |cell|
        cell.calculate!
      end
      
      if evolve
        each_cell do |cell|
          cell.evolve!
        end
        @generation += 1
      end
    end
    
    def each_cell(&block)
      @columns.flatten.each{|cell| yield cell}
    end
    
    # return an array of the cells that are neighbours to the given cell
    # cells only call this once and remember who their neighbours are from
    # then on
    # 
    # cell neighbours wrap at the edges of the screen, too
    def neighbours(cell)
      x1 = (cell.x-1 < 0 ? width-1 : cell.x-1)
      x2 = cell.x
      x3 = (cell.x+1 > width-1 ? 0 : cell.x+1)
      
      y1 = (cell.y-1 < 0 ? height-1 : cell.y-1)
      y2 = cell.y
      y3 = (cell.y+1 > height-1 ? 0 : cell.y+1)
      
      #@columns.values_at(x1,x2,x3).map{|c| c.values_at(y1,y2,y3)}.flatten - [cell]
      
      ([x1, x2, x3].map do |x|
        [y1, y2, y3].map do |y|
          @columns[x][y]
        end
      end).flatten - [cell]
    end
    
    def save!
      @saved_columns.replace Marshal.load(Marshal.dump(@columns))
    end
    
    def revert!
      @columns.replace Marshal.load(Marshal.dump(@saved_columns))
    end
    
  end
end
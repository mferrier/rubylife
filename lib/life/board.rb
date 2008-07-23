module Life
  class Board
    attr_reader :width, :height, :generation, :columns
    
    def initialize(width, height)
      @width, @height = width, height
      @generation = 0
      @columns    = []
      
      (0..width-1).each do |x|
        column = []
        (0..height-1).each do |y|
          column << Cell.new(x,y,self)
        end
        @columns << column
      end
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
    
    def render!
      (0..@height-1).each do |y|
        (0..@width-1).each do |x|
          print(@columns[x][y].alive? ? '@' : ' ')
        end
        print "\n"
      end
      
      print "generation ##{@generation.to_s}"
    end
    
    def each_cell(&block)
      @columns.flatten.each{|cell| yield cell}
    end
    
    # return an array of the cells that are neighbours to the given cell
    # cells only call this once and remember who their neighbours are from
    # then on
    # 
    # so, for cell = Cell(3,5)
    def neighbours(cell)
      ymin = (cell.y-1).at_least(0)      # 4
      ymax = (cell.y+1).at_most(height)   # 6
      
      xmin = (cell.x-1).at_least(0)      # 2
      xmax = (cell.x+1).at_most(width)  # 4
      
      @columns[xmin..xmax].map{|col| col[ymin..ymax]}.flatten - [cell]
    end
    
  end
end
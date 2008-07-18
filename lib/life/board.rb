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
      @columns.each do |column|
        column.each do |cell|
          yield cell
        end
      end
    end
    
    # return an array of the cells that are neighbours to the given cell
    # so, for cell = Cell(3,5)
    def neighbours(cell)
      xmin = (cell.y-1).at_least(0)      # 4
      xmax = (cell.y+1).at_most(width)   # 6
      
      ymin = (cell.x-1).at_least(0)      # 2
      ymax = (cell.x+1).at_most(height)  # 4
      
      ret = @columns[xmin..xmax].map{|col| col[ymin..ymax]}.flatten - [cell]
      if ret.any?(&:nil?)
        #require 'ruby-debug'; debugger
        puts cell.inspect
      end
      ret
    end
    
  end
end
module Life
  class Board
    attr_reader :width, :height, :generation, :columns
    
    def initialize(width, height)
      @width, @height = width, height
      @generation = 0
      @columns    = []
      
      (0..width).each do |x|
        column = []
        (0..height).each do |y|
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
      @height.each do |y|
        @width.each do |x|
          print(@columns[x][y].alive? ? '@' : ' ')
        end
        print "\n"
      end
      
      puts "generation ##{}"
    end
    
    def each_cell(&block)
      @columns.each do |column|
        column.each do |cell|
          yield cell
        end
      end
    end
    
  end
end
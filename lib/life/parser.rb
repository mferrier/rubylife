require 'lib/life/parser/life_file'

module Life
  module Parser
    LIFE_FILE_PATH = 'blocks'
    LIFE_FILE_EXTENSION = '.life'
    
    class << self
      def open(filename)
        
        unless filename.ends_with?(LIFE_FILE_EXTENSION)
          filename << LIFE_FILE_EXTENSION
        end
        
        path = File.join(LIFE_FILE_PATH, filename)
        
        if File.readable?(path)
          return LifeFile.new(path)
        else
          puts "File not found: #{path}"
          return false
        end
      end
      
      def load(file)
        #x,y  = file.starting_coords
        
        file.lines.each_with_index do |line, y|
          line.cells.each_with_index do |cell, x|
            Life.board.cell_at(x+x_offset,y+y_offset).state = cell
          end
        end
        
        Life::GUI.render_board_and_update()
      end
      
      def open_and_load(filename)
        f = open(filename)
        load(f) if f
      end
      
      def x_offset
        Life.board.width  * 0.2
      end
      
      def y_offset
        Life.board.height * 0.2        
      end
    end
    
  end
end
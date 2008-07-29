require 'lib/life/parser/life_file'

module Life
  module Parser
    mattr_reader :board
    
    class << self
      def open(filename='test.life')
        file = LifeFile.new(filename)
        x,y  = file.starting_coords
        
      end
      
      def board
        @@board ||= Life.board
      end
    end
    
  end
end
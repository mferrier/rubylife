module Life
  module Parser
    class LifeFile < File
      attr_reader :contents, :filename
      
      def initialize(filename)
        @filename = filename
        @contents = super(@filename).read.gsub("\r", '').split("\n")
      end

      def lines
        @lines ||= @contents.select{|l| l =~ /^[\.\*]+$/}.map{|l| Line.new(l)}
      end
      
      def starting_coords_line
        @starting_coords_line ||= @contents.find{|l| l =~ /^#P (\d) (\d)/ }
      end
      
      def starting_coords
        raise "no starting coords found in file '#{@filename}'" unless starting_coords_line
        @starting_coords ||= starting_coords_line.scan(/^#P (\d) (\d)/).flatten
      end
      
      class Line
        attr_reader :content
        
        def initialize(content)
          @content = content
        end
        
        def cells
          @cells ||= content.split(//).map{|c| c == '*' ? true : false}
        end
      end
    end
  end
end
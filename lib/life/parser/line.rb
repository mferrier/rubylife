module Life
  module Parser
    class Line
      attr_reader :content
      
      def initialize(content)
        @content = content
      end
    end
  end
end
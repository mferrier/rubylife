module Life
  module GUI
    class Button
      
      DEFAULT_WIDTH   = 80
      DEFAULT_HEIGHT  = 20
      COLOR_BUTTON    = [0,80,0]
      COLOR_LABEL     = [25,255,255]
      
      raise "TTF is not usable. Bailing out." unless Rubygame::VERSIONS[:sdl_ttf]
      Rubygame::TTF.setup()
      @@font = Rubygame::TTF.new("FreeSans.ttf", Button::DEFAULT_HEIGHT-5)
      
      attr_reader :x, :y, :width, :height, :surface, :click_proc, :label
      
      def initialize(label, x, y, w=DEFAULT_WIDTH, h=DEFAULT_HEIGHT, &block)
        @label, @x, @y, @width, @height = label, x, y, w, h
        @surface = Rubygame::Surface.new([w,h])
        @surface.fill(COLOR_BUTTON)
        @font = @@font
        @click_proc = block if block_given?
      end
            
      def blit(surface_to_blit)
        text = @font.render(label, true, COLOR_LABEL)
        text.blit(@surface, [0,0])
        surface.blit(surface_to_blit, [x,y])
      end
      
      def x2
        x + width
      end
      
      def y2
        y + height
      end
      
      def clicked?(click_x,click_y)
        click_x >= x && click_x <= x2 &&
          click_y >= y && click_y <= y2
      end
      
      def clicked!
        @click_proc.call
      end
    end
  end
end
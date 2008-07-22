require 'rubygems'
require 'activesupport'
require 'lib/core_extensions'
require 'lib/life/board'
require 'lib/life/cell'

module Life
  mattr_reader :board
  
  class << self
    def start!
      reset! unless @@board
      clear!
      @@board.render!
      
      1000.times do
        @@board.calculate!
        clear!
        @@board.render!
        wait!
      end
    end
    
    def reset!
      @@board = Board.new(100,40)
    end
    
    def clear!
      puts "\n"*20
    end
    
    def wait!
      sleep 0.05
    end
  end
end
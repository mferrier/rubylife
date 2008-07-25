require 'rubygems'
require 'activesupport'
require 'rubygame'
require 'lib/core_extensions'
require 'lib/life/board'
require 'lib/life/cell'
require 'lib/life/gui'

module Life
  
  BOARD_WIDTH  = 100
  BOARD_HEIGHT = 40
  
  mattr_reader :board
  @@board = Board.new(BOARD_WIDTH, BOARD_HEIGHT)
  
  class << self
    def start!
      GUI.board = @@board
      GUI.event_loop
    end # start!()

  end # class methods
  
end

Life.start!
require 'rubygems'
require 'activesupport'
require 'rubygame'
require 'lib/core_extensions'
require 'lib/life/board'
require 'lib/life/cell'
require 'lib/life/gui'
require 'lib/life/parser'

module Life
  
  VERSION = 0.1
  BOARD_WIDTH  = 100
  BOARD_HEIGHT = 60
  
  mattr_reader :board
  @@board = Board.new(BOARD_WIDTH, BOARD_HEIGHT)
  GUI::init()
  
  class << self
    def start!
      GUI.event_loop
    end
  end 
  
end
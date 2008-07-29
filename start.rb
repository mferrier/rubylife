#!/usr/bin/env ruby
require 'trollop/lib/trollop'
require 'lib/life'

opts = Trollop::options do
  version "Life v#{Life::VERSION} (c) 2008 Mike Ferrier"
  opt :start,     "Start simulation immediately", :short => :s
  opt :load_file, "Load a pattern from #{Life::Parser::LIFE_FILE_PATH}/", :short => :f, :type => :string
end

if opts[:load_file]
  Life::Parser.open_and_load(opts[:load_file].dup)
end

if opts[:start]
  Life::GUI.unpause!
end

Life.start!

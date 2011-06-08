#!/usr/bin/ruby
require 'lib/battlefields'

interface = ARGV[0] || "en1"

bf = Battlefields.new(interface)

puts "Cleaning up old addresses and info"
bf.cleanup

#!/usr/bin/ruby
require 'lib/battlefields'

PREFIX = "2001:470:1f15:1372"
INTERFACE = "en1"

bf = Battlefields.new(INTERFACE, PREFIX, "1234")

puts "Cleaning up old addresses and info"
bf.cleanup

puts "Adding new addresses"
bf.add_addresses

puts "Generating board"
bf.generate_board

puts "Adding correct firewall rules"
bf.add_firewall_rules

puts "Printing board"
puts bf.board_rep


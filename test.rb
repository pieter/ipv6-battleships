#!/usr/bin/ruby
require 'lib/battlefields'

bf = Battlefields.new("en1")

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

puts "The game is now accessible at #{bf.player.full_prefix}"

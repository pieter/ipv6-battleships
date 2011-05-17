#!/usr/bin/ruby
require 'lib/battlefields'
require 'lib/network'

bf = Battlefields.new("en1")
bf.set_opponent(bf.our_net_prefix, 6975)

m = 0.upto(99).map { |i|
  address = bf.their_address_for_coordinate(i)
  puts address
  Network.check_address(address) ? "1" : "0"
}

puts m.join("")

# Authorative:
# 1110101001111101110111111010011110011111011101011110111000010110111011000110001001011010010011100110
# Real:
# 1110101001111101110111111010011110011111011101011110111000010110111011000110001001011010010011100110

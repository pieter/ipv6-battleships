#!/usr/bin/ruby
require 'lib/battlefields'
require 'lib/network'

PREFIX = "2001:470:1f15:1372"
INTERFACE = "en1"

bf = Battlefields.new(INTERFACE, PREFIX, "1234")

m = 0.upto(99).map { |i|
  address = bf.address_for_coordinate(i)
  puts address
  Network.check_address(address) ? "1" : "0"
}

puts m.join("")

# Authorative:
# 1110101001111101110111111010011110011111011101011110111000010110111011000110001001011010010011100110
# Real:
# 1110101001111101110111111010011110011111011101011110111000010110111011000110001001011010010011100110

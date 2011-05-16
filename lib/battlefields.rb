require File.join(File.dirname(__FILE__), 'network')

class Battlefields

  GAME_PREFIX = "baba"
  BOARD_SIZE = 10

  attr_reader :own_prefix, :own_game_id

  def initialize(interface, prefix = nil, game_id = nil)
    @interface = interface
    @own_prefix = prefix || Network.v6_prefix(interface)
    @own_game_id = game_id || rand(10000)
    
    @their_prefix = "0"
    @their_game_id = 0
  end

  def set_opponent(prefix, game_id)
    @their_prefix = prefix
    @their_game_id = game_id
  end

  # Address creation
  def cleanup
    # Remove any old IPv6 addresses
    Network.addresses(@interface, "#{@own_prefix}:#{GAME_PREFIX}").each do |address|
      Network.remove_address(@interface, address)
    end
    # Remove any old firewire rules
    Network.firewall_flush
  end

  def coordinate_to_suffix(x, y)
    unless y # If we don't have an y, then x = y * 10 + x, so we need to extract that
      z = x / 10
      y = x - z * 10
      x = z
    end
    return "f%x%02x" % [x, y]
  end

  def address_for_coordinate(x, y = nil)
    "%s:%s:%04i::%s" % [@own_prefix, GAME_PREFIX, @own_game_id, coordinate_to_suffix(x, y)]
  end

  def their_address_for_coordinate(x, y=nil)
    "%s:%s:%04i::%s" % [@their_prefix, GAME_PREFIX, @their_game_id, coordinate_to_suffix(x, y)]
  end

  def opponent_coordinate_is_ship(x, y=nil)
    return Network.check_address(their_address_for_coordinate(x, y))
  end

  # Add all necessary IPv6 addresses
  def add_addresses
    0.upto(BOARD_SIZE - 1) do |x|
      0.upto(BOARD_SIZE - 1) do |y|
        address = address_for_coordinate(x, y)
        Network.add_address(@interface, address)
      end
    end
  end

  def add_firewall_rules
    `sudo ip6fw add 2000 accept ipv6-icmp from any to #{@own_prefix}:#{GAME_PREFIX}:#{@own_game_id}::/96`
    @board.each_with_index do |has_ship, index|
      unless has_ship
        command = "sudo ip6fw add 1%03i unreach admin ipv6-icmp from any to %s" % [index, self.address_for_coordinate(index)]
        `#{command}`
      end
    end
  end
  # Actual game stuff

  # Generate a random grid with TRUE / FALSE
  def generate_board
    @board = 0.upto(BOARD_SIZE * BOARD_SIZE - 1).map { rand >= 0.5 }
  end

  def board_rep
    @board.map { |x| x ? "1" : "0" }.join("")
  end
end
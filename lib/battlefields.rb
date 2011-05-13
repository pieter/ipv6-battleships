require File.join(File.dirname(__FILE__), 'network')

class Battlefields

  GAME_PREFIX = "baba"
  BOARD_SIZE = 10
  
  def initialize(interface, prefix, game_id)
    @interface = interface
    @prefix = prefix
    @game_id = game_id
  end

  # Address creation
  def cleanup
    # Remove any old IPv6 addresses
    Network.addresses(@interface, "#{@prefix}:#{GAME_PREFIX}").each do |address|
      Network.remove_address(@interface, address)
    end
    # Remove any old firewire rules
    Network.firewall_flush
  end

  def address_for_coordinate(x, y = nil)
    unless y
      z = x / 10
      y = x - z * 10
      x = z
    end
    "%s:%s:%s::%02x%02x" % [@prefix, GAME_PREFIX, @game_id, x, y]
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
    `sudo ip6fw add 2000 accept ipv6-icmp from any to #{@prefix}:#{GAME_PREFIX}:#{@game_id}::/96`
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
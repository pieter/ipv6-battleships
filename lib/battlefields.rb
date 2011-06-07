require File.join(File.dirname(__FILE__), 'network')

class Battlefields

  GAME_PREFIX = "baba"
  BOARD_SIZE = 10

  class Player
    
    def initialize(prefix, game_id)
      @net_prefix = prefix
      @game_id = game_id || rand(10000)
    end
    
    # We have different prefixes:
    # * The net prefix is just the subnet the player uses.
    # * The game prefix is the net prefix + the game prefix Battlefields uses
    # * The full prefix is the net prefix + game prefix + game id, and can be used to identify this specific game
    
      attr_reader :net_prefix, :game_id

    def game_prefix
      net_prefix + ":" + GAME_PREFIX
    end
    
    def full_prefix
      game_prefix + ":#{@game_id}"
    end
    
    def control_address
      full_prefix + "::1"
    end
    
    def address_for_coordinate(x, y = nil)
      full_prefix + "::" + coordinate_to_suffix(x, y)
    end
    
    def coordinate_to_suffix(x, y)
      unless y # If we don't have an y, then x = y * 10 + x, so we need to extract that
        y = x / 10
        x = x % 10
      end

      # We add an f here so we can differ between this and the control address.
      # Also, without this the prefix::0 addresses cause problems?
      return "f%x%02x" % [x, y]
    end
    
  end
  
  attr_reader :player, :opponent, :interface, :board

  def initialize(interface, prefix = nil, game_id = nil)
    @interface = interface
    @player = Player.new(prefix || Network.v6_prefix(interface), game_id)
    @opponent = nil
  end

  def set_opponent(prefix, game_id)
    @opponent = Player.new(prefix, game_id)
    
    # ??? Shortcut to avoid unnecessary NDP requests.
    # `sudo route add -inet6 #{@opponent.full_prefix}::f000 -prefixlen 114 #{@opponent.control_address}`
  end

  # Address creation
  def cleanup
    # Remove any old IPv6 addresses
    Network.addresses(@interface, "#{@player.game_prefix}").each do |address|
      Network.remove_address(@interface, address)
    end
    # Remove any old firewire rules
    Network.firewall_flush
  end

  def opponent_coordinate_is_ship(x, y=nil)
    Network.check_address(@opponent.address_for_coordinate(x, y), @player.control_address)
  end

  # Add all necessary IPv6 addresses
  def add_addresses
    Network.add_address(@interface, @player.control_address)
    0.upto(BOARD_SIZE - 1) do |x|
      0.upto(BOARD_SIZE - 1) do |y|
        Network.add_address(@interface, @player.address_for_coordinate(x, y))
      end
    end
  end

  def add_firewall_rules
    `sudo ip6fw add 2000 accept ipv6-icmp from any to #{@player.full_prefix}::/96`
    `sudo ip6fw add 2001 accept ipv6-icmp from #{@player.full_prefix}::/96 to any`
    @board.each_with_index do |has_ship, index|
      unless has_ship
        command = "sudo ip6fw add 1%03i unreach admin ipv6-icmp from any to %s" % [index, @player.address_for_coordinate(index)]
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
#
#  BFBBattlefields.rb
#  Battlefields
#
#  Created by Pieter de Bie on 14-05-2011.
#  Copyright 2011 __MyCompanyName__. All rights reserved.
#

require 'lib/battlefields'

class BFBBattlefields

    def prettifyIP(ip_address)
        ip_address.gsub(/::/, ":0000:").gsub(/:([0-9][0-9][0-9]):/, ":0\\1:").sub(/^(([a-f0-9]{1,4}:?){1,4}):/, "\\1\n")
    end

    def initWithInterface(interface, prefix: prefix, gameID:gameID)
        initialize
        @queue = Dispatch::Queue.new("nl.frim.Battlefields.queue")
        @monitorQueue = Dispatch::Queue.new("nl.frim.Battlefields.tcpdumpqueue")
        @battlefield = Battlefields.new(interface, prefix, gameID)
        self
    end
    
    def setOpponentPrefix(prefix, gameID:gameID);
        @battlefield.set_opponent(prefix, gameID);
    end
    
    def gamePrefix
        Battlefields::GAME_PREFIX
    end
    
    def interfacePrefix
        @battlefield.player.net_prefix
    end
    
    def gameID
       @battlefield.player.game_id 
    end

    def setUp
        @battlefield.cleanup
        @battlefield.add_addresses
        @battlefield.generate_board
        @battlefield.add_firewall_rules
    end
    
    def playerStartsFirst
        @battlefield.player.game_id < @battlefield.opponent.game_id
    end
    
    def cleanUp
        @battlefield.cleanup()
    end
    
    def addressForX(x, Y: y)
        @battlefield.player.address_for_coordinate(x, y);
    end

    def theirAddressForX(x, Y: y)
        @battlefield.opponent.address_for_coordinate(x, y);
    end
    
    def playerHasShipAtX(x, Y:y)
        @battlefield.board[10*y + x]
    end

    def ships
        @battlefield.ships
    end

    def opponentHasShipAtX(x, Y:y)
        @queue.async do
            is_ship = @battlefield.opponent_coordinate_is_ship(x, y)
            Dispatch::Queue.main.async do
                userInfo = {"x" => x, "y" => y, "isShip" => is_ship }
                NSNotificationCenter.defaultCenter.postNotificationName("BFBBattlefieldsHasShipCheckCompleteNotification", object:self, userInfo:userInfo)
            end
        end
    end
    
    def monitorICMP(delegate)
        @monitorQueue.async do
            Network.monitor_icmp(@battlefield.interface, "2") do |line|
                Dispatch::Queue.main.async { delegate.ICMPMonitor(self, didLog:line) }

                if line =~ /^.* IP6 ([a-f0-9:]+) > ([a-f0-9:]+): ICMP6, echo request/
                    from = $1
                    to = $2
                    
                    if (from == @battlefield.opponent.control_address) && (to =~ /.*f([0-9])0([0-9])$/)
                        x = $1
                        y = $2
                        Dispatch::Queue.main.async { delegate.ICMPMonitor(self, monitoredOpponentRequestingX:x.to_i, Y:y.to_i) }
                    end
                end
            end
        end
    end
end
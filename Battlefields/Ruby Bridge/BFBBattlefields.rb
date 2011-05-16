#
#  BFBBattlefields.rb
#  Battlefields
#
#  Created by Pieter de Bie on 14-05-2011.
#  Copyright 2011 __MyCompanyName__. All rights reserved.
#

require 'lib/battlefields'

class BFBBattlefields

    def initWithInterface(interface, prefix: prefix, gameID:gameID)
        initialize
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
        @battlefield.own_prefix
    end
    
    def gameID
       @battlefield.own_game_id 
    end

    def setUp
        @battlefield.cleanup
        @battlefield.add_addresses
        @battlefield.generate_board
        @battlefield.add_firewall_rules
    end
    
    def cleanUp
        @battlefield.cleanup()
    end
    
    def addressForX(x, Y: y)
        @battlefield.address_for_coordinate(x, y);
    end

    def theirAddressForX(x, Y: y)
        @battlefield.their_address_for_coordinate(x, y);
    end
    
    def opponentHasShipAtX(x, Y:y)
        @battlefield.opponent_coordinate_is_ship(x, y)
    end
end
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
end
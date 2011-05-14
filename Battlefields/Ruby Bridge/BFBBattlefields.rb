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
end
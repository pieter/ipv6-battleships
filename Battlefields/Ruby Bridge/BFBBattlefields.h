//
//  BFBAttlefields.h
//  Battlefields
//
//  Created by Pieter de Bie on 14-05-2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#define BFBBattlefieldsHasShipCheckCompleteNotification @"BFBBattlefieldsHasShipCheckCompleteNotification"

@interface BFBBattlefields : NSObject 

@property (retain, readonly) NSString *interfacePrefix;
@property (retain, readonly) NSNumber *gameID;

+ (NSString *)gamePrefix; // returns 'baba', the prefix used for this Battlefields game

// Creates a new battlefields game. prefix and gameID can be nil, in which case the game generates a gameID and autodetects the prefix.
- (id)initWithInterface:(NSString *)theInterface prefix:(NSString *)thePrefix gameID:(NSNumber *)theGameID;

- (void)setOpponentPrefix:(NSString *)theirPrefix gameID:(NSNumber *)theirGameID;
// Adds the IP addresses to the interface, generates a new random board and sets up the correct firewall rules
- (void)setUp;
- (void)cleanUp;

- (NSString *)addressForX:(NSNumber *)theX Y:(NSNumber *)theY;
- (NSString *)theirAddressForX:(NSNumber *)theX Y:(NSNumber *)theY;
- (NSNumber *)opponentHasShipAtX:(NSNumber *)theX Y:(NSNumber *)theY;

- (void)monitorICMP:(id)theDelegate;

@end
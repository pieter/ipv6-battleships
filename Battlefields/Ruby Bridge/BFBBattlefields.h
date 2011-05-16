//
//  BFBAttlefields.h
//  Battlefields
//
//  Created by Pieter de Bie on 14-05-2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@interface BFBBattlefields : NSObject 

- (id)initWithInterface:(NSString *)theInterface prefix:(NSString *)thePrefix gameID:(NSNumber *)theGameID;

// Should this be used?
- (NSString *)gamePrefix;

- (NSString *)interfacePrefix;
- (NSNumber *)gameID;

- (void)setUp;
@end
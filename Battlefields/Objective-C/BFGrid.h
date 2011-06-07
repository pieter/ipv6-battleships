//
//  BFGrid.h
//  Battlefields
//
//  Created by Pieter de Bie on 17-05-2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BFGridDelegate;

typedef enum {
    BFGridStateEmpty = 0,
    BFGridStateHit,
    BFGridStateMiss,
} BFGridState;

@interface BFGrid : NSMatrix

- (id)initWithFrame:(NSRect)theFrame delegate:(id<BFGridDelegate>)theDelegate;
- (id)initWithFrame:(NSRect)theFrame ships:(NSArray *)theShips delegate:(id<BFGridDelegate>)theDelegate;

@property (readonly, assign) id<BFGridDelegate> delegate;
@property (retain) NSArray *ships;

@end

@protocol BFGridDelegate <NSObject>
- (BFGridState)stateForGrid:(BFGrid *)theGrid cellAtX:(NSInteger)x Y:(NSInteger)y;
@end
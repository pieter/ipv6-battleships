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
    BFGridStateUnknown,
    BFGridStateShip,
    BFGridStateEmpty
} BFGridState;

@interface BFGrid : NSMatrix

- (id)initWithFrame:(NSRect)theFrame delegate:(id<BFGridDelegate>)theDelegate;
@property (readonly, assign) id<BFGridDelegate> delegate;
@end

@protocol BFGridDelegate <NSObject>
- (BFGridState)stateForCellAtX:(NSInteger)x Y:(NSInteger)y;
@end
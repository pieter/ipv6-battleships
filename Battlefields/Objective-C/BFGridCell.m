//
//  BFGridCell.m
//  Battlefields
//
//  Created by Pieter de Bie on 16-05-2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BFGridCell.h"
#import "BFGrid.h"

@implementation BFGridCell

@synthesize isMouseOver;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (BFGridState)stateForGrid:(BFGrid *)theGrid;
{
    NSInteger row = 0, col = 0;
    [theGrid getRow:&row column:&col ofCell:self];
    return [[theGrid delegate] stateForGrid:theGrid cellAtX:col Y:row];
}


- (void)drawHitWithFrame:(NSRect)cellFrame inGrid:(BFGrid *)theGrid;
{
    BFGridState state = [self stateForGrid:theGrid];
    NSImage *hitImage = nil;
    
    switch (state) {
        case BFGridStateMiss:
            hitImage = [NSImage imageNamed:@"miss"];
            break;
        case BFGridStateHit:
            hitImage = [NSImage imageNamed:@"hit"];
            break;
        default:
            break;
    }
    if (!hitImage) {
        if (![self isMouseOver])
            return;
        hitImage = [NSImage imageNamed:@"target"];
    }

    [hitImage drawInRect:cellFrame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView;
{
    BFGrid *grid = (BFGrid *)controlView;
    
    // Draw the ship, if necessary
    
    // Draw the hit
    [self drawHitWithFrame:cellFrame inGrid:grid];
}

@end

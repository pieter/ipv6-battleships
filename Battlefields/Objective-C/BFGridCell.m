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
    NSColor *bgColor = nil;
    
    switch (state) {
        case BFGridStateMiss:
            bgColor = [NSColor redColor];
            break;
        case BFGridStateHit:
            bgColor = [NSColor greenColor];
            break;
        default:
            break;
    }
    if (!bgColor)
        return;

    [bgColor set];
    NSRectFill(cellFrame);
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView;
{
    BFGrid *grid = (BFGrid *)controlView;
    
    // Draw the ship, if necessary
    
    // Draw the hit
    [self drawHitWithFrame:NSInsetRect(cellFrame, 5, 5) inGrid:grid];
}

@end

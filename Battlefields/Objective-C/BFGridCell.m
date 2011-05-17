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

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView;
{
    BFGrid *grid = (BFGrid *)controlView;
    NSInteger row = 0, col = 0;
    [grid getRow:&row column:&col ofCell:self];
    BFGridState state = [[grid delegate] stateForCellAtX:row Y:col];
    NSColor *bgColor = nil;
    switch (state) {
        case BFGridStateEmpty:
            bgColor = [NSColor blueColor];
            break;
        case BFGridStateShip:
            bgColor = [NSColor greenColor];
            break;
        case BFGridStateUnknown:
            bgColor = [NSColor grayColor];
            break;
    }
    [bgColor set];
    NSRectFill(cellFrame);
}

@end

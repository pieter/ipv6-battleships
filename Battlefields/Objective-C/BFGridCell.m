//
//  BFGridCell.m
//  Battlefields
//
//  Created by Pieter de Bie on 16-05-2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BFGridCell.h"

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
    [[NSColor redColor] set];
    NSRectFill(cellFrame);
}

@end

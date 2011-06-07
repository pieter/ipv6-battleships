//
//  BFGrid.m
//  Battlefields
//
//  Created by Pieter de Bie on 17-05-2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BFGrid.h"
#import "BFGridCell.h"

@interface BFGrid ()
@property (readwrite, assign) id<BFGridDelegate> delegate;
@end

@implementation BFGrid

@synthesize delegate = i_delegate;
@synthesize ships;

- (id)initWithFrame:(NSRect)theFrame ships:(NSArray *)theShips delegate:(id<BFGridDelegate>)theDelegate;
{
    if ((self = [self initWithFrame:theFrame delegate:theDelegate])) {
        [self setShips:theShips];
    }
    return self;
}

- (id)initWithFrame:(NSRect)theFrame delegate:(id<BFGridDelegate>)theDelegate;
{
    if ((self = [super initWithFrame:theFrame mode:NSHighlightModeMatrix cellClass:[BFGridCell class] numberOfRows:10 numberOfColumns:10])) {
        [self setCellSize:NSMakeSize(41, 41)];
        [self setDelegate:theDelegate];

        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSInteger cellWidth = [self cellSize].width;
    if ([self ships]) {
        for (NSArray *ship in [self ships]) {
            NSArray *position = [ship objectAtIndex:0];
            NSInteger length = [[ship objectAtIndex:1] integerValue];
            BOOL vertical = [[ship objectAtIndex:2] boolValue];
            NSInteger x = [[position objectAtIndex:0] integerValue];
            NSInteger y = [[position objectAtIndex:1] integerValue];
            
            NSPoint start = [self cellFrameAtRow:y column:x].origin;
            NSRect shipRect = NSMakeRect(start.x, start.y, cellWidth * (vertical ? 1 : length), cellWidth * (vertical ? length : 1));
            NSString *imageName = [NSString stringWithFormat:@"ship_%i_%@", length, vertical ? @"vertical" : @"horizontal"];
            NSImage *shipImage = [NSImage imageNamed:imageName];
            [shipImage drawInRect:shipRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
        }
    }
    [super drawRect:dirtyRect];
}
@end

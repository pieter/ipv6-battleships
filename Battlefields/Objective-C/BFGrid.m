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

        NSTrackingArea *area = [[NSTrackingArea alloc] initWithRect:[self bounds] options:NSTrackingMouseMoved|NSTrackingMouseEnteredAndExited|NSTrackingActiveInKeyWindow owner:self userInfo:nil];
        [self addTrackingArea:area];
    }
    
    return self;
}

- (void)mouseExited:(NSEvent *)theEvent;
{
    [[self delegate] gridmouseOut:self];

    for (BFGridCell *cell in [self cells])
        [cell setMouseOver:NO];
    
    [self setNeedsDisplay:YES];
}

- (void)mouseEntered:(NSEvent *)theEvent;
{
}

- (void)mouseMoved:(NSEvent *)theEvent;
{
    NSPoint localPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    NSInteger row,col;
    [self getRow:&row column:&col forPoint:localPoint];
    if (col < 0 || row < 0)
        return;
    
    [[self delegate] grid:self mouseOverAtX:col Y:row];

    if (![self ships]) {
        BFGridCell *mouseCell = [self cellAtRow:row column:col];
        for (BFGridCell *cell in [self cells])
            [cell setMouseOver:(cell == mouseCell)];

        [self setNeedsDisplay:YES];
    }
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

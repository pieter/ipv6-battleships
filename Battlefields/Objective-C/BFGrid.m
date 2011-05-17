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

- (id)initWithFrame:(NSRect)theFrame delegate:(id<BFGridDelegate>)theDelegate;
{
    if ((self = [super initWithFrame:theFrame mode:NSHighlightModeMatrix cellClass:[BFGridCell class] numberOfRows:10 numberOfColumns:10])) {
        [self setCellSize:NSMakeSize(19, 19)];
        [self setDelegate:theDelegate];

        // Initialization code here.
    }
    
    return self;
}

@end

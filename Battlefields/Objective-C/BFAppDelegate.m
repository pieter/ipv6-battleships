//
//  BFAppDelegate.m
//  Battlefields
//
//  Created by Pieter de Bie on 14-05-2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BFAppDelegate.h"
#import "BFBBattlefields.h"
#import "BFGridCell.h"

@interface BFAppDelegate ()

@property (retain) BFBBattlefields *field;
@end

@implementation BFAppDelegate
@synthesize statusLabel;
@synthesize yourGrid;
@synthesize yourIDLabel;
@synthesize yourPrefixLabel;
@synthesize window, theirIDField, theirPrefixField;
@synthesize field = i_field;

- (id)init
{
    self = [super init];
    if (self) {
        BFBBattlefields *field = [[NSClassFromString(@"BFBBattlefields") alloc] initWithInterface:@"en1" prefix:nil gameID:nil];
        [self setField:field];
    }
    
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)theNotification
{
    [[self yourPrefixLabel] setStringValue:[NSString stringWithFormat:@"Your Prefix: %@", [[self field] interfacePrefix]]];
    [[self yourIDLabel] setStringValue:[NSString stringWithFormat:@"ID: %@", [[self field] gameID]]];
    
    NSLog(@"Creating grid. Old view: %@ frame: %@", [self yourGrid], NSStringFromRect([[self yourGrid] frame]));
    NSMatrix *grid = [[NSMatrix alloc] initWithFrame:[[self yourGrid] frame] mode:NSHighlightModeMatrix cellClass:[BFGridCell class] numberOfRows:10 numberOfColumns:10];
    [grid setCellSize:NSMakeSize(19, 19)];
    [grid setTarget:self];
    [grid setAction:@selector(gridClicked:)];
    [[[self yourGrid] superview] replaceSubview:[self yourGrid] with:grid];
    [self setYourGrid:grid];
}

- (IBAction)startGame:(id)sender;
{
    NSString *theirPrefix = [[self theirPrefixField] stringValue];
    NSString *theirGameID = [[self theirIDField] stringValue];
    [[self field] setOpponentPrefix:theirPrefix gameID:[NSNumber numberWithInt:[theirGameID intValue]]];
    NSLog(@"Field is: %@. Opponent is %@/%@", [self field], theirPrefix, theirGameID);
    [[self statusLabel] setStringValue:@"Setting up.."];
    [[self field] setUp];
    [[self statusLabel] setStringValue:@"Done"];
}

- (IBAction)stopGame:(id)sender {
    [[self field] cleanUp];
}

- (IBAction)gridClicked:(id)sender;
{
    NSInteger row, column;
    [[self yourGrid] getRow:&row column:&column ofCell:[[self yourGrid] selectedCell]];
    
    NSLog(@"Requesting state of other player at %ld , %ld", row, column);
    NSNumber *x = [NSNumber numberWithInteger:row];
    NSNumber *y = [NSNumber numberWithInteger:column];
    NSLog(@"Their address: %@", [[self field] theirAddressForX:x Y:y]);
    id isShip = [[self field] opponentHasShipAtX:x Y:y];
    NSLog(@"Is available: %@", isShip);
}
@end

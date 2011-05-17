//
//  BFAppDelegate.m
//  Battlefields
//
//  Created by Pieter de Bie on 14-05-2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BFAppDelegate.h"
#import "BFBBattlefields.h"

#import "BFGrid.h"
#import "BFGridCell.h"

@interface BFAppDelegate ()
@property (retain) BFBBattlefields *field;

- (void)setUpGrid;

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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shipLookupDidFinishNotification:) name:BFBBattlefieldsHasShipCheckCompleteNotification object:field];
    }
    
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)theNotification
{
    [NSApp setPresentationOptions:[NSApp presentationOptions] | NSApplicationPresentationFullScreen];
    [[self window] setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];

    // Set up label and prefix
    [[self yourPrefixLabel] setStringValue:[NSString stringWithFormat:@"Your Prefix: %@", [[self field] interfacePrefix]]];
    [[self yourIDLabel] setStringValue:[NSString stringWithFormat:@"ID: %@", [[self field] gameID]]];

    [self setUpGrid];
}

- (void)setUpGrid;
{
    id oldGrid = [self yourGrid];
    
    BFGrid *newGrid = [[BFGrid alloc] initWithFrame:[oldGrid frame] delegate:self];
    [newGrid setTarget:self];
    [newGrid setAction:@selector(gridClicked:)];

    [[oldGrid superview] replaceSubview:oldGrid with:newGrid];
    [self setYourGrid:newGrid];
    
    // Set up state
    for (size_t i = 0; i < 100; ++i) {
        theirState[i] = BFGridStateUnknown;
    }
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
    [[self field] opponentHasShipAtX:x Y:y];
}

- (void)shipLookupDidFinishNotification:(NSNotification *)theNotification;
{
    NSNumber *isShip = [[theNotification userInfo] objectForKey:@"isShip"];
    NSInteger x = [[[theNotification userInfo] objectForKey:@"x"] integerValue];
    NSInteger y = [[[theNotification userInfo] objectForKey:@"y"] integerValue];
    theirState[x + 10 * y] = [isShip boolValue] ? BFGridStateShip : BFGridStateEmpty;
    [[self yourGrid] setNeedsDisplay];

}
- (BFGridState)stateForCellAtX:(NSInteger)x Y:(NSInteger)y;
{
    return theirState[x + 10 *y];
}
@end

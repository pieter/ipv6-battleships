//
//  BFAppDelegate.m
//  Battlefields
//
//  Created by Pieter de Bie on 14-05-2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

static NSString * const INTERFACE = @"en1";
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
@synthesize yourGrid, theirGrid, yourGridSuperview, theirGridSuperview;
@synthesize logView;
@synthesize yourIDLabel;
@synthesize yourPrefixLabel;
@synthesize window, theirIDField, theirPrefixField;
@synthesize field = i_field;

- (id)init
{
    self = [super init];
    if (self) {
        BFBBattlefields *field = [[NSClassFromString(@"BFBBattlefields") alloc] initWithInterface:INTERFACE prefix:nil gameID:nil];
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
    [[self theirPrefixField] setStringValue:[[self field] interfacePrefix]];

    [self setUpGrid];
}

- (void)setUpGrid;
{
    // Set up state
    for (size_t i = 0; i < 100; ++i) {
        theirState[i] = BFGridStateUnknown;
        yourState[i] = BFGridStateUnknown;
    }

    // Set up your grid
    [self setYourGrid:[[BFGrid alloc] initWithFrame:[[self yourGridSuperview] bounds] delegate:self]]; 
    [[self yourGridSuperview] addSubview:[self yourGrid]];

    // Set up their grid
    [self setTheirGrid:[[BFGrid alloc] initWithFrame:[[self theirGridSuperview] bounds] delegate:self]]; 
    [[self theirGridSuperview] addSubview:[self theirGrid]];
    // Their grid needs to be clickable
    [[self theirGrid] setTarget:self];
    [[self theirGrid] setAction:@selector(gridClicked:)];    
}

- (void)addLogMessage:(NSString *)theMessage;
{
    NSAttributedString *newLine = [[NSAttributedString alloc] initWithString:[theMessage stringByAppendingString:@"\n"]];
   [[[self logView] textStorage] appendAttributedString:newLine];
}

- (IBAction)startGame:(id)sender;
{
    NSString *theirPrefix = [[self theirPrefixField] stringValue];
    NSString *theirGameID = [[self theirIDField] stringValue];
    [[self field] setOpponentPrefix:theirPrefix gameID:[NSNumber numberWithInt:[theirGameID intValue]]];
    [self  addLogMessage:@"Setting up the game"];
    [[self field] performSelector:@selector(setUp) withObject:nil afterDelay:0.1];
    [self performSelector:@selector(setUpFinished) withObject:nil afterDelay:0.1];
}

- (void)setUpFinished;
{
    [self addLogMessage:@"Ready to play the game"];
    [[self field] monitorICMP:self];
    for (size_t i = 0; i < 100; ++i) {
        yourState[i] = [[[self field] playerHasShipAtX:[NSNumber numberWithInteger:i % 10] Y:[NSNumber numberWithInteger:i / 10]] boolValue] ? BFGridStateShip : BFGridStateEmpty;
    }
    [[self yourGrid] setNeedsDisplay:TRUE];

}
- (IBAction)stopGame:(id)sender {
    [[self field] cleanUp];
}

- (IBAction)gridClicked:(id)sender;
{
    NSInteger row, column;
    [[self theirGrid] getRow:&row column:&column ofCell:[[self theirGrid] selectedCell]];
    [self addLogMessage:[NSString stringWithFormat:@"Requesting state of other player at %ld , %ld", row, column]];
    NSNumber *x = [NSNumber numberWithInteger:row];
    NSNumber *y = [NSNumber numberWithInteger:column];
    [self addLogMessage:[NSString stringWithFormat:@"Their address: %@", [[self field] theirAddressForX:x Y:y]]];
    [[[self field] opponentHasShipAtX:x Y:y] boolValue];
}

- (void)ICMPMonitor:(id)theMonitor didLog:(NSString *)theLine;
{
    [self addLogMessage:theLine];
}

- (void)ICMPMonitor:(id)theMonitor monitoredOpponentRequestingX:(NSNumber *)theX Y:(NSNumber *)theY;
{
    [self addLogMessage:[NSString stringWithFormat:@"BOOM!!! The opponent did X:%@ Y:%@", theX, theY]];
}

- (void)shipLookupDidFinishNotification:(NSNotification *)theNotification;
{
    NSNumber *isShip = [[theNotification userInfo] objectForKey:@"isShip"];
    NSInteger x = [[[theNotification userInfo] objectForKey:@"x"] integerValue];
    NSInteger y = [[[theNotification userInfo] objectForKey:@"y"] integerValue];
    theirState[x + 10 * y] = [isShip boolValue] ? BFGridStateShip : BFGridStateEmpty;
    [[self theirGrid] setNeedsDisplay];

}
- (BFGridState)stateForGrid:(BFGrid *)theGrid cellAtX:(NSInteger)x Y:(NSInteger)y;
{
    return theGrid == [self yourGrid] ? yourState[x + 10 *y] : theirState[x + 10 *y];
}

@end

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
- (void)setTheirIP:(NSString *)theIPAddress;
- (void)setOurIP:(NSString *)theIPAddress;

@end

@implementation BFAppDelegate

@synthesize yourGrid, theirGrid, yourGridSuperview, theirGridSuperview, yourCurrentIP, theirCurrentIP;
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

    // Set up the setup window ;)
    [[self yourPrefixLabel] setStringValue:[NSString stringWithFormat:@"Your Prefix: %@", [[self field] interfacePrefix]]];
    [[self yourIDLabel] setStringValue:[NSString stringWithFormat:@"ID: %@", [[self field] gameID]]];
    [[self theirPrefixField] setStringValue:[[self field] interfacePrefix]];

    // Set up the main window
    [[self window] setBackgroundColor:[NSColor colorWithCalibratedRed:66.0/255 green:39.0/255 blue:0.0 alpha:1.0]];
    [self setTheirIP:@""];
    [self setOurIP:@""];
    [self setUpGrid];
}

- (void)setUpGrid;
{
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
    NSMutableAttributedString *newLine = [[[NSAttributedString alloc] initWithString:[theMessage stringByAppendingString:@"\n"]] mutableCopy];
    NSFont *font = [NSFont fontWithName:@"Courier" size:14.0];
    if ([theMessage hasPrefix:@"The "])
        font = [NSFont fontWithName:@"Courier" size:18.0];
    [newLine setAttributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName] range:NSMakeRange(0, [newLine length])];
    [[[self logView] textStorage] appendAttributedString:newLine];
    
    [[self logView] scrollRangeToVisible:NSMakeRange([[[self logView] textStorage] length], 0)];
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

- (void)setTheirIP:(NSString *)theIPAddress;
{
    [[self theirCurrentIP] setStringValue:[[self field] prettifyIP:theIPAddress]];
}

- (void)setOurIP:(NSString *)theIPAddress;
{
    [[self yourCurrentIP] setStringValue:[[self field] prettifyIP:theIPAddress]];
}

- (void)setUpFinished;
{
    [self addLogMessage:@"Ready to play the game"];
    [[self field] monitorICMP:self];

    [[self yourGrid] setShips:[[self field] ships]];
    [[self yourGrid] setNeedsDisplay:TRUE];
    
    [self setOurIP: [[self field] addressForX:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:0]]];
    [self setTheirIP: [[self field] theirAddressForX:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:0]]];
}
- (IBAction)stopGame:(id)sender {
    [[self field] cleanUp];
}

- (IBAction)gridClicked:(id)sender;
{
    NSInteger row, column;
    [[self theirGrid] getRow:&row column:&column ofCell:[[self theirGrid] selectedCell]];
    [self addLogMessage:[NSString stringWithFormat:@"Requesting state of other player at %ld , %ld", row, column]];
    NSNumber *x = [NSNumber numberWithInteger:column];
    NSNumber *y = [NSNumber numberWithInteger:row];
    [self addLogMessage:[NSString stringWithFormat:@"Their address: %@", [[self field] theirAddressForX:x Y:y]]];
    [[[self field] opponentHasShipAtX:x Y:y] boolValue];
}

- (void)ICMPMonitor:(id)theMonitor didLog:(NSString *)theLine;
{
    [self addLogMessage:theLine];
}

- (void)ICMPMonitor:(id)theMonitor monitoredOpponentRequestingX:(NSNumber *)theX Y:(NSNumber *)theY;
{
    [self addLogMessage:[NSString stringWithFormat:@"The Opponent bombed you at X:%@ Y:%@", theX, theY]];
    BFGridState newState;
    if ([[[self field] playerHasShipAtX:theX Y:theY ] boolValue])
        newState = BFGridStateHit;
    else
        newState = BFGridStateMiss;
    NSInteger x = [theX integerValue];
    NSInteger y = [theY integerValue];
    yourState[x + (y * 10)] = newState;
    
    [[self yourGrid] setNeedsDisplay:YES];
}

- (void)shipLookupDidFinishNotification:(NSNotification *)theNotification;
{
    NSNumber *isShip = [[theNotification userInfo] objectForKey:@"isShip"];
    NSInteger x = [[[theNotification userInfo] objectForKey:@"x"] integerValue];
    NSInteger y = [[[theNotification userInfo] objectForKey:@"y"] integerValue];
    theirState[x + (10 * y)] = [isShip boolValue] ? BFGridStateHit : BFGridStateMiss;
    [[self theirGrid] setNeedsDisplay];

}
- (BFGridState)stateForGrid:(BFGrid *)theGrid cellAtX:(NSInteger)x Y:(NSInteger)y;
{
    return theGrid == [self yourGrid] ? yourState[x + 10 *y] : theirState[x + 10 *y];
}

@end

//
//  BFAppDelegate.m
//  Battlefields
//
//  Created by Pieter de Bie on 14-05-2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BFAppDelegate.h"
#import "BFBBattlefields.h"

@interface BFAppDelegate ()

@property (retain) BFBBattlefields *field;
@end

@implementation BFAppDelegate
@synthesize statusLabel;
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
}

- (IBAction)startGame:(id)sender;
{
    NSString *prefix = [[self theirPrefixField] stringValue];
    NSString *gameID = [[self theirIDField] stringValue];

    NSLog(@"Field is: %@", [self field]);
    [[self statusLabel] setStringValue:@"Setting up.."];
    [[self field] setUp];
    [[self statusLabel] setStringValue:@"Done"];
}
@end

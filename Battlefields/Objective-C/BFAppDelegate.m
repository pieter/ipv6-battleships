//
//  BFAppDelegate.m
//  Battlefields
//
//  Created by Pieter de Bie on 14-05-2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BFAppDelegate.h"
#import "BFBBattlefields.h"

@implementation BFAppDelegate

@class Battlefields;
@synthesize window, prefixLabel;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)theNotification
{
    id a = [[NSClassFromString(@"BFBBattlefields") alloc] initWithInterface:@"en" prefix:@"aaaa:bbbb:cccc:dddd" gameID:@"1234"];
    NSLog(@"AAA %@", [a class]);
    
    NSLog(@"%@", [a gamePrefix]);
    
    [[self prefixLabel] setStringValue:[a gamePrefix]];
}
@end

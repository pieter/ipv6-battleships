//
//  BFAppDelegate.h
//  Battlefields
//
//  Created by Pieter de Bie on 14-05-2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BFGrid.h"

@interface BFAppDelegate : NSObject <BFGridDelegate> {
    NSTextField *statusLabel;
    NSTextView *logView;
    NSTextField *yourIDLabel;
    NSTextField *yourPrefixLabel;
    
    // Players' own stuff
    BFGrid *yourGrid;
    BFGrid *theirGrid;
    
    NSView *yourGridSuperview;
    NSView *theirGridSuperview;

    // Enemy stuff
    BFGridState theirState[100];
    BFGridState yourState[100];
    
    
}


@property (retain) NSWindow *window;
@property (assign) IBOutlet NSTextField *statusLabel;
@property (assign) IBOutlet NSTextView *logView;

@property (retain) IBOutlet NSTextField *theirIDField;
@property (retain) IBOutlet NSTextField *theirPrefixField;
@property (assign) IBOutlet NSTextField *yourIDLabel;
@property (assign) IBOutlet NSTextField *yourPrefixLabel;

@property (assign) IBOutlet NSView *yourGridSuperview;
@property (assign) IBOutlet NSView *theirGridSuperview;

@property (assign) BFGrid *yourGrid;
@property (assign) BFGrid *theirGrid;

- (IBAction)startGame:(id)sender;
- (IBAction)stopGame:(id)sender;

- (IBAction)gridClicked:(id)sender;

// ICMP feedback data
- (void)ICMPMonitor:(id)theMonitor didLog:(NSString *)theLine;
- (void)ICMPMonitor:(id)theMonitor monitoredOpponentRequestingX:(NSNumber *)theX Y:(NSNumber *)theY;
@end

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
    
    // Players' own stuff
    BFGrid *yourGrid;
    NSTextView *logView;
    NSTextField *yourIDLabel;
    NSTextField *yourPrefixLabel;
    
    // Enemy stuff
    BFGrid *theirGrid;
    BFGridState theirState[100];
}


@property (retain) NSWindow *window;
@property (assign) IBOutlet NSTextField *statusLabel;
@property (assign) IBOutlet NSMatrix *yourGrid;
@property (assign) IBOutlet NSTextView *logView;

@property (retain) IBOutlet NSTextField *theirIDField;
@property (retain) IBOutlet NSTextField *theirPrefixField;
@property (assign) IBOutlet NSTextField *yourIDLabel;
@property (assign) IBOutlet NSTextField *yourPrefixLabel;

- (IBAction)startGame:(id)sender;
- (IBAction)stopGame:(id)sender;

- (IBAction)gridClicked:(id)sender;
@end

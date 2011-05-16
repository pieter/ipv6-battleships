//
//  BFAppDelegate.h
//  Battlefields
//
//  Created by Pieter de Bie on 14-05-2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BFAppDelegate : NSObject {
    NSTextField *statusLabel;
    NSTextField *yourIDLabel;
    NSTextField *yourPrefixLabel;
}


@property (retain) NSWindow *window;
@property (assign) IBOutlet NSTextField *statusLabel;

@property (retain) IBOutlet NSTextField *theirIDField;
@property (retain) IBOutlet NSTextField *theirPrefixField;
@property (assign) IBOutlet NSTextField *yourIDLabel;
@property (assign) IBOutlet NSTextField *yourPrefixLabel;

- (IBAction)startGame:(id)sender;
- (IBAction)stopGame:(id)sender;
@end

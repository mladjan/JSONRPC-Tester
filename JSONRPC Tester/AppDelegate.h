//
//  AppDelegate.h
//  JSONRPC Tester
//
//  Created by Mladjan Antic on 11/14/11.
//  Copyright (c) 2011 mladjanantic.com All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JSONRPCService.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, JSONRPCServiceDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSTextField *urlField;
@property (assign) IBOutlet NSTextField *method;
@property (assign) IBOutlet NSButton *submitButton;
@property (assign) JSONRPCService* svc;
@property (assign) IBOutlet NSTextField *response;
@property (assign) IBOutlet NSTextField *params;

- (IBAction)sendAction:(id)sender;

@end

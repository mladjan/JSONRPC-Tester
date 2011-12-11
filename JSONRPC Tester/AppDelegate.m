//
//  AppDelegate.m
//  JSONRPC Tester
//
//  Created by Mladjan Antic on 11/14/11.
//  Copyright (c) 2011 mladjanantic.com All rights reserved.
//

#import "AppDelegate.h"
#import "JSONRPCService.h"
#import "JSONKit.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize urlField = _urlField;
@synthesize method = _method;
@synthesize submitButton = _submitButton;
@synthesize svc;
@synthesize response = _response;
@synthesize params = _params;

- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}


- (IBAction)sendAction:(id)sender {
    [_urlField resignFirstResponder];
	
    if([_urlField.stringValue isEqualToString:@""] || [_method.stringValue isEqualToString:@""] || [_params.stringValue isEqualToString:@""]){
        // Alert
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"Fileds: URL, method and params are required!"];
        [alert addButtonWithTitle:@"Ok"];
        [alert runModal];
        [alert release];
        alert = nil;
    }else{
        [svc release];
        svc = [[JSONRPCService alloc] initWithURL:[NSURL URLWithString:_urlField.stringValue]];
        svc.delegate = self;
        
        
        NSArray *response = [_params.stringValue objectFromJSONString];
        
        
        NSLog(@"params: %@, Object type: %@, content: %@",_params.stringValue, [response class], response);
        
        NSString *withID = [NSString stringWithFormat:@"%i", [response count]];
        
        [svc execMethod:_method.stringValue 
              andParams:response 
                 withID:withID];

    }
}


#pragma mark -
#pragma mark JSONRPCServiceDelegate


-(void) dataLoaded:(NSData*)data {
	_response.stringValue = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
}

-(void) loadingFailed:(NSString*) errMsg {
	_response.stringValue = errMsg;
}


@end

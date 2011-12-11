//
//  JSONRPCService.h
//  WorldCupResource
//
//  Created by ivan on 24.4.10..
//  Copyright 2010 Dizzey.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JSONRPCServiceDelegate
-(void) dataLoaded:(NSData*)data;
-(void) loadingFailed:(NSString*) errMsg;
@end


@interface JSONRPCService : NSObject {
	NSURL* url;
	NSURLConnection *urlConnection;

	id<JSONRPCServiceDelegate> delegate;
	
	NSString* username;
	NSString* password;
	
	NSMutableData* webData;
}

@property (assign) id<JSONRPCServiceDelegate> delegate;

-(id) initWithURL:(NSURL*)serviceURL;
-(id) initWithURL:(NSURL*)serviceURL user:(NSString*)user pass:(NSString*)pass;
-(void) execMethod:(NSString*)methodName andParams:(NSArray*)parameters withID:(NSString*)identificator;

-(void) cancelRequest;

@end

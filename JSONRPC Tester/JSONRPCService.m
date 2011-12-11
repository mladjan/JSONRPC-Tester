//
//  JSONRPCService.m
//  WorldCupResource
//
//  Created by ivan on 24.4.10..
//  Copyright 2010 Dizzey.com. All rights reserved.
//

#import "JSONRPCService.h"
#import "JSONKit.h"

@implementation JSONRPCService
@synthesize delegate;

-(id) initWithURL:(NSURL*)serviceURL {
	return [self initWithURL:serviceURL user:nil pass:nil];
}

-(id) initWithURL:(NSURL*)serviceURL user:(NSString*)user pass:(NSString*)pass {
	if (self = [super init]) {
		url = [serviceURL retain];
		username = [user retain];
		password = [pass retain];
	}
	
	return self;
}


-(void) execMethod:(NSString*)methodName andParams:(NSArray*)parameters withID:(NSString*)identificator {

	//RPC
	NSMutableDictionary* reqDict = [NSMutableDictionary dictionary];
	[reqDict setObject:methodName forKey:@"method"];
	[reqDict setObject:parameters forKey:@"params"];
	[reqDict setObject:identificator forKey:@"id"];
	
	//RPC JSON
	NSString* reqString = [NSString stringWithString:[reqDict JSONString]];
	
	//Request
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
	NSData* requestData = [NSData dataWithBytes:[reqString UTF8String] length:[reqString length]];
	
	//prepare http body
	[request setHTTPMethod: @"POST"];
	[request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody: requestData];
		
	if (urlConnection != nil) {
		[urlConnection release];
		urlConnection = nil;
	}
	
	urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
	[request release];

}


-(void) cancelRequest {
	
	if (urlConnection) {
		[urlConnection cancel];
		[urlConnection release];
		urlConnection = nil;
		[webData release];
		webData = nil;
	}
	

}

#pragma mark -
#pragma mark NSURLConnection delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"Did receive response: %@", response);
	
	[webData release];
	webData = [[NSMutableData alloc] init];
}


-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	assert(webData != nil);
	[webData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[webData release];
	webData = nil;
	[urlConnection release];
	urlConnection = nil;
	
	
	//notify
	[delegate loadingFailed:[error localizedDescription]];
}


-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[urlConnection release];
	urlConnection = nil;
	
	
	//DO something with webData
	[delegate dataLoaded:webData];
	
	[webData release];
	webData = nil;
}

-(void) dealloc {
	[webData release];
	[username release];
	[password release];
	[urlConnection release];
	[url release];
	[super dealloc];
}
@end

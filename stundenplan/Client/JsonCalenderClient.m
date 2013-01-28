//
//  JsonCalenderClient.m
//  stundenplan
//
//  Created by Christoph Jerolimov on 25.01.2013.
//  Copyright (c) 2013 FH-Köln. All rights reserved.
//

#import "JsonCalenderClient.h"

#import <AFNetworking/AFJSONRequestOperation.h>

@implementation JsonCalenderClient

#pragma mark - Initialization / deallocation

- (id)init {
	// Until there is no alternative server we didn't need a configuration for that.
	// TODO idea: externalize all configuration to an small json file which will be loaded at start
	return [self initWithBaseURL:[NSURL URLWithString:@"http://nils-becker.com/calendar"]];
}

- (id)initWithBaseURL:(NSURL *)url {
	self = [super initWithBaseURL:url];
	if (self) {
		[self registerHTTPOperationClass:[AFJSONRequestOperation class]];
		[self setDefaultHeader:@"Accept" value:[self jsonAcceptHeader]];
	}
	return self;
}

- (NSString*) jsonAcceptHeader {
    return [[[AFJSONRequestOperation acceptableContentTypes] allObjects] componentsJoinedByString:@";"];
}

#pragma mark - Asynchronous calls defined in the client API

- (void) branchesWithSuccess:(void (^)(AFHTTPRequestOperation* operation, NSArray* branches))success
					failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure {
	
	NSURLRequest* request = [self requestWithMethod:@"GET" path:@"branches" parameters:nil];
	AFHTTPRequestOperation* operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
	[self enqueueHTTPRequestOperation:operation];
}

- (void) lecturersWithSuccess:(void (^)(AFHTTPRequestOperation* operation, NSArray* lecturers))success
					  failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure {
	
	NSURLRequest* request = [self requestWithMethod:@"GET" path:@"lecturers" parameters:nil];
	AFHTTPRequestOperation* operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
	[self enqueueHTTPRequestOperation:operation];
}

/*
 
 falls wir das mal brauchen ein etwas kompliziertes beispiel
 
 mit parametern rein und die rückgabe gibt speziell nur einen wert zurück
 
- (void) xy:(NSString*) xy
			   withSuccess:(void (^)(AFHTTPRequestOperation *operation, NSString* back))success
				   failure:(void (^)(AFHTTPRequestOperation *operation, NSError* error))failure {
	NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
	if (username) {
		[parameters xy forKey:@"xy"];
	}
	
	NSURLRequest* request = [self requestWithMethod:@"GET" path:verificationTokenNamespace parameters:parameters];
	AFHTTPRequestOperation* operation = [self JSONRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
		if (success) {
			success(operation, [responseObject valueForKey:@"back"]);
		}
	} failure:failure];
	[self enqueueHTTPRequestOperation:operation];
}
*/

@end

//
//  IcalCalenderClient.m
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import "IcalCalenderClient.h"

#import <AFCalendarRequestOperation/AFCalendarRequestOperation.h>

@implementation IcalCalenderClient

#pragma mark - Initialization / deallocation

- (id)init {
	// Until there is no alternative server we didn't need a configuration for that.
	// TODO idea: externalize all configuration to an small json file which will be loaded at start
	return [self initWithBaseURL:[NSURL URLWithString:@"http://advbs06.gm.fh-koeln.de:8080/icalender"]];
}

- (id)initWithBaseURL:(NSURL *)url {
	self = [super initWithBaseURL:url];
	if (self) {
		[self registerHTTPOperationClass:[AFCalendarRequestOperation class]];
		[self setDefaultHeader:@"Accept" value:@"text/calendar"];
	}
	return self;
}

#pragma mark - Asynchronous calls defined in the client API

- (void) allWithSuccess:(void (^)(AFHTTPRequestOperation* operation, NSArray* events))success
				failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure {
	[self sqlQuery:nil withSuccess:success failure:failure];
}

- (void) sqlQuery:(NSString*) query
	  withSuccess:(void (^)(AFHTTPRequestOperation* operation, NSArray* events))success
		  failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure {
	
	if (!query) {
		query = @"null is null";
	}
	
	NSURLRequest* request = [self requestWithMethod:@"GET" path:@"ical" parameters:@{ @"sqlabfrage": query }];
	
	AFCalendarRequestOperation* operation = [AFCalendarRequestOperation calendarRequestOperationWithRequest:request success:^(AFCalendarRequestOperation* operation) {
		if (success) {
			success(operation, operation.responseEvents);
		}
	} failure:^(AFCalendarRequestOperation* operation, NSError *error) {
		if (failure) {
			failure(operation, error);
		}
	}];
	 
	[self enqueueHTTPRequestOperation:operation];
}

@end

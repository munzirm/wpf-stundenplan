//
//  IcalCalenderClient.m
//  stundenplan
//
//  Created by Christoph Jerolimov on 25.01.2013.
//  Copyright (c) 2013 FH-Köln. All rights reserved.
//

#import "IcalCalenderClient.h"

@implementation IcalCalenderClient

#pragma mark - Initialization / deallocation

- (id)init {
	return [super initWithBaseURL:[NSURL URLWithString:@"http://advbs06.gm.fh-koeln.de:8080/icalender"]];
}

#pragma mark - Asynchronous calls defined in the client API

- (void) allWithSuccess:(void (^)(AFHTTPRequestOperation *operation, AFCalender* calender))success
				failure:(void (^)(AFHTTPRequestOperation *operation, NSError* error))failure {
	[self sqlQuery:nil withSuccess:success failure:failure];
}

- (void) sqlQuery:(NSString*) query
	  withSuccess:(void (^)(AFHTTPRequestOperation *operation, AFCalender* calender))success
		  failure:(void (^)(AFHTTPRequestOperation *operation, NSError* error))failure {
	
	if (!query) {
		query = @"null is null";
	}
	
	NSURLRequest* request = [self requestWithMethod:@"GET" path:@"ical" parameters:@{ @"sqlabfrage": query }];
	AFHTTPRequestOperation* operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
	[self enqueueHTTPRequestOperation:operation];	
}

@end

//
//  IcalCalenderClient.m
//  stundenplan
//
//  Created by Christoph Jerolimov on 25.01.2013.
//  Copyright (c) 2013 FH-Köln. All rights reserved.
//

#import "IcalCalenderClient.h"

#import <AFCalendarRequestOperation/AFCalendarRequestOperation.h>

@implementation IcalCalenderClient

#pragma mark - Initialization / deallocation

- (id)init {
	self = [super initWithBaseURL:[NSURL URLWithString:@"http://advbs06.gm.fh-koeln.de:8080/icalender"]];
	if (self) {
		[self registerHTTPOperationClass:[AFCalendarRequestOperation class]];
		[self setDefaultHeader:@"Accept" value:@"text/calendar"];
	}
	return self;
}

#pragma mark - Asynchronous calls defined in the client API

- (void) allWithSuccess:(void (^)(AFHTTPRequestOperation *operation, EKCalendar* calendar, NSArray* events))success
				failure:(void (^)(AFHTTPRequestOperation *operation, NSError* error))failure {
	[self sqlQuery:nil withSuccess:success failure:failure];
}

- (void) sqlQuery:(NSString*) query
	  withSuccess:(void (^)(AFHTTPRequestOperation *operation, EKCalendar* calendar, NSArray* events))success
		  failure:(void (^)(AFHTTPRequestOperation *operation, NSError* error))failure {
	
	if (!query) {
		query = @"null is null";
	}
	
	NSURLRequest* request = [self requestWithMethod:@"GET" path:@"ical" parameters:@{ @"sqlabfrage": query }];
	AFCalendarRequestOperation* operation = [AFCalendarRequestOperation calendarRequestOperation:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, EKCalendar *calendar, NSArray *events) {
		if (success) {
			success(operation, calendar, events);
		}
	} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
		if (failure) {
			failure(operation, error);
		}
	}];
	[self enqueueHTTPRequestOperation:operation];	
}

@end

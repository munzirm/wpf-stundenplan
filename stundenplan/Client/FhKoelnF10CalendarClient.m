//
//  IcalCalenderClient.m
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import "FhKoelnF10CalendarClient.h"

#import <AFCalendarRequestOperation/AFCalendarRequestOperation.h>

@implementation FhKoelnF10CalendarClient

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

- (void) eventForStore:(EKEventStore *)store
			   success:(void (^)(AFHTTPRequestOperation* operation, NSArray* events))success
			   failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure {

	NSMutableArray* parameters = [NSMutableArray array];
	if (_course) {
		[parameters addObject:[NSString stringWithFormat:@"SG_KZ = '%@'", _course]];
	}
	if (_semester) {
		[parameters addObject:[NSString stringWithFormat:@"SEMESTER_NR = '%@'", _semester]];
	}
	if (_modul) {
		[parameters addObject:[NSString stringWithFormat:@"KURZBEZ = '%@'", _modul]];
	}

	NSString* query = parameters.count == 0 ? @"null is null" : [parameters componentsJoinedByString:@" AND "];
	NSLog(@"GET %@", query);
	NSURLRequest* request = [self requestWithMethod:@"GET" path:@"ical" parameters:@{ @"sqlabfrage": query }];

	AFCalendarRequestOperation* operation = [AFCalendarRequestOperation calendarRequestOperationWithRequest:request andEventStore:store success:^(AFCalendarRequestOperation* operation) {
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

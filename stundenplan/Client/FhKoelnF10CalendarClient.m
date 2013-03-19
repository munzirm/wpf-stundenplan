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

	// Yeah, no "XSS" magic here, but we have no free input for this fields in our app.
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
			success(operation, [self summerizeAndCleanupEventData:operation.responseEvents]);
		}
	} failure:^(AFCalendarRequestOperation* operation, NSError *error) {
		if (failure) {
			failure(operation, error);
		}
	}];

	[self enqueueHTTPRequestOperation:operation];
}

- (NSArray*) summerizeAndCleanupEventData:(NSArray*) events {
	// Group and sort events
	NSSortDescriptor* titleSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
	NSSortDescriptor* dateSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:YES];
	events = [events sortedArrayUsingDescriptors:@[ titleSortDescriptor, dateSortDescriptor ]];
	
	NSMutableArray* result = [NSMutableArray array];
	EKEvent* prevEvent = nil;
	int eventsCount = [events count];
	
	for (EKEvent* event in events) {
		eventsCount--;
		
		// The first event
		if (!prevEvent) {
			prevEvent = event;
			continue;
		}
		
		// Replace two whitespaces with one...
		event.title = [event.title stringByReplacingOccurrencesOfString:@"  " withString:@" "];
		
		// Original data contains the full name of the modul as note, but we don't need it
		event.notes = nil;
		
		// Previous event with same name as the current event. Interval <= 15 minutes.
		if (
			prevEvent &&
			[prevEvent.title isEqualToString:event.title] &&
			[event.startDate timeIntervalSinceDate:prevEvent.endDate] <= 900 // 60*15 => 15 Minutes
			) {
			
			// Set the start date of the current event to the previous event
			prevEvent.endDate = event.endDate;
			
			if (eventsCount!=0)
				continue;
		}
		
		[result addObject:prevEvent];
		
		// Replace the previous event
		prevEvent = event;
	}
	
	return result;
}

@end

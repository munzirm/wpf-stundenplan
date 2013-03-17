//
//  CalendarController.m
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import "CalendarController.h"
#import "FhKoelnF10CalendarClient.h"

@implementation CalendarController {
	// The calendar store key
	NSString *calendarIdentifierKey;
}

- (id)init {
	self = [super init];

	if (self == nil)
		return nil;

	// The calendar store key
	calendarIdentifierKey = @"fh_koeln_stundenplan";

	// The event store
	self.store = [[EKEventStore alloc] init];

	return self;
}

/**
 Request permissions to the calendar
 */
- (void)requestAccessToCalendar:(void (^)(BOOL granted, NSError *error))callback {
	// request permissions
	if ([self.store respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
		// iOS 6 and later
		[self.store requestAccessToEntityType:EKEntityTypeEvent completion:callback];
	} else {
		// iOS 5
		callback(FALSE, NULL);
	}
}

/**
 Get the calendar
 */
- (EKCalendar *)getTheCalendar {
	if (self.calendar ) {
		return self.calendar;
	}
	// Get our custom calendar identifier
	NSString *calendarIdentifier = [[NSUserDefaults standardUserDefaults] valueForKey:calendarIdentifierKey];

	// When identifier exists, calendar probably already exists
	if (calendarIdentifier) {
		self.calendar = [self.store calendarWithIdentifier:calendarIdentifier];
	}

	// Calendar doesn't exist
	if (!self.calendar ) {
		// Create it
		self.calendar = [EKCalendar calendarForEntityType:EKEntityTypeEvent eventStore:self.store];

		// Set user visible calendar name
		[self.calendar setTitle:@"FH Köln Stundenplan"];

		// Find appropriate source type. Only local calendars
		for (EKSource *s in self.store.sources) {
			if (s.sourceType == EKSourceTypeLocal) {
				_calendar.source = s;
				break;
			}
		}

		// Save identifier to store it later
		NSString *calendarIdentifier = [_calendar calendarIdentifier];

		NSError *error = nil;
		BOOL saved = [self.store saveCalendar:self.calendar commit:YES error:&error];
		if (saved) {
			// Saved successfuly, store identifier in NSUserDefaults
			[[NSUserDefaults standardUserDefaults] setObject:calendarIdentifier forKey:calendarIdentifierKey];
		} else {
			// Unable to save calendar
			NSLog(@"Calendar Saving: %@", error);
		}
	}

	return self.calendar;
}

- (void)fetchCalendarFromRemote:(void (^)(NSArray *events))success {
	FhKoelnF10CalendarClient* icalCalenderClient = [[FhKoelnF10CalendarClient alloc] init];

	[icalCalenderClient query:@"SG_KZ = 'MI' and SEMESTER_NR = '4'" withEventStore:self.store onSuccess:^(AFHTTPRequestOperation* operation, NSArray* events) {

		for (EKEvent* event in events) {
			event.calendar = self.calendar;
			NSError *error = nil;
			BOOL result = [self.store saveEvent:event span:EKSpanThisEvent commit:YES error:&error];
			if (!result) {
				NSLog(@"Event Storing: %@", error);
			}
		}
		
		success(events);
	} onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"Request Operation: %@", error);
	}];
}

@end

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
	EKCalendar* _calendar;
}

- (id)init {
	self = [super init];

	if (self == nil)
		return nil;

	// The calendar store key
	calendarIdentifierKey = @"fh_koeln_stundenplan";

	// The event store
	self.store = [[EKEventStore alloc] init];
	_calendar = nil;

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
- (EKCalendar *)calendar {
	// DEBUG CLEAR CALENDAR
	/*NSString *_calendarIdentifier = [[NSUserDefaults standardUserDefaults] valueForKey:calendarIdentifierKey];
	EKCalendar *calendar = [self.store calendarWithIdentifier:_calendarIdentifier];
	NSError *error = nil;
	BOOL result = [self.store removeCalendar:calendar commit:YES error:&error];
	if (result) {
		NSLog(@"Deleted calendar from event store.");
	} else {
		NSLog(@"Deleting calendar failed: %@.", error);
	}
	_calendar = nil;*/
	// END DEBUG

	if (_calendar) {
		return _calendar;
	}

	// Get our custom calendar identifier
	NSString *calendarIdentifier = [[NSUserDefaults standardUserDefaults] valueForKey:calendarIdentifierKey];

	// When identifier exists, calendar probably already exists
	if (calendarIdentifier) {
		_calendar = [self.store calendarWithIdentifier:calendarIdentifier];
	}

	// Calendar doesn't exist
	if (!_calendar ) {
		// Create it
		_calendar = [EKCalendar calendarForEntityType:EKEntityTypeEvent eventStore:self.store];

		// Set user visible calendar name
		[_calendar setTitle:@"FH Köln Stundenplan"];

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
		BOOL saved = [self.store saveCalendar:_calendar commit:YES error:&error];
		if (saved) {
			// Saved successfuly, store identifier in NSUserDefaults
			[[NSUserDefaults standardUserDefaults] setObject:calendarIdentifier forKey:calendarIdentifierKey];
		} else {
			// Unable to save calendar
			NSLog(@"Calendar Saving: %@", error);
		}
	}

	return _calendar;
}

- (void)fetchCalendarFromRemote:(void (^)(void))success {
	FhKoelnF10CalendarClient* icalCalenderClient = [[FhKoelnF10CalendarClient alloc] init];

	[icalCalenderClient query:@"SG_KZ = 'MI' and SEMESTER_NR = '4'" withEventStore:self.store onSuccess:^(AFHTTPRequestOperation* operation, NSArray* events) {

		// Group and sort events
		NSSortDescriptor* sort1 = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
		NSSortDescriptor* sort2 = [NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:YES];
		events = [events sortedArrayUsingDescriptors:@[ sort1, sort2 ]];
		
		EKEvent *prevEvent = nil;
		int eventsCount = [events count];
		for (EKEvent* event in events) {
			eventsCount--;

			// The first event
			if (!prevEvent) {
				prevEvent = event;
				continue;
			}

			// Previous event with same name as the current event. Interval <= 15 minutes. 
			if (
				prevEvent &&
				[prevEvent.title isEqualToString:event.title] &&
				[event.startDate timeIntervalSinceDate:prevEvent.endDate] <= 900 // 60*15 => 15 Minutes
				) {

				// Set the start date of the current event to the previous event
				event.startDate = prevEvent.startDate;
				// Save the new previous event
				prevEvent = event;

				if (eventsCount!=0)
					continue;
			}


			// Add the calendar
			prevEvent.calendar = _calendar;
			// icalCalenderClient adds the full name of the modul as note,
			// but we don't need it
			prevEvent.notes = nil;

			// Increase end date by 15 minutes
			prevEvent.endDate = [prevEvent.endDate dateByAddingTimeInterval:60*15]; // 60*15 => 15 Minutes

			// Save the event
			NSError *error = nil;
			BOOL result = [self.store saveEvent:prevEvent span:EKSpanThisEvent commit:YES error:&error];
			if (!result) {
				NSLog(@"Event Storing: %@", error);
			}

			// Replace the previous event
			prevEvent = event;
		}

		// Call callback method
		success();
	} onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"Request Operation: %@", error);
	}];
}

@end

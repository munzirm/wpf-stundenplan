//
//  CalendarController.m
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import "CalendarController.h"

#import "FhKoelnF10CalendarClient.h"

enum CalendarControllerStatus {
	NOT_CHECKED,
	GRANTED,
	NOT_GRANTED
} typedef CalendarControllerStatus;

@implementation CalendarController {
	// The calendar store key
	NSString *calendarIdentifierKey;
	CalendarControllerStatus _status;
	EKEventStore* _store;
	EKCalendar* _calendar;
}

+ (id)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
	self = [super init];

	if (self) {
		// The calendar store key
		calendarIdentifierKey = @"fh_koeln_stundenplan";
	
		// The event store
		_status = NOT_CHECKED;
		_store = [[EKEventStore alloc] init];
		_calendar = nil;
		
		// Only for testing:
		for (EKCalendar* calendar in _store.calendars) {
			NSLog(@"Found calendar: %@", calendar);
			if ([calendar.title isEqualToString:@"FH Köln Stundenplan"]) {
				NSError* error = nil;
				[_store removeCalendar:calendar commit:YES error:&error];
				if (error) {
					NSLog(@"Error while remove calendar %@: %@", calendar, error);
				}
			} else {
				NSLog(@"REMOVED!");
			}
		}
	}

	return self;
}

- (void) moduleEventsWithSuccess: (void (^)(ModulEvents* moduleEvents))success
						 failure: (void (^)(NSError* error))failure {
	[self checkGrantsWithSuccess:^{
		
		if (self.events.events > 0) {
			
			if (success) {
				success(self.events);
			}
			
		} else if (self.events.events == 0) {
			
			NSLog(@"Keine Events...? Ich mach einfach welche rein dude...");
			
			[self addModules:@[ @"BS1", @"ST1" ] success:^{
				
				NSLog(@"Events hinzugefügt .. yeah");
				
				if (success) {
					success(self.events);
				}
				
			} failure:failure];
		}
		
	} failure:failure];
}

- (void) modulesWithSuccess: (void (^)(NSDictionary* modules))success
					failure: (void (^)(NSError* error))failure {
	[self checkGrantsWithSuccess:^{
		
		if (success) {
			success(self.events.modules);
		}
		
	} failure:failure];
}

- (void) eventsWithSuccess: (void (^)(NSArray* events))success
				   failure: (void (^)(NSError* error))failure {
	[self checkGrantsWithSuccess:^{
		
		if (success) {
			success(self.events.events);
		}
		
	} failure:failure];
}

/**
 Search the modules for the given courses and events.
 */
- (void) searchCourse: (NSString*) course
		  andSemester: (NSString*) semester
			  success: (void (^)(NSArray* modules))success
			  failure: (void (^)(NSError* error))failure {
	[self checkGrantsWithSuccess:^{
		
		FhKoelnF10CalendarClient* client = [[FhKoelnF10CalendarClient alloc] init];
		client.course = course;
		client.semester = semester;
		
		[client fetchModulesForStore:_store success:^(AFHTTPRequestOperation *operation, NSArray *modules) {
			if (success) {
				success(modules);
			}
		} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			if (failure) {
				failure(error);
			}
		}];
		
	} failure:failure];
}

- (void) addModules: (NSArray*) modules
			success: (void (^)())success
			failure: (void (^)(NSError* error))failure {
	[self checkGrantsWithSuccess:^{
		
		FhKoelnF10CalendarClient* client = [[FhKoelnF10CalendarClient alloc] init];
		client.modules = modules;
		
		[client fetchEventsForStore:_store success:^(AFHTTPRequestOperation *operation, NSArray *events) {
			
			[self storeEvents:events success:success failure:failure];
			
		} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			if (failure) {
				failure(error);
			}
		}];
		
	} failure:failure];
}

- (void) storeEvents: (NSArray*) events
			 success: (void (^)())success
			 failure: (void (^)(NSError* error))failure {
	[self checkGrantsWithSuccess:^{
		
		for (EKEvent* event in events) {
			// Add the calendar
			event.calendar = self.calendar;
			
			// Save the event
			NSError *error = nil;
			BOOL result = [_store saveEvent:event span:EKSpanThisEvent commit:YES error:&error];
			if (!result) {
				NSLog(@"Event storing error: %@", error);
			}
		}
		
		if (success) {
			success();
		}
		
	} failure:failure];
}

- (void) checkGrantsWithSuccess: (void (^)())success
						failure: (void (^)(NSError* error))failure {
	switch (_status) {
		case GRANTED:
			if (success) {
				success();
			}
			return;
		case NOT_GRANTED:
			if (failure) {
				failure(nil);
			}
			return;
		default:
			break;
	}
	
	[_store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
		_status = granted ? GRANTED : NOT_GRANTED;
		if (granted && success) {
			success();
		}
		if (!granted && failure) {
			failure(error);
		}
	}];
}

- (ModulEvents*) events {
	EKCalendar* calendar = [self calendar];
	
	// For demo proposes, display events for the next X days
	NSDate *startDate = [NSDate date];
	NSDate *endDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24*10];
	NSArray *calendars = [NSArray arrayWithObject:calendar];
	NSPredicate *predicate = [_store predicateForEventsWithStartDate:startDate endDate:endDate calendars:calendars];
	
	NSArray* events = [_store eventsMatchingPredicate:predicate];
	
	NSLog(@"Used: LOCAL -- found %i events", events.count);
	return [[ModulEvents alloc] initWithEvents:events];
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
		_calendar = [_store calendarWithIdentifier:calendarIdentifier];
	}

	// Calendar doesn't exist
	if (!_calendar) {
		// Create it
		_calendar = [EKCalendar calendarForEntityType:EKEntityTypeEvent eventStore:_store];

		// Set user visible calendar name
		[_calendar setTitle:@"FH Köln Stundenplan"];

		// Find appropriate source type. Only local calendars
		for (EKSource *s in _store.sources) {
			if (s.sourceType == EKSourceTypeLocal) {
				_calendar.source = s;
				break;
			}
		}

		// Save identifier to store it later
		NSString *calendarIdentifier = [_calendar calendarIdentifier];

		NSError *error = nil;
		BOOL saved = [_store saveCalendar:_calendar commit:YES error:&error];
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

@end

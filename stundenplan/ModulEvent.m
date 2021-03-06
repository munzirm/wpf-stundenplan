//
//  ModulEvent.m
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import "ModulEvent.h"
#import "MainViewController.h"
#import "CalendarController.h"
#import "Data.h"

@implementation ModulEvent {
	NSString *_modulType;
}

- (id)initWithEvent:(EKEvent *)event {
	self = [super init];

	if (self == nil)
		return nil;

	// Store the original event
	_event = event;

	// Labels
	NSArray *modulComponents = [event.title componentsSeparatedByString:@" "];
	_modulAcronym = [modulComponents objectAtIndex:0];
	_modulType = [modulComponents objectAtIndex:1];
	NSDictionary *data = [Data objectForKey:@"modules" andForKey:_modulAcronym];
	_modulFullName = [data valueForKey:@"name"];

	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	// Dates
	_startDate = _event.startDate;
	_endDate = _event.endDate;
	[dateFormatter setDateFormat:@"EEEE"];
	_weekday = [dateFormatter stringFromDate:event.startDate];

	// Time
	[dateFormatter setDateFormat:@"HH:mm"];
	_startTime = [dateFormatter stringFromDate:event.startDate];
	_endTime = [dateFormatter stringFromDate:event.endDate];

	// Location
	_modulLocation = _event.location;

	return self;
}

- (NSString *)modulType {
	NSDictionary *types =  @{@"S":@"Seminar", @"P":@"Praktikum", @"V":@"Vorlesung", @"UE":@"Übung"};

	return [types objectForKey:_modulType];
}

- (void)setModulColor:(UIColor *)color {
	_modulColor = color;
}

- (void) deleteEvent: (BOOL) andFollowing {
	if (andFollowing == NO) {
		[[CalendarController sharedInstance] removeEvent:self success:^(void) {
			/*[((MainViewController*) self.navigationController.parentViewController) updateData];
			[((MainViewController*) self.navigationController.parentViewController) openTimetableViewController];*/
		} failure:^(NSError *error) {
			NSLog(@"No event deleted: %@", error);
		}];
	}
}

@end

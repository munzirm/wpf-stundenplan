//
//  ModulEvent.m
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import "ModulEvent.h"

@implementation ModulEvent

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
	//_modulFullName = ...

	// Dates
	_startDate = _event.startDate;
	_endDate = _event.endDate;

	// Time
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"HH:mm"];
	_startTime = [dateFormatter stringFromDate:event.startDate];
	_endTime = [dateFormatter stringFromDate:event.endDate];

	return self;
}

- (void) setFavorite: (BOOL) favorite {
	
}

- (void) setStatus: (EKEventStatus) status {
	
}

- (void) deleteEvent: (BOOL) favorite {
	
}

@end

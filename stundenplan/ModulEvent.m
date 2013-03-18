//
//  ModulEvent.m
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import "ModulEvent.h"
#import "Data.h"

@implementation ModulEvent {
	EKEvent *_event;
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

	// Dates
	_startDate = _event.startDate;
	_endDate = _event.endDate;

	// Time
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
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

- (void) setStatus: (EKEventStatus) status {
	
}

- (void) deleteEvent: (BOOL) xy {
	
}

@end

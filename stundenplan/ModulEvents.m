//
//  ModulEvents.m
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import "ModulEvents.h"
#import "ColorGenerator.h"

@implementation ModulEvents {
	NSArray *_originalEvents;
	NSMutableDictionary *_daySections;
	NSArray *_sortedDays;
	NSMutableDictionary *_modules;
}

- (id)initWithEvents:(NSArray *)events {
	self = [super init];

	if (self == nil)
		return nil;

	// Save a copy
	_originalEvents = events;

	// The days
	_daySections = [NSMutableDictionary dictionary];
	// The events per day
	_sortedDays = nil;

	// The modules, saves the colors
	_modules = [NSMutableDictionary dictionary];

	[self prepareEventsForDisplay];

	return self;
}

-(NSMutableDictionary *)modules {
	return _modules;
}

- (void)prepareEventsForDisplay {
	for (EKEvent *event in _originalEvents) {
		ModulEvent *modulEvent = [[ModulEvent alloc] initWithEvent:event];

		// One color for each modul
		if ( [_modules objectForKey:modulEvent.modulAcronym] == nil ) {
			modulEvent.modulColor = [ColorGenerator randomColor];
			[_modules setObject:modulEvent.modulColor forKey:modulEvent.modulAcronym];
		} else {
			modulEvent.modulColor = [_modules objectForKey:modulEvent.modulAcronym];
		}
		
		// Reduce event start date to date components (year, month, day)
		NSDate *dateRepresentingThisDay = [self dateAtBeginningOfDayForDate:modulEvent.startDate];

		// If we don't yet have an array to hold the events for this day, create one
		NSMutableArray *eventsOnThisDay = [_daySections objectForKey:dateRepresentingThisDay];
		if (eventsOnThisDay == nil) {
			eventsOnThisDay = [NSMutableArray array];

			// Use the reduced date as dictionary key to later retrieve the event list this day
			[_daySections setObject:eventsOnThisDay forKey:dateRepresentingThisDay];
		}

		// Add the event to the list for this day
		[eventsOnThisDay addObject:modulEvent];
	}

	// Create a sorted list of days
	NSArray *unsortedDays = [_daySections allKeys];
	_sortedDays = [unsortedDays sortedArrayUsingSelector:@selector(compare:)];
}

- (NSDate *)dayAndMonthAndYearForDate:(NSDate *)date {
    // Use the user's current calendar and time zone
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
	[calendar setTimeZone:timeZone];
    
	// Selectively convert the date components (year, month, day) of the input date
	NSDateComponents *dateComps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:date];
    
	// Set the time components manually
	[dateComps setHour:0];
	[dateComps setMinute:0];
	[dateComps setSecond:0];
    
	// Convert back
	return [calendar dateFromComponents:dateComps];
}

- (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)date {
	return [self dayAndMonthAndYearForDate:date];
}

- (NSArray *)events {
	return _originalEvents;
}

- (NSInteger *)dayCount {
	return [_daySections count];
}

- (NSInteger *)eventCountOnThisDay:(NSInteger)section {
	NSDate *dateRepresentingThisDay = [_sortedDays objectAtIndex:section];
	NSArray *eventsOnThisDay = [_daySections objectForKey:dateRepresentingThisDay];

	return [eventsOnThisDay count];
}

- (NSString *)dateRepresentingThisDay:(NSInteger)section {
	NSDate *dateRepresentingThisDay = [_sortedDays objectAtIndex:section];
	NSDateFormatter *sectionDateFormatter = [[NSDateFormatter alloc] init];

    NSDate *today = [self dayAndMonthAndYearForDate:[NSDate date]];
    // tomorrow
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:1]; // for tomorrow
    NSDate *tomorrow = [calendar dateByAddingComponents:dateComponents toDate:today options:0];

	[sectionDateFormatter setDateFormat:@"dd.MM.yyyy"];
    if ([today isEqualToDate:dateRepresentingThisDay]) {
        return [NSString stringWithFormat:@"%@, %@", @"Heute", [sectionDateFormatter stringFromDate:dateRepresentingThisDay]];
    } else if ([tomorrow isEqualToDate:dateRepresentingThisDay]) {
        return [NSString stringWithFormat:@"%@, %@", @"Morgen", [sectionDateFormatter stringFromDate:dateRepresentingThisDay]];
    } else {
        [sectionDateFormatter setDateFormat:@"EEEE, dd.MM.yyyy"];
        return [sectionDateFormatter stringFromDate:dateRepresentingThisDay];
    }
}

- (ModulEvent *)eventOnThisDay:(NSIndexPath *)indexPath {
	NSDate *dateRepresentingThisDay = [_sortedDays objectAtIndex:indexPath.section];
    NSArray *eventsOnThisDay = [_daySections objectForKey:dateRepresentingThisDay];
    return [eventsOnThisDay objectAtIndex:indexPath.row];
}

@end

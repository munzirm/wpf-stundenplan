//
//  ModulEvents.m
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import "ModulEvents.h"

@implementation ModulEvents {
	NSArray *_originalEvents;
	NSMutableDictionary *_daySections;
	NSArray *_sortedDays;
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

	[self prepareEventsForDisplay];

	return self;
}

- (void)prepareEventsForDisplay {
	for (EKEvent *event in _originalEvents) {
		/*ModulEvent *modulEvent = [[ModulEvent alloc] initWithEvent:event];

		if (![modulEvent.modulAcronym isEqualToString:@"WBA2"] && ![modulEvent.modulAcronym isEqualToString:@"MCI"]) {
			 continue;
		}

		if ([modulEvent.modulType isEqualToString:@"P"]) {
			 continue;
		}*/

		// Reduce event start date to date components (year, month, day)
		NSDate *dateRepresentingThisDay = [self dateAtBeginningOfDayForDate:event.startDate];

		// If we don't yet have an array to hold the events for this day, create one
		NSMutableArray *eventsOnThisDay = [_daySections objectForKey:dateRepresentingThisDay];
		if (eventsOnThisDay == nil) {
			eventsOnThisDay = [NSMutableArray array];

			// Use the reduced date as dictionary key to later retrieve the event list this day
			[_daySections setObject:eventsOnThisDay forKey:dateRepresentingThisDay];
		}

		// Add the event to the list for this day
		[eventsOnThisDay addObject:[[ModulEvent alloc] initWithEvent:event]];
	}

	// Create a sorted list of days
	NSArray *unsortedDays = [_daySections allKeys];
	_sortedDays = [unsortedDays sortedArrayUsingSelector:@selector(compare:)];
	 
	/*// Workaround to remove the delay
	// http://stackoverflow.com/questions/8662777/delay-before-reloaddata
	dispatch_async(dispatch_get_main_queue(), ^(void) {
		[self.tableView reloadData];
	});*/
}

- (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate {
	// Use the user's current calendar and time zone
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
	[calendar setTimeZone:timeZone];

	// Selectively convert the date components (year, month, day) of the input date
	NSDateComponents *dateComps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:inputDate];

	// Set the time components manually
	[dateComps setHour:0];
	[dateComps setMinute:0];
	[dateComps setSecond:0];

	// Convert back
	return [calendar dateFromComponents:dateComps];
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
	[sectionDateFormatter setDateFormat:@"dd.MM.yyyy"];
	return [sectionDateFormatter stringFromDate:dateRepresentingThisDay];
}

- (ModulEvent *)eventOnThisDay:(NSIndexPath *)indexPath {
	NSDate *dateRepresentingThisDay = [_sortedDays objectAtIndex:indexPath.section];
    NSArray *eventsOnThisDay = [_daySections objectForKey:dateRepresentingThisDay];
    return [eventsOnThisDay objectAtIndex:indexPath.row];
}

@end

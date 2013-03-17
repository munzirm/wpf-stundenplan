//
//  TestViewController.m
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import "TimetableViewController.h"

#import "TimetableCell.h"

#import "ModulEvent.h"

#import <QuartzCore/QuartzCore.h>

@implementation TimetableViewController {
	NSArray *_events;
	NSMutableDictionary *_daySections;
	NSArray *_sortedDays;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSLog(@"navigationController: %@", self.navigationController);
	NSLog(@"navigationItem: %@", self.navigationItem);
	((UILabel*) self.navigationItem.titleView).textColor = [UIColor blackColor];

	// The days
	_daySections = [NSMutableDictionary dictionary];
	// The events per day
	_sortedDays = nil;

	self.calendarController = [[CalendarController alloc] init];

	[self.calendarController requestAccessToCalendar:^(BOOL granted, NSError *error) {
		if (granted) {
			[self didGetAccessToCalendar];
		} else {
			// no permissions to access calendars
			NSLog(@"Error: %@", error);
		}
	}];
}

/**
 Permissions to the calendar permitted
 */
- (void)didGetAccessToCalendar {
	EKCalendar* calendar = [self.calendarController calendar];
	NSLog(@"%@", calendar);

	// For demo proposes, display events for the next X days
	NSDate *startDate = [NSDate date];
	NSDate *endDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24*356];
	NSArray *calendars = [NSArray arrayWithObject:calendar];
	NSPredicate *predicate = [self.calendarController.store predicateForEventsWithStartDate:startDate endDate:endDate calendars:calendars];

	_events = [self.calendarController.store eventsMatchingPredicate:predicate];

	if ([_events count] == 0) {
		NSLog(@"Used: REMOTE");
		[self.calendarController fetchCalendarFromRemote:^(NSArray *events) {
			_events = events;
			[self prepareEventsForDisplay];
		}];
	} else {
		NSLog(@"Used: LOCAL");
		[self prepareEventsForDisplay];
	}

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

- (void)prepareEventsForDisplay {
	for (EKEvent *event in _events) {
		ModulEvent *modulEvent = [[ModulEvent alloc] initWithEventTitle:event.title];

		if (![modulEvent.modulName isEqualToString:@"WBA2"] && ![modulEvent.modulName isEqualToString:@"MCI"]) {
			continue;
		}

		if ([modulEvent.modulType isEqualToString:@"P"]) {
			continue;
		}

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
		[eventsOnThisDay addObject:event];
	}

	// Create a sorted list of days
	NSArray *unsortedDays = [_daySections allKeys];
	_sortedDays = [unsortedDays sortedArrayUsingSelector:@selector(compare:)];

	// Workaround to remove the delay
	// http://stackoverflow.com/questions/8662777/delay-before-reloaddata
	dispatch_async(dispatch_get_main_queue(), ^(void) {
		[self.tableView reloadData];
	});
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [_daySections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSDate *dateRepresentingThisDay = [_sortedDays objectAtIndex:section];
	NSArray *eventsOnThisDay = [_daySections objectForKey:dateRepresentingThisDay];
	return [eventsOnThisDay count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSDate *dateRepresentingThisDay = [_sortedDays objectAtIndex:section];
	NSDateFormatter *sectionDateFormatter = [[NSDateFormatter alloc] init];
	[sectionDateFormatter setDateFormat:@"dd.MM.yyyy"];
	return [sectionDateFormatter stringFromDate:dateRepresentingThisDay];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"TimetableCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

	NSDate *dateRepresentingThisDay = [_sortedDays objectAtIndex:indexPath.section];
    NSArray *eventsOnThisDay = [_daySections objectForKey:dateRepresentingThisDay];
    EKEvent *event = [eventsOnThisDay objectAtIndex:indexPath.row];
	
	((TimetableCell*) cell).eventName.text = event.title;

	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"HH:mm"];
	NSString *startTime = [dateFormatter stringFromDate:event.startDate];
	NSString *endTime = [dateFormatter stringFromDate:event.endDate];

	((TimetableCell*) cell).eventTime.text = [NSString stringWithFormat:@"%@ - %@", startTime, endTime];

	CGFloat redColor = ((arc4random()>>24)&0xFF)/256.0;
	CGFloat greenColor = ((arc4random()>>24)&0xFF)/256.0;
	CGFloat blueColor = ((arc4random()>>24)&0xFF)/256.0;
	((TimetableCell*) cell).eventColor.backgroundColor = [UIColor colorWithRed:redColor green:greenColor blue:blueColor alpha:1.0];
	((TimetableCell*) cell).eventColor.layer.cornerRadius = 5.0;

	return cell;
}

// Only to test that the sidebar does not handle the slide gesture in the center.
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//	return YES;
//}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//}

// Required for the swipe to delete interaction.
//- (BOOL)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
//}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
	 // ...
	 // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 */
}

@end

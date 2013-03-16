//
//  TestViewController.m
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import "IcalTestViewController.h"

#import "IcalCalenderClient.h"

#import <QuartzCore/QuartzCore.h>

@implementation IcalTestEventCell
@end

@implementation IcalTestViewController {
	NSArray *_events;
	NSMutableDictionary *_daySections;
	NSArray *_sortedDays;
	// The calendar store key
	NSString *calendarIdentifierKey;
}

- (void)viewDidLoad {
	[super viewDidLoad];

	// The event store
	_eventStore  = nil;
	// Our calendar
	_calendar    = nil;
	// The days
	_daySections = [NSMutableDictionary dictionary];
	// The events per day
	_sortedDays = nil;
	// The calendar store key
	calendarIdentifierKey = @"fh_koeln_stundenplan";

	[self requestAccessToCalendar:^(BOOL granted, NSError *error) {
		if (granted) {
			[self didGetAccessToCalendar];
		} else {
			// no permissions to access calendars
			NSLog(@"Error: %@", error);
		}
	}];

	// Uncomment the following line to preserve selection between presentations.
	// self.clearsSelectionOnViewWillAppear = NO;

	// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	// self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

/**
 Request permissions to the calendar
 */
- (void)requestAccessToCalendar:(void (^)(BOOL granted, NSError *error))callback; {
	if (_eventStore == nil) {
		_eventStore = [[EKEventStore alloc] init];
	}

	// request permissions
	if ([_eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
		// iOS 6 and later
		[_eventStore requestAccessToEntityType:EKEntityTypeEvent completion:callback];
	} else {
		// iOS 5
		callback(FALSE, NULL);
	}
}

/**
 Permissions to the calendar permitted
 */
- (void)didGetAccessToCalendar {
	/*
	 // DEBUG CLEAR CALENDAR
	 NSString *calendarIdentifier = [[NSUserDefaults standardUserDefaults] valueForKey:calendarIdentifierKey];
	 EKCalendar *calendar = [_eventStore calendarWithIdentifier:calendarIdentifier];
	 NSError *error = nil;
	 BOOL result = [_eventStore removeCalendar:calendar commit:YES error:&error];
	 if (result) {
	 NSLog(@"Deleted calendar from event store.");
	 } else {
	 NSLog(@"Deleting calendar failed: %@.", error);
	 }
	 // END DEBUG */

	[self getCalendar];

	// For demo proposes, display events for the next X dayes
	NSDate *startDate = [NSDate date];
	NSDate *endDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24*10];
	NSArray *calendars = [NSArray arrayWithObject:_calendar];
	NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:startDate endDate:endDate calendars:calendars];

	_events = [self.eventStore eventsMatchingPredicate:predicate];
	if (![_events count]) {
		[self fetchCalendarFromRemote];
		NSLog(@"Used: REMOTE");
	} else {
		NSLog(@"Used: LOCAL");
	}

	[self prepareEventsForDisplay];

	// Workaround to remove the delay
	// http://stackoverflow.com/questions/8662777/delay-before-reloaddata
	dispatch_async(dispatch_get_main_queue(), ^(void) {
		[self.tableView reloadData];
	});
}

- (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate
{
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
	NSDate *beginningOfDay = [calendar dateFromComponents:dateComps];
	return beginningOfDay;
}

- (void)prepareEventsForDisplay {
	for (EKEvent *event in _events) {
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
}

/**
 Get the calendar
 */
- (EKCalendar *)getCalendar {
	// Get our custom calendar identifier
	NSString *calendarIdentifier = [[NSUserDefaults standardUserDefaults] valueForKey:calendarIdentifierKey];

	// When identifier exists, calendar probably already exists
	if (calendarIdentifier) {
		_calendar = [_eventStore calendarWithIdentifier:calendarIdentifier];
	}

	// Calendar doesn't exist
	if (!_calendar) {
		// Create it
		_calendar = [EKCalendar calendarForEntityType:EKEntityTypeEvent eventStore:_eventStore];

		// Set user visible calendar name
		[_calendar setTitle:@"FH Köln Stundenplan"];

		// Find appropriate source type. Only local calendars
		for (EKSource *s in _eventStore.sources) {
			if (s.sourceType == EKSourceTypeLocal) {
				_calendar.source = s;
				break;
			}
		}

		// Save identifier to store it later
		NSString *calendarIdentifier = [_calendar calendarIdentifier];

		NSError *error = nil;
		BOOL saved = [_eventStore saveCalendar:_calendar commit:YES error:&error];
		if (saved) {
			// Saved successfuly, store identifier in NSUserDefaults
			[[NSUserDefaults standardUserDefaults] setObject:calendarIdentifier forKey:calendarIdentifier];
		} else {
			// Unable to save calendar
			NSLog(@"Calendar Saving: %@", error);
			return nil;
		}
	}

	return _calendar;
}

- (void)fetchCalendarFromRemote {
	IcalCalenderClient* icalCalenderClient = [[IcalCalenderClient alloc] init];

	[icalCalenderClient query:@"SG_KZ = 'MI' and SEMESTER_NR = '4'" withEventStore:_eventStore onSuccess:^(AFHTTPRequestOperation* operation, NSArray* events) {

		for (EKEvent* event in events) {
			event.calendar = _calendar;
			NSError *error = nil;
			BOOL result = [_eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&error];
			if (!result) {
				NSLog(@"Event Storing: %@", error);
			}
		}

		_events = events;

	} onFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"Request Operation: %@", error);
	}];
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
	static NSString *CellIdentifier = @"IcalTestEventCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

	NSDate *dateRepresentingThisDay = [_sortedDays objectAtIndex:indexPath.section];
	NSArray *eventsOnThisDay = [_daySections objectForKey:dateRepresentingThisDay];
	EKEvent *event = [eventsOnThisDay objectAtIndex:indexPath.row];

	((IcalTestEventCell*) cell).eventName.text = event.title;

	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"HH:mm"];
	NSString *startTime = [dateFormatter stringFromDate:event.startDate];
	NSString *endTime = [dateFormatter stringFromDate:event.endDate];

	((IcalTestEventCell*) cell).eventTime.text = [NSString stringWithFormat:@"%@ - %@", startTime, endTime];

	CGFloat redColor = ((arc4random()>>24)&0xFF)/256.0;
	CGFloat greenColor = ((arc4random()>>24)&0xFF)/256.0;
	CGFloat blueColor = ((arc4random()>>24)&0xFF)/256.0;
	((IcalTestEventCell*) cell).eventColor.backgroundColor = [UIColor colorWithRed:redColor green:greenColor blue:blueColor alpha:1.0];
	((IcalTestEventCell*) cell).eventColor.layer.cornerRadius = 5.0;

	return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	// only to test that the sidebar does not handle the slide gesture in the center.
	return YES;
}

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

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

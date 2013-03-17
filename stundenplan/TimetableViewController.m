//
//  TestViewController.m
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import "TimetableViewController.h"

#import "TimetableCell.h"

#import "ModulEvents.h"

#import <QuartzCore/QuartzCore.h>

@implementation TimetableViewController {
	NSArray *_events;
	ModulEvents *modulEvents;
	NSMutableDictionary *_daySections;
	NSArray *_sortedDays;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSLog(@"navigationController: %@", self.navigationController);
	NSLog(@"navigationItem: %@", self.navigationItem);
	((UILabel*) self.navigationItem.titleView).textColor = [UIColor blackColor];

	modulEvents = [ModulEvents alloc];

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

	// For demo proposes, display events for the next X days
	NSDate *startDate = [NSDate date];
	NSDate *endDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24*356];
	NSArray *calendars = [NSArray arrayWithObject:calendar];
	NSPredicate *predicate = [self.calendarController.store predicateForEventsWithStartDate:startDate endDate:endDate calendars:calendars];

	_events = [self.calendarController.store eventsMatchingPredicate:predicate];

	if ([_events count] == 0) {
		NSLog(@"Used: REMOTE");
		[self.calendarController fetchCalendarFromRemote:^(NSArray *events) {
			modulEvents = [modulEvents initWithEvents:events];
			[self prepareEventsForDisplay];
		}];
	} else {
		NSLog(@"Used: LOCAL");
		modulEvents = [modulEvents initWithEvents:_events];

		[self prepareEventsForDisplay];
	}

}

- (void)prepareEventsForDisplay {
	//NSLog( @"%@",_events);
	// Workaround to remove the delay
	// http://stackoverflow.com/questions/8662777/delay-before-reloaddata
	dispatch_async(dispatch_get_main_queue(), ^(void) {
		NSLog( @"Reloaded");
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
	return [modulEvents dayCount];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [modulEvents eventCountOnThisDay:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [modulEvents dateRepresentingThisDay:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"TimetableCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

	// Todo: Replace EKEvent with ModulEvent
	EKEvent *event = [modulEvents eventOnThisDay:indexPath];

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

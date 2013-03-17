//
//  TestViewController.m
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import "TimetableViewController.h"
#import "TimetableCell.h"
#import "ModulEvents.h"
#import "ModulEvent.h"
#import "ColorGenerator.h"

@implementation TimetableViewController {
	ModulEvents *modulEvents;
	NSMutableDictionary *_daySections;
	NSArray *_sortedDays;
	
	UIActionSheet* _actionSheet;
}

- (void)dealloc {
	_actionSheet.delegate = nil;
	_actionSheet = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSLog(@"navigationController: %@", self.navigationController);
	NSLog(@"navigationItem: %@", self.navigationItem);
	((UILabel*) self.navigationItem.titleView).textColor = [UIColor blackColor];

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
	NSDate *endDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24*10];
	NSArray *calendars = [NSArray arrayWithObject:calendar];
	__block NSPredicate *predicate = [self.calendarController.store predicateForEventsWithStartDate:startDate endDate:endDate calendars:calendars];

	__block NSArray* events = [self.calendarController.store eventsMatchingPredicate:predicate];

	if ([events count] == 0) {
		NSLog(@"Used: REMOTE");
		[self.calendarController fetchCalendarFromRemote:^(void) {

			events = [self.calendarController.store eventsMatchingPredicate:predicate];
			modulEvents = [[ModulEvents alloc] initWithEvents:events];
			[self prepareEventsForDisplay];
		}];
	} else {
		NSLog(@"Used: LOCAL");
		modulEvents = [[ModulEvents alloc] initWithEvents:events];

		[self prepareEventsForDisplay];
	}

}

- (void)prepareEventsForDisplay {
	// Workaround to remove the delay
	// http://stackoverflow.com/questions/8662777/delay-before-reloaddata
	dispatch_async(dispatch_get_main_queue(), ^(void) {
		[self.tableView reloadData];
	});
}

- (void)didReceiveMemoryWarning {
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
	
	TimetableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
	cell.delegate = self;
	cell.event = [modulEvents eventOnThisDay:indexPath];

	cell.eventName.text = cell.event.event.title;
	if ([cell.event.modulAcronym isEqualToString:@"WBA2"])
		[cell.eventName setFont:[UIFont fontWithName:@"GillSans" size:20.0]];
	
	if ([cell.event.modulAcronym isEqualToString:@"BS1"])
		[cell.eventName setFont:[UIFont fontWithName:@"OpenSans-Semibold" size:20.0]];

	cell.eventTime.text = [NSString stringWithFormat:@"%@ - %@", cell.event.startTime, cell.event.endTime];

	CGFloat redColor = ((arc4random()>>24)&0xFF)/256.0;
	CGFloat greenColor = ((arc4random()>>24)&0xFF)/256.0;
	CGFloat blueColor = ((arc4random()>>24)&0xFF)/256.0;
	cell.eventColor.backgroundColor = [UIColor colorWithRed:redColor green:greenColor blue:blueColor alpha:1.0];

	// Todo: Replace EKEvent with ModulEvent
	ModulEvent *event = [modulEvents eventOnThisDay:indexPath];
	
	((TimetableCell*) cell).eventName.text = event.modulAcronym;

	((TimetableCell*) cell).eventColor.backgroundColor = [ColorGenerator randomColor];

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

#pragma mark - TimetableCellDelegate implementation

- (void)favorite:(ModulEvent*) event {
	event.favorite = YES;
	NSLog(@"favorite: %@", event);
}

- (void)confirm:(ModulEvent*) event {
	NSLog(@"confirm: %@", event);
}

- (void)cancel:(ModulEvent*) event {
	NSLog(@"cancel: %@", event);
}

- (void)remove:(ModulEvent*) event {
	_actionSheet = [[UIActionSheet alloc] initWithTitle:@"Löschen?"
											   delegate:self
									  cancelButtonTitle:@"Abbrechen"
								 destructiveButtonTitle:@"Alle Folgetermine"
									  otherButtonTitles:@"Nur diesen Termin", nil];
	[_actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
}

@end

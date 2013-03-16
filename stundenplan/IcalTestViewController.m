//
//  TestViewController.m
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import "IcalTestViewController.h"

#import "IcalCalenderClient.h"

@implementation IcalTestViewController {
	NSArray* _events;
}

- (void)viewDidLoad {
    [super viewDidLoad];

	_eventStore = nil;
	_calendar = nil;

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
	[self getCalendar];

	// For demo proposes, display events for the next X dayes
	NSDate *startDate = [NSDate date];

	// 2 days
	NSDate *endDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24*10];

	NSArray *calendars = [NSArray arrayWithObject:_calendar];
	NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:startDate endDate:endDate calendars:calendars];

	_events = [self.eventStore eventsMatchingPredicate:predicate];
	//NSLog(@"Events: %@", _events);
	if (![_events count]) {
		[self fetchCalendarFromRemote];
		NSLog(@"Used: REMOTE");
	} else {
		// Workaround to remove the delay
		// http://stackoverflow.com/questions/8662777/delay-before-reloaddata
		dispatch_async(dispatch_get_main_queue(), ^(void) {
			[self.tableView reloadData];
		});
		NSLog(@"Used: LOCAL");
	}
}

/**
 Get the calendar
 */
- (EKCalendar *)getCalendar {
	// The calendar store key
	NSString *key = @"fh_koeln_stundenplan";
	
	// Get our custom calendar identifier
	NSString *calendarIdentifier = [[NSUserDefaults standardUserDefaults] valueForKey:key];

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
			[[NSUserDefaults standardUserDefaults] setObject:calendarIdentifier forKey:key];
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

	[icalCalenderClient query:nil withEventStore:_eventStore onSuccess:^(AFHTTPRequestOperation* operation, NSArray* events) {

		_events = events;

		for (EKEvent* event in events) {
			event.calendar = _calendar;
			NSError *error = nil;
			BOOL result = [_eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&error];
			if (!result) {
				NSLog(@"Event Storing: %@", error);
			}
		}
		
		[self.tableView reloadData];

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _events.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    // Configure the cell...

	EKEvent* event = [_events objectAtIndex:indexPath.row];
	cell.textLabel.text = event.title;

	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"dd.MM.yyyy"];
	cell.detailTextLabel.text = [dateFormatter stringFromDate:event.startDate];

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

//
//  TestViewController.m
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import "TimetableViewController.h"
#import "TimetableCell.h"
#import "MainViewController.h"
#import "ModulEventDetailViewController.h"
#import "ModulEvents.h"
#import "ModulEvent.h"
#import "ColorGenerator.h"
#import "CalendarController.h"

#import <QuartzCore/QuartzCore.h>

@implementation TimetableViewController {
	ModulEvents *modulEvents;
	NSMutableDictionary *_daySections;
	NSArray *_sortedDays;

	UIActionSheet* _actionSheet;
	ModulEvent *_eventToDelete;
}

- (void)dealloc {
	_actionSheet.delegate = nil;
	_actionSheet = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	/*
	 NSLog(@"navigationBar: %@", self.navigationController.navigationBar);
	 self.navigationController.navigationBar.topItem.titleView.backgroundColor = [UIColor greenColor];
	 self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
	 self.navigationController.navigationBar.backgroundColor = [UIColor grayColor];
	 */
    
    static UIImage *bgtextureImage = nil;
    if (bgtextureImage == nil) {
        bgtextureImage = [UIImage imageNamed:@"bgtexture.png"];
    }
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:bgtextureImage];

	[[CalendarController sharedInstance] moduleEventsWithSuccess:^(ModulEvents *moduleEvents) {
		modulEvents = moduleEvents;
		
		if (modulEvents.events.count == 0) {
			[((MainViewController*)self.navigationController.parentViewController) openSearchModuleViewController];
		}
		
		[self prepareEventsForDisplay];
	} failure:^(NSError *error) {
		NSLog(@"Error while load module events in timetable: %@", error);
	}];
}

- (void)prepareEventsForDisplay {
	// Workaround to remove the delay
	// http://stackoverflow.com/questions/8662777/delay-before-reloaddata
	dispatch_async(dispatch_get_main_queue(), ^(void) {
		[self.tableView reloadData];
	});
}

- (void)snapTheCell {
	NSInteger cellHeight = 64;
    NSInteger sectionHeight = 20;
	NSInteger offsetOverage = (NSInteger) self.tableView.contentOffset.y % cellHeight;
    // Get the fist visible cell
    NSIndexPath *visiblePaths = [[self.tableView indexPathsForVisibleRows] objectAtIndex:0];
    NSInteger sectionHeights = visiblePaths.section * sectionHeight;
    
	if (offsetOverage > 0) {
		NSInteger newOffset;
        
		if (offsetOverage >= (cellHeight/2)) {
            // Enough to show the cell
			newOffset = self.tableView.contentOffset.y + (cellHeight - offsetOverage) + sectionHeights;
		} else {
            // Hide the cell
			newOffset = self.tableView.contentOffset.y - offsetOverage + sectionHeights;
		}
        
        // Animate
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.1];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		[self.tableView setContentOffset:CGPointMake(0, newOffset) animated:NO];
		[UIView commitAnimations];
	}
}

/*- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	[self snapTheCell];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	if (decelerate == NO) {
		[self snapTheCell];
	}
}*/

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	// the parent view that will hold header label (x, y, widht, height)
	UIView* sectionView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 20.0)];
    static UIImage *timetablesectionheaderImage = nil;
    if (timetablesectionheaderImage == nil) {
        timetablesectionheaderImage = [UIImage imageNamed:@"timetablesectionheader.png"];
    }
    sectionView.backgroundColor = [UIColor colorWithPatternImage:timetablesectionheaderImage];
	
	// the label object
	UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, 320.0, 20.0)];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.textColor = UIColorFromRGB(0x424242);
	headerLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:11.0];
    headerLabel.shadowColor = [UIColor whiteColor];
    headerLabel.shadowOffset = CGSizeMake(1.0, 1.0);
    
	headerLabel.text = [modulEvents dateRepresentingThisDay:section];
	[sectionView addSubview:headerLabel];
    
	return sectionView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 20.0;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [modulEvents dayCount];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [modulEvents eventCountOnThisDay:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"TimetableCell";

	TimetableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
	cell.delegate = self;
	cell.event = [modulEvents eventOnThisDay:indexPath];

	// Name
	[cell.eventName setText:cell.event.modulAcronym];
	[cell.eventName setFont:[UIFont fontWithName:@"OpenSans-Semibold" size:17.0]];
    [cell.eventName setTextColor:UIColorFromRGB(0x424242)];
    [cell.eventName setShadowColor:[UIColor whiteColor]];
    [cell.eventName setShadowOffset:CGSizeMake(1.0, 1.0)];

	// Type
	[cell.eventType setText:[cell.event modulType]];
	[cell.eventType setFont:[UIFont fontWithName:@"OpenSans-Light" size:11.0]];
    [cell.eventType setTextColor:UIColorFromRGB(0x424242)];
    [cell.eventType setShadowColor:[UIColor whiteColor]];
    [cell.eventType setShadowOffset:CGSizeMake(1.0, 1.0)];

	// Location
	[cell.eventLocation setText:cell.event.modulLocation];
	[cell.eventLocation setFont:[UIFont fontWithName:@"OpenSans-Light" size:10.0]];
    [cell.eventLocation setTextColor:UIColorFromRGB(0x424242)];
    [cell.eventLocation setShadowColor:[UIColor whiteColor]];
    [cell.eventLocation setShadowOffset:CGSizeMake(1.0, 1.0)];

	// Time
	[cell.eventTime setText:cell.event.startTime];
	[cell.eventTime setFont:[UIFont fontWithName:@"OpenSans-Bold" size:11.0]];
    [cell.eventTime setTextColor:UIColorFromRGB(0x424242)];
    [cell.eventTime setShadowColor:[UIColor whiteColor]];
    [cell.eventTime setShadowOffset:CGSizeMake(1.0, 1.0)];

    // Duration
    NSDateFormatter *datefFormatter = [[NSDateFormatter alloc] init];
    [datefFormatter setDateFormat:@"HH:mm"];
    NSDate *begin = [datefFormatter dateFromString:cell.event.startTime];
    NSDate *end = [datefFormatter dateFromString:cell.event.endTime];
    NSTimeInterval interval = [end timeIntervalSinceDate:begin];
    int hours = (int)interval / 3600;
    int minutes = (interval - (hours*3600)) / 60;
    [cell.eventDuration setText:[NSString stringWithFormat:@"%dh %dm", hours, minutes]];
	[cell.eventDuration setFont:[UIFont fontWithName:@"OpenSans-Light" size:10.0]];
    [cell.eventDuration setTextColor:UIColorFromRGB(0x424242)];
    [cell.eventDuration setShadowColor:[UIColor whiteColor]];
    [cell.eventDuration setShadowOffset:CGSizeMake(1.0, 1.0)];
    
	// Color
	cell.eventColor.backgroundColor = cell.event.modulColor;
	cell.eventColor.layer.cornerRadius = 8.5;

    // Fav
	if (!cell.event.favorite) {
        cell.eventFav.hidden = YES;
	 } else {
         cell.eventFav.hidden = NO;
	 }

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


#pragma mark - TimetableCellDelegate implementation

- (void)favorite:(ModulEvent*) event {
	event.favorite = YES;
	NSLog(@"favorite: %@", event);
}

- (void)remove:(ModulEvent*) event {
	_eventToDelete = event;
	_actionSheet = [[UIActionSheet alloc] initWithTitle:@"Veranstaltung löschen?"
											   delegate:self
									  cancelButtonTitle:@"Abbrechen"
								 destructiveButtonTitle:@"Nur diesen Termin"
									  otherButtonTitles:@"Alle Folgetermine", nil];
	[_actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex==0) {
		[_eventToDelete deleteEvent:NO];
	} else if (buttonIndex==1) {
		//[_eventToDelete deleteEvent:YES];
	}
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showModulEventDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ModulEventDetailViewController *destViewController = segue.destinationViewController;
		destViewController.modulEvent = [modulEvents eventOnThisDay:indexPath];
    }
}


@end
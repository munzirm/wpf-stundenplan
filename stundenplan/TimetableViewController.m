//
//  TestViewController.m
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import "TimetableViewController.h"
#import "TimetableCell.h"
#import "ModulEventDetailViewController.h"
#import "ModulEvents.h"
#import "ModulEvent.h"
#import "ColorGenerator.h"

#import <QuartzCore/QuartzCore.h>

@implementation UIColor (LightAndDark)

- (UIColor *)lighterColor
{
    float h, s, b, a;
    if ([self getHue:&h saturation:&s brightness:&b alpha:&a])
        return [UIColor colorWithHue:h
                          saturation:s
                          brightness:MIN(b * 1.3, 1.0)
                               alpha:a];
    return nil;
}

- (UIColor *)darkerColor
{
    float h, s, b, a;
    if ([self getHue:&h saturation:&s brightness:&b alpha:&a])
        return [UIColor colorWithHue:h
                          saturation:s
                          brightness:b * 0.75
                               alpha:a];
    return nil;
}
@end

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
	
	/*
	NSLog(@"navigationBar: %@", self.navigationController.navigationBar);
	self.navigationController.navigationBar.topItem.titleView.backgroundColor = [UIColor greenColor];
	self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
	self.navigationController.navigationBar.backgroundColor = [UIColor grayColor];
	*/
	
	self.calendarController = [[CalendarController alloc] init];
	[self.calendarController moduleEventsWithSuccess:^(ModulEvents *moduleEvents) {
		modulEvents = moduleEvents;
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

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    static UIImage *bgImage = nil;
    if (bgImage == nil) {
        bgImage = [UIImage imageNamed:@"timetablecell.png"];
    }
	cell.backgroundView = [[UIView alloc] init];
   // cell.backgroundView = [[UIImageView alloc] initWithImage:bgImage];
	((UIView *)cell.backgroundView).backgroundColor = [UIColor colorWithPatternImage:bgImage];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"TimetableCell";
	
	TimetableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
	cell.delegate = self;
	cell.event = [modulEvents eventOnThisDay:indexPath];

	// Name
	[cell.eventName setText:cell.event.modulAcronym];
	[cell.eventName setFont:[UIFont fontWithName:@"OpenSans-Semibold" size:17.0]];

	// Type
	[cell.eventType setText:[cell.event modulType]];
	[cell.eventType setFont:[UIFont fontWithName:@"OpenSans-Light" size:11.0]];


	// Location
	[cell.eventLocation setText:cell.event.modulLocation];
	[cell.eventLocation setFont:[UIFont fontWithName:@"OpenSans-Light" size:10.0]];

	// Time
	[cell.eventTime setText:cell.event.startTime];
	[cell.eventTime setFont:[UIFont fontWithName:@"OpenSans-Bold" size:11.0]];


	// Color
	cell.eventColor.backgroundColor = cell.event.modulColor;
	cell.eventColor.layer.cornerRadius = 8.5;
	// ToDo: Klappt nicht :(
    static UIImage *overlayImage = nil;
    if (overlayImage == nil) {
        overlayImage = [UIImage imageNamed:@"modulcoloroverlay.png"];
    }
	cell.eventColorOverlay = [[UIImageView alloc] initWithImage:overlayImage];
	cell.eventColorOverlay.backgroundColor = [UIColor clearColor];


	/*if (!cell.event.favorite) {
		cell.eventColor.layer.cornerRadius = 8.0;
		cell.eventColor.backgroundColor = cell.event.modulColor;
		cell.contentView.backgroundColor = indexPath.row % 2 == 0 ? [UIColor lightGrayColor] : nil;
	} else {
		cell.contentView.backgroundColor = cell.event.modulColor;
	}*/

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showModulEventDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ModulEventDetailViewController *destViewController = segue.destinationViewController;
		destViewController.modulEvent = [modulEvents eventOnThisDay:indexPath];
    }
}


@end

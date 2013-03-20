//
//  ModulEventDetailViewController.m
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import "MainViewController.h"
#import "ModulEventDetailViewController.h"
#import "CalendarController.h"

@implementation ModulEventDetailViewController {
	NSArray* _sections;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		_sections = @[ @"", @"Übersicht", @"" ];
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = _modulEvent.modulAcronym;
	
    static UIImage *bgtextureImage = nil;
    if (bgtextureImage == nil) {
        bgtextureImage = [UIImage imageNamed:@"bgtexture.png"];
    }
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:bgtextureImage];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sections.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [_sections objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return 1;
	} else if (section == 1) {
		return 3;
	} else if (section == 2) {
		return 1;
	} else {
		return -1;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"Cell";
	if (indexPath.section == 1) {
		CellIdentifier = @"CellDetail";
	}
	if (indexPath.section == 2) {
		CellIdentifier = @"CellDelete";
	}
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
	
	// TODO [_type setText:];
	

    // Configure the cell...
	if (indexPath.section == 0) {
		cell.textLabel.text =_modulEvent.modulFullName;
	} else if (indexPath.section == 1) {
		if (indexPath.row == 0) {
			cell.textLabel.text = @"Typ";
			cell.detailTextLabel.text = _modulEvent.modulType;
		} else if (indexPath.row == 1) {
			cell.textLabel.text = @"Datum";
			cell.detailTextLabel.text = [NSString stringWithFormat:@"%@: %@ - %@", _modulEvent.weekday, _modulEvent.startTime, _modulEvent.endTime];
		} else if (indexPath.row == 2) {
			cell.textLabel.text = @"Raum";
			cell.detailTextLabel.text = _modulEvent.modulLocation;
		}
	} else if (indexPath.section == 2) {
		cell.textLabel.text = @"Veranstaltung löschen";
	}
	
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// Delete cell
	if (indexPath.section == 2) {
		[[CalendarController sharedInstance] removeEvent:_modulEvent success:^(void) {
			[((MainViewController*) self.navigationController.parentViewController) updateData];
			[((MainViewController*) self.navigationController.parentViewController) openTimetableViewController];
		} failure:^(NSError *error) {
			NSLog(@"No event deleted: %@", error);
		}];
	}

}

@end

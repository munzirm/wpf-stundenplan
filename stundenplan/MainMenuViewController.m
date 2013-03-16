//
//  MainMenuViewController.m
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import "MainMenuViewController.h"

#import <QuartzCore/QuartzCore.h>

@implementation MainMenuModuleCell
@end

@implementation MainMenuFilterCell
@end

@implementation MainMenuMoreCell
@end

@implementation MainMenuViewController {
	NSArray* _sections;
	NSArray* _sectionCellIdentifiers;
	
	NSArray* _modules; // TODO replace this
	NSArray* _moduleColors; // TODO replace this
	NSArray* _filters;
	NSMutableArray* _filterFlags;
	NSArray* _more;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		_sections = @[ @"Module", @"Filter", @" " ];
		_sectionCellIdentifiers = @[ @"MainMenuModuleCell", @"MainMenuFilterCell", @"MainMenuMoreCell" ];
		
		_modules = @[ @"WBA2", @"WPF-CITY", @"MCI", @"BWL2", @"MC1", @"BS1"];
		_moduleColors = @[
			[UIColor redColor],
			[UIColor blueColor],
			[UIColor greenColor],
			[UIColor yellowColor],
			[UIColor magentaColor],
			[UIColor orangeColor],
		];
		
		_filters = @[ @"Vorlesungen", @"Seminare", @"Praktikas", @"Übungen", @"Tutorien" ];
		_filterFlags = [@[ @YES, @NO, @NO, @NO, @NO ] mutableCopy];
		
		_more = @[ @"Einstellungen" ];
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return _sections.count;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [_sections objectAtIndex:section];
}

// TODO vlt besser den header ganz selbst machen wg. layout
//- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section:(NSInteger)section {
//}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return _modules.count;
	} else if (section == 1) {
		return _filters.count;
	} else if (section == 2) {
		return _more.count;
	} else {
		return -1; // it's ok to produce an error if we found an illegal number of sections.
	}
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString* CellIdentifier = [_sectionCellIdentifiers objectAtIndex:indexPath.section];
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
	
	if (indexPath.section == 0) {
		((MainMenuModuleCell*) cell).moduleLabel.text =
				[_modules objectAtIndex:indexPath.row];
		((MainMenuModuleCell*) cell).moduleColorIndicator.backgroundColor =
				[_moduleColors objectAtIndex:indexPath.row];
		((MainMenuModuleCell*) cell).moduleColorIndicator.layer.cornerRadius = 5.0;
		
	} else if (indexPath.section == 1) {
		((MainMenuFilterCell*) cell).filterLabel.text =
				[_filters objectAtIndex:indexPath.row];
		((MainMenuFilterCell*) cell).filterSelectionIndicator.backgroundColor =
				[[_filterFlags objectAtIndex:indexPath.row] boolValue] ?
				[UIColor blackColor] :
				[UIColor whiteColor];
		
	} else if (indexPath.section == 2) {
		((MainMenuMoreCell*) cell).moreLabel.text = [_more objectAtIndex:indexPath.row];
		
	}
	
	return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end

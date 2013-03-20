//
//  MainMenuViewController.m
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import "MainMenuViewController.h"

#import <QuartzCore/QuartzCore.h>

@implementation MainMenuSectionHeader
@end

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

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	CGRect frame = self.tableView.frame;
	frame.size.width = 320 - 100;
	self.tableView.frame = frame;
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 32;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	static NSString* CellIdentifier = @"MainMenuSectionHeader";
	MainMenuSectionHeader* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	cell.sectionLabel.text = [_sections objectAtIndex:section];
	cell.sectionConfigurationButton.hidden = section != 0;
	
	return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath
                                                                                                      *)indexPath {
    static UIImage *menucellImage = nil;
    if (menucellImage == nil) {
        menucellImage = [UIImage imageNamed:@"menucell.png"];
    }
    cell.backgroundView = [[UIView alloc] init];
    cell.backgroundView.backgroundColor = [UIColor colorWithPatternImage:menucellImage];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return _modules.count + 1;
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
		if (indexPath.row == 0) {
			((MainMenuModuleCell*) cell).moduleLabel.text = @"Alle";
			((MainMenuModuleCell*) cell).moduleColorIndicator.backgroundColor = nil;
			((MainMenuModuleCell*) cell).backgroundColor = [UIColor blueColor];
		} else {
			((MainMenuModuleCell*) cell).moduleLabel.text = [_modules objectAtIndex:indexPath.row - 1];
			((MainMenuModuleCell*) cell).moduleColorIndicator.backgroundColor = [_moduleColors objectAtIndex:indexPath.row - 1];
			((MainMenuModuleCell*) cell).backgroundColor = nil;
		}
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
	if (indexPath.section == 0) {
		if (indexPath.row == 0) {
			[self filterModules:nil];
		} else {
			[self filterModules:[_modules objectAtIndex:indexPath.row - 1]];
		}
	} else if (indexPath.section == 1) {
		[self setFilterFlag:[_filters objectAtIndex:indexPath.row] to:YES];
	} else if (indexPath.section == 2) {
		// Todo show settings
	}
}

- (IBAction)configureModule:(UIButton*)sender {
	// cell -> contentView -> button
	MainMenuModuleCell* cell = (MainMenuModuleCell*) sender.superview.superview;
	[self.viewDeckController openConfigureModuleViewController:cell.textLabel.text];
	[self.viewDeckController closeLeftViewAnimated:YES];
}

- (IBAction)addModules:(UIButton*)sender {
	NSLog(@"addModules: %@", sender);
	[self.viewDeckController openSearchModuleViewController];
	[self.viewDeckController closeLeftViewAnimated:YES];
}

- (void)filterModules:(NSString*) filter {
	NSLog(@"filterModules: %@", filter);
	[self.viewDeckController openTimetableViewController];
	[self.viewDeckController closeLeftViewAnimated:YES];
}

- (void)setFilterFlag:(NSString*) filter to:(BOOL) flag {
	NSLog(@"setFilterFlag: %@", filter);
	[self.viewDeckController closeLeftViewAnimated:YES];
}

@end

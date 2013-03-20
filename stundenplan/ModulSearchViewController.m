//
//  ModulSearchViewController.m
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import "ModulSearchViewController.h"

#import "MainViewController.h"
#import "CalendarController.h"
#import "Data.h"

#import <ActionSheetPicker/ActionSheetPicker.h>
#import <SVProgressHUD/SVProgressHUD.h>

@implementation ModulSearchViewController {
	CalendarController* _calendarController;
	UIBarButtonItem* _saveButton;
	NSString* _course;
	NSString* _semester;
	UIPickerView* _coursePicker;
	UIPickerView* _semesterPicker;
	NSArray* _modules;
}

- (void)viewWillAppear:(BOOL)animated {
	_saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Speichern"
												   style:UIBarButtonItemStylePlain
												  target:self
												  action:@selector(saveData)];
	_saveButton.enabled = NO;
	self.navigationItem.rightBarButtonItem = _saveButton;
	
	[self updateData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return 2;
	} else {
		return _modules.count;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellIdentifier = indexPath.section == 0 ? @"SearchCell" : @"ModuleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (indexPath.section == 0) {
		if (indexPath.row == 0) {
			cell.textLabel.text = @"Studiengang";
			cell.detailTextLabel.text = _course;
		} else if (indexPath.row == 1) {
			cell.textLabel.text = @"Semester";
			cell.detailTextLabel.text = _semester;
		}
	} else if (indexPath.section == 1) {
		cell.textLabel.text = [_modules objectAtIndex:indexPath.row];
	}
	
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
		if (indexPath.row == 0) {
			[self selectCourse];
		} else if (indexPath.row == 1) {
			[self selectSemester];
		}
	} else if (indexPath.section == 1) {
		BOOL selectedItems = [self.tableView indexPathsForSelectedRows].count != 0;
		_saveButton.enabled = selectedItems;
	}
}

- (void) selectCourse {
	// TODO use Data class here.
	NSArray* rows = @[ @"AI", @"MI", @"TI" ];
	
	[ActionSheetStringPicker showPickerWithTitle:@"Studiengang" rows:rows initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
		_course = selectedValue;
		[self.tableView reloadData];
		[self updateData];
	} cancelBlock:^(ActionSheetStringPicker *picker) {
	} origin:self.tableView];
}

- (void) selectSemester {
	// TODO use Data class here.
	NSArray* rows = @[
			@"1. Semester",
   			@"2. Semester",
   			@"3. Semester",
			@"4. Semester",
   			@"5. Semester",
   			@"6. Semester"
	];
	
	[ActionSheetStringPicker showPickerWithTitle:@"Semester" rows:rows initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
		_semester = selectedValue;
		[self.tableView reloadData];
		[self updateData];
	} cancelBlock:^(ActionSheetStringPicker *picker) {
	} origin:self.tableView];
}

- (void) updateData {
	if (!_course && !_semester) {
		return;
	}
	
	NSString* course = _course ? [_course substringToIndex:2] : nil;
	NSString* semester = _semester ? [_semester substringToIndex:1] : nil;
	
	[SVProgressHUD showWithStatus:@"Suche..."];
	
	_calendarController = [[CalendarController alloc] init];
	[_calendarController searchCourse:course andSemester:semester success:^(NSArray *modules) {
		_modules = modules;
		[SVProgressHUD showSuccessWithStatus:nil];
		[self.tableView reloadData];
	} failure:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:nil];
		NSLog(@"Error while update data: %@", error);
	}];
	
}

- (void) saveData {
	NSMutableArray* selectedModules = [NSMutableArray array];
	for (NSIndexPath* selectedIndexPath in [self.tableView indexPathsForSelectedRows]) {
		[selectedModules addObject:[_modules objectAtIndex:selectedIndexPath.row]];
	}
	
	[_calendarController addModules:selectedModules success:^{
		[SVProgressHUD showSuccessWithStatus:nil];
		[((MainViewController*) self.navigationController.parentViewController) openTimetableViewController];
	} failure:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:nil];
		NSLog(@"Error while update data: %@", error);
	}];
}

@end

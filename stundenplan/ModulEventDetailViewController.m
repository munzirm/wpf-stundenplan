//
//  ModulEventDetailViewController.m
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import "ModulEventDetailViewController.h"

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
	
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    static UIImage *bgtextureImage = nil;
    if (bgtextureImage == nil) {
        bgtextureImage = [UIImage imageNamed:@"bgtexture.png"];
    }
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:bgtextureImage];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
		cell.textLabel.text = @"Name";
		cell.detailTextLabel.text = _modulEvent.modulFullName;
	} else if (indexPath.section == 1) {
		if (indexPath.row == 0) {
			cell.textLabel.text = @"Typ";
			cell.detailTextLabel.text = _modulEvent.modulType;
		} else if (indexPath.row == 1) {
			cell.textLabel.text = @"Datum";
			cell.detailTextLabel.text = [NSString stringWithFormat:@"%@: %@ - %@", _modulEvent.weekday, _modulEvent.startTime, _modulEvent.endTime];
		} else if (indexPath.row == 2) {
		}
	} else if (indexPath.section == 2) {
		cell.textLabel.text = @"Löschen";
	}
	
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
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

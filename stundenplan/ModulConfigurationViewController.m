//
//  ModulConfigurationViewController.m
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import "ModulConfigurationViewController.h"

@implementation ModulConfigurationViewController {
	NSArray* _filter;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		_filter = @[ @"Vorlesung", @"Seminar", @"Praktikum", @"Übung" ];
	}
	
	return self;
}

- (void)viewWillAppear:(BOOL)animated {    
    static UIImage *bgtextureImage = nil;
    if (bgtextureImage == nil) {
        bgtextureImage = [UIImage imageNamed:@"bgtexture.png"];
    }
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:bgtextureImage];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return _filter.count;
	} else if (section == 1) {
		return 1;
	} else {
		return -1;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = indexPath.section == 0 ? @"OptionCell" : @"DeleteCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
	if (indexPath.section == 0) {
		cell.textLabel.text = [_filter objectAtIndex:indexPath.row];
		cell.textLabel.backgroundColor = [UIColor clearColor];
	} else if (indexPath.section == 1) {
		cell.textLabel.textColor = [UIColor whiteColor];
		cell.textLabel.backgroundColor = [UIColor clearColor];
	}
	
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

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

//
//  TestViewController.h
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import "TimetableCell.h"

@interface TimetableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UIActionSheetDelegate, TimetableCellDelegate>

@property (weak, nonatomic) IBOutlet UIView* timeView;
@property (weak, nonatomic) IBOutlet UITableView* tableView;

@end

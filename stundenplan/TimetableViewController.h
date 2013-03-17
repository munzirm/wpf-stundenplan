//
//  TestViewController.h
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import "CalendarController.h"
#import "TimetableCell.h"

@interface TimetableViewController : UITableViewController <UIGestureRecognizerDelegate, UIActionSheetDelegate, TimetableCellDelegate>

@property (strong) CalendarController* calendarController;

@end

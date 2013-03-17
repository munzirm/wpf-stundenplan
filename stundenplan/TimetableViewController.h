//
//  TestViewController.h
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import "CalendarController.h"

@interface TimetableViewController : UITableViewController <UIGestureRecognizerDelegate>

@property (strong) CalendarController* calendarController;

@end

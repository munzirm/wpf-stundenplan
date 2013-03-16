//
//  TestViewController.h
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

@interface IcalTestViewController : UITableViewController

@property (strong) EKEventStore* eventStore;
@property (strong) EKCalendar* calendar;

@end

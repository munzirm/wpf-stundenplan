//
//  TestViewController.h
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

@interface IcalTestEventCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *eventTime;
@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UIView *eventColor;

@end

@interface IcalTestViewController : UITableViewController <UIGestureRecognizerDelegate>

@property (strong) EKEventStore* eventStore;
@property (strong) EKCalendar* calendar;

@end

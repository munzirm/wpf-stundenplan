//
//  TimetableCell.h
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimetableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *eventTime;
@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UIView *eventColor;

@end

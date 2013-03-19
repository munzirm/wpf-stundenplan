//
//  TimetableCell.h
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import "ModulEvent.h"

@protocol TimetableCellDelegate <NSObject>

- (void)favorite:(ModulEvent*) event;
- (void)remove:(ModulEvent*) event;

@end

@interface TimetableCell : UITableViewCell <UIGestureRecognizerDelegate>

@property (weak, nonatomic) id<TimetableCellDelegate> delegate;

@property (weak, nonatomic) ModulEvent* event;

@property (weak, nonatomic) IBOutlet UILabel *eventDuration;
@property (weak, nonatomic) IBOutlet UILabel *eventTime;
@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UIView *eventColor;
@property (strong, nonatomic) IBOutlet UIView *eventColorOverlay;

@property (weak, nonatomic) IBOutlet UILabel *eventType;
@property (weak, nonatomic) IBOutlet UILabel *eventLocation;

- (void) animateToOrigin;

@end

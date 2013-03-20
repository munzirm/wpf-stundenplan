//
//  ModulEvent.h
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import <EventKit/EventKit.h>

@interface ModulEvent : NSObject

@property (nonatomic) BOOL favorite;

@property (nonatomic, copy, readonly) EKEvent *event;

@property (nonatomic, copy, readonly) NSString *modulAcronym;
@property (nonatomic, copy, readonly) NSString *modulFullName;

@property (nonatomic, copy, readonly) UIColor *modulColor;
@property (nonatomic, copy, readonly) NSString *modulLocation;

@property (nonatomic, copy, readonly) NSDate *startDate;
@property (nonatomic, copy, readonly) NSDate *endDate;
@property (nonatomic, copy, readonly) NSString *weekday;

@property (nonatomic, copy, readonly) NSString *startTime;
@property (nonatomic, copy, readonly) NSString *endTime;

- (NSString *)modulType;

- (id)initWithEvent:(EKEvent *)event;

- (void)setModulColor:(UIColor *)color;
- (void) deleteEvent: (BOOL) what;

@end

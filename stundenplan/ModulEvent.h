//
//  ModulEvent.h
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import <EventKit/EventKit.h>

@interface ModulEvent : NSObject

@property (nonatomic, copy, readonly) EKEvent *event;

@property (nonatomic) BOOL favorite;

@property (nonatomic, copy, readonly) NSString *modulAcronym;
@property (nonatomic, copy, readonly) NSString *modulFullName;
@property (nonatomic, copy, readonly) NSString *modulType;
@property (nonatomic, copy, readonly) NSDate *startDate;
@property (nonatomic, copy, readonly) NSDate *endDate;
@property (nonatomic, copy, readonly) NSString *startTime;
@property (nonatomic, copy, readonly) NSString *endTime;


- (id)initWithEvent:(EKEvent *)event;

- (void) setStatus: (EKEventStatus) status;
- (void) deleteEvent: (BOOL) todo;

@end

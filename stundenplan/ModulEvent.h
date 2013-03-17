//
//  ModulEvent.h
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface ModulEvent : NSObject

@property (nonatomic, copy, readonly) NSString *modulAcronym;
@property (nonatomic, copy, readonly) NSString *modulFullName;
@property (nonatomic, copy, readonly) NSString *modulType;
@property (nonatomic, copy, readonly) NSDate *startDate;
@property (nonatomic, copy, readonly) NSDate *endDate;
@property (nonatomic, copy, readonly) NSString *startTime;
@property (nonatomic, copy, readonly) NSString *endTime;


- (id)initWithEvent:(EKEvent *)event;

- (void) setFavorite: (BOOL) favorite;
- (void) setStatus: (EKEventStatus) status;
- (void) deleteEvent: (BOOL) favorite;

@end

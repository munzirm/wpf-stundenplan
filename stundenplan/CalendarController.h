//
//  CalendarController.h
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface CalendarController : NSObject
@property (strong) EKEventStore* store;


- (void)requestAccessToCalendar:(void (^)(BOOL granted, NSError *error))callback;

- (EKCalendar *)calendar;

- (void)fetchCalendarFromRemote:(void (^)(NSArray *events))success;

@end

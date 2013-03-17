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
@property (strong) EKCalendar* calendar;


- (void)requestAccessToCalendar:(void (^)(BOOL granted, NSError *error))callback;

- (EKCalendar *)getTheCalendar;

- (void)fetchCalendarFromRemote:(void (^)(NSArray *events))success;

@end

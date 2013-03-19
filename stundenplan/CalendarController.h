//
//  CalendarController.h
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import "ModulEvents.h"

@interface CalendarController : NSObject

- (void) moduleEventsWithSuccess: (void (^)(ModulEvents* moduleEvents))success
						 failure: (void (^)(NSError* error))failure;

- (void) modulesWithSuccess: (void (^)(NSArray* modules))success
					failure: (void (^)(NSError* error))failure;

- (void) eventsWithsuccess: (void (^)(NSArray* events))success
				   failure: (void (^)(NSError* error))failure;

@end

//
//  CalendarController.h
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import "ModulEvents.h"

@interface CalendarController : NSObject

/**
 Return the ModulEvents object.
 */
- (void) moduleEventsWithSuccess: (void (^)(ModulEvents* moduleEvents))success
						 failure: (void (^)(NSError* error))failure;

/**
 Return the modules as dictionary.
 */
- (void) modulesWithSuccess: (void (^)(NSDictionary* modules))success
					failure: (void (^)(NSError* error))failure;

/**
 Return an ModulEvent array.
 */
- (void) eventsWithSuccess: (void (^)(NSArray* events))success
				   failure: (void (^)(NSError* error))failure;

/**
 Testing only! :D
 */
- (void) addAllEventsWithSuccess: (void (^)())success
						 failure: (void (^)(NSError* error))failure;

- (void) storeEvents: (NSArray*) events
			 success: (void (^)())success
			 failure: (void (^)(NSError* error))failure;

@end

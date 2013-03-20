//
//  CalendarController.h
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import "ModulEvents.h"

@interface CalendarController : NSObject

+ (id)sharedInstance;

/**
 Return the ModulEvents object.
 */
- (void) moduleEventsWithSuccess: (void (^)(ModulEvents* moduleEvents))success
						 failure: (void (^)(NSError* error))failure;

/**
 Return the modules as dictionary.
 */
- (void) modulesWithSuccess: (void (^)(NSArray* modules, NSArray* moduleColors))success
					failure: (void (^)(NSError* error))failure;

/**
 Return an ModulEvent array.
 */
- (void) eventsWithSuccess: (void (^)(NSArray* events))success
				   failure: (void (^)(NSError* error))failure;

/**
 Search the modules for the given courses and events.
 */
- (void) searchCourse: (NSString*) course
		  andSemester: (NSString*) semester
			  success: (void (^)(NSArray* modules))success
			  failure: (void (^)(NSError* error))failure;

/**
 Search async the events for this modules and store them automatically.
 */
- (void) addModules: (NSArray*) modules
			success: (void (^)())success
			failure: (void (^)(NSError* error))failure;

- (void) storeEvents: (NSArray*) events
			 success: (void (^)())success
			 failure: (void (^)(NSError* error))failure;

- (void) reset;

@end

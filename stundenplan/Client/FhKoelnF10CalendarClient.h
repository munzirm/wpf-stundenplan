//
//  IcalCalenderClient.h
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <EventKit/EventKit.h>

#import <AFNetworking/AFHTTPClient.h>

/**
 Class which handles the connection to the ical service the FH Köln.
 */
@interface FhKoelnF10CalendarClient : AFHTTPClient

@property (strong, nonatomic) NSString* course;
@property (strong, nonatomic) NSString* semester;
@property (strong, nonatomic) NSString* modul;

- (id)init;
- (id)initWithBaseURL:(NSURL*) url;

- (void) fetchEventsForStore:(EKEventStore *)store
					 success:(void (^)(AFHTTPRequestOperation* operation, NSArray* events))success
					 failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure;

- (void) fetchModulesForStore:(EKEventStore *)store
					  success:(void (^)(AFHTTPRequestOperation* operation, NSArray* modules))success
					  failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure;

@end

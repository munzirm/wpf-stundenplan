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

- (id)init;
- (id)initWithBaseURL:(NSURL*) url;

- (void) query:(NSString *)query
			withEventStore:(EKEventStore *)store
			onSuccess:(void (^)(AFHTTPRequestOperation* operation, NSArray* events))success
			onFailure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure;

@end

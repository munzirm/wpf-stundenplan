//
//  IcalCalenderClient.h
//  stundenplan
//
//  Created by Christoph Jerolimov on 25.01.2013.
//  Copyright (c) 2013 FH-Köln. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AFCalenderClient/AFCalender.h>

/**
 Class which handles the connection to the ical service the FH Köln.
 */
@interface IcalCalenderClient : AFCalenderClient

- (id)init;
- (id)initWithBaseURL:(NSURL *)url;

- (void) allWithSuccess:(void (^)(AFHTTPRequestOperation *operation, AFCalender* calender))success
				failure:(void (^)(AFHTTPRequestOperation *operation, NSError* error))failure;

- (void) sqlQuery:(NSString*) query
	  withSuccess:(void (^)(AFHTTPRequestOperation *operation, AFCalender* calender))success
		  failure:(void (^)(AFHTTPRequestOperation *operation, NSError* error))failure;

@end

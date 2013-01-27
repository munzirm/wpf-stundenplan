//
//  JsonCalenderClient.h
//  stundenplan
//
//  Created by Christoph Jerolimov on 25.01.2013.
//  Copyright (c) 2013 FH-Köln. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AFNetworking/AFHTTPClient.h>

/**
 Class which handles the connection to the json calender service of
 <a href="http://nils-becker.com/">Nils Becker</a>
 
 Extends AFClient to reuse connection.
 */
@interface JsonCalenderClient : AFHTTPClient

- (id)init;
- (id)initWithBaseURL:(NSURL *)url;

- (void) branchesWithSuccess:(void (^)(AFHTTPRequestOperation *operation, NSArray* branches))success
					 failure:(void (^)(AFHTTPRequestOperation *operation, NSError* error))failure;
- (void) lecturersWithSuccess:(void (^)(AFHTTPRequestOperation *operation, NSArray* lecturers))success
					  failure:(void (^)(AFHTTPRequestOperation *operation, NSError* error))failure;

@end

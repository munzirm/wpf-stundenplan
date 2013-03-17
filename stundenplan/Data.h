//
//  Data.h
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Data : NSObject

+(NSDictionary *)objectForKey:(NSString *)key;
+(NSDictionary *)objectForKey:(NSString *)key andForKey:(NSString *)key2;

@end

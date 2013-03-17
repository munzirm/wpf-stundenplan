//
//  Data.m
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import "Data.h"

@implementation Data

static NSDictionary *dataDictionary = nil;

+(void)loadData {
	NSData* data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"]];

	NSError* error = nil;
	dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
	if (error) {
		NSLog(@"Error: %@", error);
	}

	NSLog(@"%@",dataDictionary);
}

+(NSDictionary *)objectForKey:(NSString *)key {
	if (dataDictionary == nil)
		[Data loadData];

	return [dataDictionary objectForKey:key];
}

+(NSDictionary *)objectForKey:(NSString *)key andForKey:(NSString *)key2 {
	if (dataDictionary == nil)
		[Data loadData];

	return [[dataDictionary objectForKey:key] objectForKey:key2];
}
@end

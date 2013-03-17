//
//  ModulEvent.m
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import "ModulEvent.h"

@implementation ModulEvent

- (id)initWithEvent:(EKEvent *)event {
	self = [super init];

	if (self == nil)
		return nil;


	NSArray *modulComponents = [event.title componentsSeparatedByString:@" "];
	_modulAcronym = [modulComponents objectAtIndex:0];
	// V, P, S
	_modulType = [modulComponents objectAtIndex:1];

	//_modulFullName = ...

	return self;
}


@end

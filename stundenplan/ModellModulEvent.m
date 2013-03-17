//
//  ModulEvent.m
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import "ModellModulEvent.h"

@implementation ModellModulEvent

- (id)initWithEventTitle:(NSString *)title {
	self = [super init];

	if (self == nil)
		return nil;

	_title = title;

	NSArray *modulComponents = [_title componentsSeparatedByString:@" "];
	// WBA1, BS1, BWL1
	_modulName = [modulComponents objectAtIndex:0];
	// V, P, S
	_modulType = [modulComponents objectAtIndex:1];

	return self;
}


@end

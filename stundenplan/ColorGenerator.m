//
//  ColorGenerator.m
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import "ColorGenerator.h"

@implementation ColorGenerator

+ (UIColor *)randomColor {
	CGFloat redColor = ((arc4random()>>24)&0xFF)/256.0;
	CGFloat greenColor = ((arc4random()>>24)&0xFF)/256.0;
	CGFloat blueColor = ((arc4random()>>24)&0xFF)/256.0;
	return [UIColor colorWithRed:redColor green:greenColor blue:blueColor alpha:1.0];
}

@end

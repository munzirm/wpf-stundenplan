//
//  ModulEvent.h
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface ModulEvent : NSObject

@property (nonatomic, copy, readonly) NSString *modulAcronym;
@property (nonatomic, copy, readonly) NSString *modulFullName;
@property (nonatomic, copy, readonly) NSString *modulType;


- (id)initWithEvent:(EKEvent *)event;
@end

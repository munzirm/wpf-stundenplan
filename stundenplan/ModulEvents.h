//
//  ModulEvents.h
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface ModulEvents : NSObject

- (id)initWithEvents:(NSArray *)events;

- (NSArray *)events;

- (NSInteger *)dayCount;

- (NSInteger *)eventCountOnThisDay:(NSInteger)section;
- (NSString *)dateRepresentingThisDay:(NSInteger)section;

- (EKEvent *)eventOnThisDay:(NSIndexPath *)indexPath;
@end

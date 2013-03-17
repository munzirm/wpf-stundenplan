//
//  ModulEvent.h
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModulEvent : NSObject

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy) NSString *modulName;
@property (nonatomic, copy) NSString *modulType;


- (id)initWithEventTitle:(NSString *)title;
@end

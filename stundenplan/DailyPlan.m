//
//  DailyPlan.m
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import "DailyPlan.h"

@implementation DailyPlan

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        static UIImage *bgtextureImage = nil;
        if (bgtextureImage == nil) {
            bgtextureImage = [UIImage imageNamed:@"bgtexture.png"];
        }
        self.backgroundColor = [UIColor colorWithPatternImage:bgtextureImage];
    }
    return self;
}


@end

//
//  TimetableOptionCell.m
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import "TimetableOptionCell.h"

@implementation TimetableOptionCell

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
    
	if (self) {
        static UIImage *timetableoptioncellImage = nil;
        if (timetableoptioncellImage == nil) {
            timetableoptioncellImage = [UIImage imageNamed:@"timetableoptioncell.png"];
        }
        self.backgroundView = [[UIView alloc] init];
        self.backgroundView.backgroundColor = [UIColor colorWithPatternImage:timetableoptioncellImage];
	}
	
    return self;
}

- (IBAction)favorite {
	[self.originalCell.delegate favorite:self.event];
	[self.originalCell animateToOrigin];
}

- (IBAction)confirm {
	[self.originalCell.delegate confirm:self.event];
	[self.originalCell animateToOrigin];
}

- (IBAction)cancel {
	[self.originalCell.delegate cancel:self.event];
	[self.originalCell animateToOrigin];
}

- (IBAction)remove {
	[self.originalCell.delegate remove:self.event];
	[self.originalCell animateToOrigin];
}

@end

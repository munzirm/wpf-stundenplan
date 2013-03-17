//
//  TimetableOptionCell.m
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import "TimetableOptionCell.h"

@implementation TimetableOptionCell

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

//
//  TimetableOptionCell.m
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import "TimetableOptionCell.h"

@implementation TimetableOptionCell

- (IBAction)favorite {
	[self.originalCell animateToOrigin];
	[self.originalCell.delegate favorite:self.event];
}

- (IBAction)confirm {
	[self.originalCell animateToOrigin];
	[self.originalCell.delegate confirm:self.event];
}

- (IBAction)cancel {
	[self.originalCell animateToOrigin];
	[self.originalCell.delegate cancel:self.event];
}

- (IBAction)remove {
	[self.originalCell animateToOrigin];
	[self.originalCell.delegate remove:self.event];
}

@end

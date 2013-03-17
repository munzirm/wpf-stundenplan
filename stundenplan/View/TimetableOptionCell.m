//
//  TimetableOptionCell.m
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import "TimetableOptionCell.h"

@implementation TimetableOptionCell

- (IBAction)favorite {
	[self.delegate favorite:self.event];
}

- (IBAction)confirm {
	[self.delegate confirm:self.event];
}

- (IBAction)cancel {
	[self.delegate cancel:self.event];
}

- (IBAction)remove {
	[self.delegate remove:self.event];
}

@end

//
//  ModulEventDetailViewController.m
//  stundenplan
//
//  Created by Dominik Schilling on 18.03.13.
//  Copyright (c) 2013 FH-K√∂ln. All rights reserved.
//

#import "ModulEventDetailViewController.h"

@implementation ModulEventDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

	self.title = _modulEvent.modulAcronym;

	[_fullName setText:_modulEvent.modulFullName];
	_fullName.numberOfLines = 0;

	[_date setText:[NSString stringWithFormat:@"%@: %@ - %@", _modulEvent.weekday, _modulEvent.startTime, _modulEvent.endTime]];
	[_type setText:_modulEvent.modulType];

}

@end

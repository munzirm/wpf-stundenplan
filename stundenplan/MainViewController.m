//
//  MainViewController.m
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import "MainViewController.h"

#import "IcalTestViewController.h"

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSLog(@"MainViewController viewDidLoad: %@", self.storyboard);
	
	self.centerController = [self.storyboard instantiateViewControllerWithIdentifier:@"IcalTestViewController"];
	self.leftController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainMenuViewController"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

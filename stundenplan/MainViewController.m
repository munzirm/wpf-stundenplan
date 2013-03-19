//
//  MainViewController.m
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import "MainViewController.h"

#import "TimetableViewController.h"

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.panningMode = IIViewDeckDelegatePanning;
	self.delegate = self;
	
	self.centerController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainContent"];
	self.leftController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainMenu"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 Enable pan gestures only if the gesture start at the left side of the screen.
 */
- (BOOL)viewDeckController:(IIViewDeckController*)viewDeckController
				 shouldPan:(UIPanGestureRecognizer*)panGestureRecognizer {
	if ([self isAnySideOpen]) {
		return YES;
	} else {
		return [panGestureRecognizer locationInView:self.centerController.view].x < 40;
	}
}

@end

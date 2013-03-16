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
	
	self.panningMode = IIViewDeckDelegatePanning;
	self.delegate = self;
	
	self.centerController = [self.storyboard instantiateViewControllerWithIdentifier:@"IcalTestViewController"];
	self.leftController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainMenuViewController"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 Enable pan gestures only if the gesture start at the left side of the screen.
 */
- (BOOL)viewDeckController:(IIViewDeckController*)viewDeckController shouldPan:(UIPanGestureRecognizer*)panGestureRecognizer {
	NSLog(@"shouldPan: %@", panGestureRecognizer);
	if ([self isAnySideOpen]) {
		return YES;
	} else {
		return [panGestureRecognizer locationInView:self.centerController.view].x < 40;
	}
}

@end

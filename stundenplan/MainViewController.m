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
	
	[self setLeftSize:100];
	
	self.leftController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainMenu"];
	[self openTimetableViewController];
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

- (void) openTimetableViewController {
	self.centerController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainContent"];
	NSLog(@"openTimetable: %@", self.centerController);
}

- (void) openSearchModuleViewController {
	self.centerController = [self.storyboard instantiateViewControllerWithIdentifier:@"ModuleSearch"];
}

- (void) openConfigureModuleViewController: (NSString*) moduleLabel {
	self.centerController = [self.storyboard instantiateViewControllerWithIdentifier:@"ModuleConfiguration"];
}

- (void) openSettingsViewController {
	self.centerController = [self.storyboard instantiateViewControllerWithIdentifier:@"Settings"];
}

// Currently we use no seque here to switch to the correct sidebar page.
// See seque in the storyboard are only as a visuell overview!
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//}

@end

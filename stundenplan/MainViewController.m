//
//  MainViewController.m
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import "MainViewController.h"

#import "TimetableViewController.h"
#import "ModulSearchViewController.h"
#import "ModulConfigurationViewController.h"
#import "SettingsViewController.h"

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
		return [panGestureRecognizer locationInView:self.centerController.view].x < 60;
	}
}

- (void) openTimetableViewController {
	if (![self.centerController.navigationController.topViewController isKindOfClass:TimetableViewController.class]) {
		((UINavigationController*) self.centerController).delegate = nil;
		self.centerController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainContent"];
		((UINavigationController*) self.centerController).delegate = self;
	}
}

- (void) openSearchModuleViewController {
	((UINavigationController*) self.centerController).delegate = nil;
	self.centerController = [self.storyboard instantiateViewControllerWithIdentifier:@"ModuleSearch"];
	((UINavigationController*) self.centerController).delegate = self;
}

- (void) openConfigureModuleViewController: (NSString*) moduleLabel {
	((UINavigationController*) self.centerController).delegate = nil;
	self.centerController = [self.storyboard instantiateViewControllerWithIdentifier:@"ModuleConfiguration"];
	((UINavigationController*) self.centerController).delegate = self;
}

- (void) openSettingsViewController {
	((UINavigationController*) self.centerController).delegate = nil;
	self.centerController = [self.storyboard instantiateViewControllerWithIdentifier:@"Settings"];
	((UINavigationController*) self.centerController).delegate = self;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
	
	UIBarButtonItem* menuButton = [[UIBarButtonItem alloc] initWithTitle:@"="
																   style:UIBarButtonItemStylePlain
																  target:self
																  action:@selector(openOrCloseSidebar:)];
	
	viewController.navigationItem.leftBarButtonItem = menuButton;
}

- (void)openOrCloseSidebar:(id)sender {
	if ([self isSideOpen:IIViewDeckLeftSide]) {
		[self closeLeftViewAnimated:YES];
	} else {
		[self openLeftViewAnimated:YES];
	}
}

// Currently we use no seque here to switch to the correct sidebar page.
// See seque in the storyboard are only as a visuell overview!
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//}

@end

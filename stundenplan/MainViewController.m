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
	UIImage *image = [UIImage imageNamed:@"menu.png"];
    CGRect frameimg = CGRectMake(0, 0, image.size.width,image.size.height);
    
    UIButton *button = [[UIButton alloc] initWithFrame:frameimg];
    
    [button setBackgroundImage:image forState:UIControlStateNormal];

    [button addTarget:self action:@selector(openOrCloseSidebar:) forControlEvents:UIControlEventTouchUpInside];
    
	/*UIBarButtonItem* menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"]
                                                    landscapeImagePhone:nil
                                                    style:UIBarButtonItemStyle
                                                    target:self
                                                    action:@selector(openOrCloseSidebar:)];*/
	UIBarButtonItem *menuButton =[[UIBarButtonItem alloc] initWithCustomView:button]; 
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

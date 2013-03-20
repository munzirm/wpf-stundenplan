//
//  MainViewController.h
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import <ViewDeck/IIViewDeckController.h>

@interface MainViewController : IIViewDeckController <IIViewDeckControllerDelegate, UINavigationControllerDelegate>

- (void) openTimetableViewController;

- (void) openSearchModuleViewController;

- (void) openConfigureModuleViewController: (NSString*) moduleLabel;

- (void) openSettingsViewController;

- (void) updateData;

@end

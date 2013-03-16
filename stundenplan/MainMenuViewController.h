//
//  MainMenuViewController.h
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainMenuModuleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel* moduleLabel;
@property (weak, nonatomic) IBOutlet UIView* moduleColorIndicator;
@property (weak, nonatomic) IBOutlet UIButton* moduleConfigurationButton;
@end

@interface MainMenuFilterCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel* filterLabel;
@property (weak, nonatomic) IBOutlet UIView* filterSelectionIndicator;
@end

@interface MainMenuMoreCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel* moreLabel;
@end

@interface MainMenuViewController : UITableViewController
@end

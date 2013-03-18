//
//  ModulEventDetailViewController.h
//  stundenplan
//
//  Created by Dominik Schilling on 18.03.13.
//  Copyright (c) 2013 FH-K√∂ln. All rights reserved.
//

#import "ModulEvent.h"

@interface ModulEventDetailViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *fullName;
@property (strong, nonatomic) IBOutlet UILabel *type;
@property (strong, nonatomic) IBOutlet UILabel *date;



@property (nonatomic, strong) ModulEvent *modulEvent;

@end

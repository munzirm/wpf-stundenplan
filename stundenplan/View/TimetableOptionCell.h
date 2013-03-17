//
//  TimetableOptionCell.h
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import "ModulEvent.h"

#import "TimetableCell.h"

@interface TimetableOptionCell : UITableViewCell

@property (weak, nonatomic) TimetableCell* originalCell;

@property (weak, nonatomic) ModulEvent* event;

- (IBAction)favorite;
- (IBAction)confirm;
- (IBAction)cancel;
- (IBAction)remove;

@end

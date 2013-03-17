//
//  TimetableCell.m
//  stundenplan
//
//  Copyright (c) 2013 Christoph Jerolimov, Dominik Schilling. All rights reserved.
//

#import "TimetableCell.h"

@implementation TimetableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// Ignore the editing mode to no not show the ios standard delete button.
- (void)setEditing:(BOOL)editing {
}

// Ignore the editing mode to no not show the ios standard delete button.
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
}

@end

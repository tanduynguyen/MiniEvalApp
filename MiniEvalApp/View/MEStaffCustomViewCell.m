//
//  MEStaffViewCell.m
//  MiniEvalApp
//
//  Created by viet on 1/21/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "MEStaffCustomViewCell.h"
#import "MEPerson.h"

#import "UIImageView+AFNetworking.h"

@implementation MEStaffCustomViewCell {    
@private
    __strong MEPerson *_person;
}

@synthesize person = _person;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)setPerson:(MEPerson *)person {
    _person = person;
    
    self.nameLabel.text = person.name;
    self.userNameLabel.text = person.userName;
    if (person.image) {
        [self.avatar setImageWithURL:[NSURL URLWithString:person.image] placeholderImage:[UIImage imageNamed:@"icon_profile.png"]];
    } else {
        [self.avatar setImage:[UIImage imageNamed:@"icon_profile.png"]];
    }
        
    UIColor *genderCellColor;
    
    if ([person.gender isEqualToString:@"male"]) {
        genderCellColor = UIColorFromRGB(kDarkOrganColor);
    } else {
        genderCellColor = UIColorFromRGB(kDarkBlueColor);
    }
    
    [self.nameLabel setTextColor:genderCellColor];
    
    [self.nameLabel setNumberOfLines:0];
    [self.userNameLabel setNumberOfLines:0];
    
    [self setNeedsLayout];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

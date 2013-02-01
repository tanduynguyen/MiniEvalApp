//
//  MEStaffViewCell.m
//  MiniEvalApp
//
//  Created by viet on 1/21/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "MEStaffCustomViewCell.h"

#import "UIImageView+AFNetworking.h"

@implementation MEStaffCustomViewCell

- (UIFont *)myCustomFont:(CGFloat)fontSize
{
    UIFont *myFont = [UIFont fontWithName:@"MyriadPro-Regular" size:fontSize];
        
    if (!myFont) {
        myFont = [UIFont fontWithName:@"Arial" size:fontSize];
    }
    return myFont;
}


- (void)configureWithData:(MEPerson *)person
                  atIndex:(NSIndexPath *)indexPath
{    
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
    
    self.starImage.hidden = !person.highestVisitedCount;
    
    [self.nameLabel setNumberOfLines:0];
    [self.userNameLabel setNumberOfLines:0];    
    [self.userNameLabel setFont:[self myCustomFont:11]];
    
    UIView *backView = [[UIView alloc] initWithFrame:self.frame];
    if (indexPath.row % 2) {
        backView.backgroundColor = UIColorFromRGB(kLightOrganColor);
    } else {
        backView.backgroundColor = [UIColor whiteColor];
    }
    self.backgroundView = backView;    
    
    [self setNeedsLayout];
}


@end

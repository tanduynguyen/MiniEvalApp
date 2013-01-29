//
//  MEStaffViewCell.m
//  MiniEvalApp
//
//  Created by viet on 1/21/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "MEStaffCustomViewCell.h"

#import "UIImageView+AFNetworking.h"

@implementation MEStaffCustomViewCell {    
@private
    __strong MEPerson *_person;
}

@synthesize person = _person;

- (UIFont *)myCustomFont:(CGFloat)fontSize {
    UIFont *myFont = [UIFont fontWithName:@"MyriadPro-Regular" size:fontSize];
    
//    if (!myFont) {
//        NSString *fontPath = [[NSBundle mainBundle] pathForResource:@"MyriadPro-Regular" ofType:@"otf"];
//        CGDataProviderRef fontDataProvider = CGDataProviderCreateWithFilename([fontPath UTF8String]);
//        CGFontCreateWithDataProvider(fontDataProvider);
//    }
    
    if (!myFont) {
        myFont = [UIFont fontWithName:@"Arial" size:fontSize];
    }
    return myFont;
}

- (void)awakeFromNib
{    
    [self.userNameLabel setFont:[self myCustomFont:11]];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)configureWithData:(MEPerson *)person
                  atIndex:(NSIndexPath *)indexPath
{
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
    
    self.starImage.hidden = !person.highestVisitedCount;
    
    [self.nameLabel setNumberOfLines:0];
    [self.userNameLabel setNumberOfLines:0];
    
    UIView *backView = [[UIView alloc] initWithFrame:self.frame];
    if (indexPath.row % 2) {
        backView.backgroundColor = UIColorFromRGB(kLightOrganColor);
    } else {
        backView.backgroundColor = [UIColor whiteColor];
    }
    self.backgroundView = backView;
    
    [self setNeedsLayout];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end

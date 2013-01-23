//
//  MEStaffViewCell.h
//  MiniEvalApp
//
//  Created by viet on 1/21/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MEPerson;

@interface MEStaffCustomViewCell : UITableViewCell

@property (nonatomic, strong) MEPerson *person;

@property (strong, nonatomic) IBOutlet UIImageView *avatar;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;

@property (strong, nonatomic) IBOutlet UIImageView *starImage;


@end

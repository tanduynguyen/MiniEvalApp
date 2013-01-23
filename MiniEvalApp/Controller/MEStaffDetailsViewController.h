//
//  MEStaffDetailsViewController.h
//  MiniEvalApp
//
//  Created by viet on 1/23/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MEPerson.h"

@interface MEStaffDetailsViewController : UIViewController

@property (strong, nonatomic) MEPerson *person;

@property (strong, nonatomic) IBOutlet UIImageView *avatar;

@property (strong, nonatomic) IBOutlet UILabel *roleLabel;

@property (strong, nonatomic) IBOutlet UILabel *emailLabel;

@property (strong, nonatomic) IBOutlet UILabel *contactLabel;

@property (strong, nonatomic) IBOutlet UILabel *likeLabel;

@property (strong, nonatomic) IBOutlet UILabel *dislikeLabel;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *addContact;

@end

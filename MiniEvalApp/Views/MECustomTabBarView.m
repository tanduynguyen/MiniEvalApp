//
//  MECustomTabBarView.m
//  MiniEvalApp
//
//  Created by viet on 1/25/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "MECustomTabBarView.h"

@implementation MECustomTabBarView

//Let the delegate know that a tab has been touched
- (IBAction)touchContactsButton:(id)sender {
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(tabWasSelected:)]) {
        [self.infoButton setImage:[UIImage imageNamed:@"icon_info"] forState:UIControlStateNormal];
        [self.contactsButton setImage:[UIImage imageNamed:@"icon_contacts_selected"] forState:UIControlStateNormal];
        
        [self.delegate tabWasSelected:self.contactsButton.tag];
    }
}

- (IBAction)touchInfoButton:(id)sender {
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(tabWasSelected:)]) {
        [self.infoButton setImage:[UIImage imageNamed:@"icon_info_selected"] forState:UIControlStateNormal];
        [self.contactsButton setImage:[UIImage imageNamed:@"icon_contacts"] forState:UIControlStateNormal];
        
        [self.delegate tabWasSelected:self.infoButton.tag];
    }
}

@end

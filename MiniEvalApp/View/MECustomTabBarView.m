//
//  MECustomTabBarView.m
//  MiniEvalApp
//
//  Created by viet on 1/25/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "MECustomTabBarView.h"

@implementation MECustomTabBarView


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

//Let the delegate know that a tab has been touched
- (IBAction)touchContactsButton:(id)sender {
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(tabWasSelected:)]) {
        [self.infoButton setImage:[UIImage imageNamed:@"icon_info.png"] forState:UIControlStateNormal];
        [self.contactsButton setImage:[UIImage imageNamed:@"icon_contacts_selected.png"] forState:UIControlStateNormal];
        
        [self.delegate tabWasSelected:self.contactsButton.tag];
    }
}

- (IBAction)touchInfoButton:(id)sender {
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(tabWasSelected:)]) {
        [self.infoButton setImage:[UIImage imageNamed:@"icon_info_selected.png"] forState:UIControlStateNormal];
        [self.contactsButton setImage:[UIImage imageNamed:@"icon_contacts.png"] forState:UIControlStateNormal];
        
        [self.delegate tabWasSelected:self.infoButton.tag];
    }
}



@end

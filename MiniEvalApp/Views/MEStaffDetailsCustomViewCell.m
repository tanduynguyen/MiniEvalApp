//
//  MEStaffDetailsCustomViewCell.m
//  MiniEvalApp
//
//  Created by viet on 1/23/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "MEStaffDetailsCustomViewCell.h"
#import "MECustomAnimation.h"

@interface MEStaffDetailsCustomViewCell()

@property CGRect textFrame;

@end

@implementation MEStaffDetailsCustomViewCell

- (void)setContentData:(NSDictionary *)dictionary
               atIndex:(NSIndexPath *)indexPath
{
    if (self) {        
        [self setTag:[(NSNumber *)dictionary[@"tag"] intValue]];
                
        if (dictionary[@"imageCell"]) {
            [self.imageCell setImage:[UIImage imageNamed:dictionary[@"imageCell"]]];
        }
        
        self.textCell.text = dictionary[@"textCell"];     
        [self.textCell setNumberOfLines:0];
        [self.textCell setLineBreakMode:NSLineBreakByWordWrapping];
        self.textCell.tag = 2;
    }    
}

- (void)didMoveToSuperview
{    
    _textFrame = self.textCell.frame;
}

- (void)resetDefaultFrame
{
    [self.textCell setFrame:_textFrame];
}

@end

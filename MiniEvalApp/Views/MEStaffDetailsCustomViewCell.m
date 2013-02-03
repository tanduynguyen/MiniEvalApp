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
        [self setTag:[(NSNumber *)[dictionary objectForKey:@"tag"] intValue]];
                
        if ([dictionary objectForKey:@"imageCell"]) {
            [self.imageCell setImage:[UIImage imageNamed:[dictionary objectForKey:@"imageCell"]]];
        }
        
        self.textCell.text = [dictionary objectForKey:@"textCell"];     
        [self.textCell setNumberOfLines:0];
        [self.textCell setLineBreakMode:NSLineBreakByWordWrapping];        
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

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
@property CGRect imageFrame;

@end

@implementation MEStaffDetailsCustomViewCell

- (void)setContentData:(NSDictionary *)dictionary
{    
    if (self) {
        self.alpha = 0;
        if ([dictionary objectForKey:@"imageCell"]) {
            [self.imageCell setImage:[UIImage imageNamed:[dictionary objectForKey:@"imageCell"]]];
        }
        
        self.textCell.text = [dictionary objectForKey:@"textCell"];
        
        if ([dictionary objectForKey:@"sizeAmount"]) {
            CGRect customframe = self.imageCell.frame;
            customframe.origin.x = customframe.origin.y = [(NSNumber *)[dictionary objectForKey:@"topleft"] intValue];            
            customframe.size.height = customframe.size.width = [(NSNumber *)[dictionary objectForKey:@"sizeAmount"] intValue];            
            [self.imageCell setFrame:customframe];
        }
       
        if ([dictionary objectForKey:@"tag"]) {
            [self setTag:[(NSNumber *)[dictionary objectForKey:@"tag"] intValue]];
        }
        
        [self.textCell setNumberOfLines:0];
        [self.textCell setLineBreakMode:NSLineBreakByWordWrapping];
        
    }    
}

- (void) didMoveToWindow
{    
    _textFrame = self.textCell.frame;
    _imageFrame = self.imageCell.frame;
}

- (void)resetDefaultSize
{
    [self.textCell setFrame:_textFrame];
    [self.imageCell setFrame:_imageFrame];
}

@end

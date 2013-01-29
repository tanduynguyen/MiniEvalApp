//
//  MEStaffDetailsCustomViewCell.m
//  MiniEvalApp
//
//  Created by viet on 1/23/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "MEStaffDetailsCustomViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation MEStaffDetailsCustomViewCell

- (void)setContentData :(NSDictionary *)dictionary
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

        CABasicAnimation *hover = [CABasicAnimation animationWithKeyPath:@"position"];
        hover.additive = YES; // fromValue and toValue will be relative instead of absolute values
        hover.fromValue = [NSValue valueWithCGPoint:CGPointZero];
        hover.toValue = [NSValue valueWithCGPoint:CGPointMake(0.0, -5.0)]; // y increases downwards on iOS
        hover.autoreverses = YES; // Animate back to normal afterwards
        hover.duration = 0.2; // The duration for one part of the animation (0.2 up and 0.2 down)
        hover.repeatCount = 5; // The number of times the animation should repeat
        [self.imageCell.layer addAnimation:hover forKey:@"myHoverAnimation"];
    }    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:TRUE];

    // Configure the view for the selected state
}

@end

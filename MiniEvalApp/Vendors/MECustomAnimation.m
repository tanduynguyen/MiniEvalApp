//
//  MECustomAnimation.m
//  MiniEvalApp
//
//  Created by viet on 1/29/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "MECustomAnimation.h"

@implementation MECustomAnimation

+ (CABasicAnimation *)bouncedAnimation
{
    CABasicAnimation *hover = [CABasicAnimation animationWithKeyPath:@"position"];
    hover.additive = YES; // fromValue and toValue will be relative instead of absolute values
    hover.fromValue = [NSValue valueWithCGPoint:CGPointZero];
    hover.toValue = [NSValue valueWithCGPoint:CGPointMake(0.0, -5.0)]; // y increases downwards on iOS
    hover.autoreverses = YES; // Animate back to normal afterwards
    hover.duration = 0.2; // The duration for one part of the animation (0.2 up and 0.2 down)
    hover.repeatCount = 5; // The number of times the animation should repeat
    
    return hover;
}

+ (void)setCustomShadow:(CALayer *)layer
{
    [layer setCornerRadius:2.0f];
    [layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [layer setBorderWidth:0.1f];
    [layer setShadowColor:[UIColor grayColor].CGColor];
    [layer setShadowOpacity:0.6];
    [layer setShadowRadius:3.0];
    [layer setShadowOffset:CGSizeMake(2.0, 2.0)];
}

@end

//
//  MECustomAnimation.h
//  MiniEvalApp
//
//  Created by viet on 1/29/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface MECustomAnimation : NSObject

+ (CABasicAnimation *)bouncedAnimation;
+ (void)addCustomShadow:(CALayer *)layer;
+ (void)removeCustomShadow:(CALayer *)layer;
+ (NSTimeInterval) animationDurationOfLayer:(CALayer *)layer;

@end

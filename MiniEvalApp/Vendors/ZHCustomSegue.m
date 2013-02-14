//
//  ZHCustomSegue.m
//  CustomSegue
//
//  Created by Zakir on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ZHCustomSegue.h"
#import "QuartzCore/QuartzCore.h"

@implementation ZHCustomSegue


- (void)perform {
    
    UIViewController *sourceViewController = (UIViewController*)[self sourceViewController];
    UIViewController *destinationController = (UIViewController*)[self destinationViewController];                    
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    NSArray *arrayCATransition = @[kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade];    
    transition.type = arrayCATransition[random() % [arrayCATransition count]];
    
    NSArray *arrayCATransitionSubType = @[kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom];
    transition.subtype = arrayCATransitionSubType[random() % [arrayCATransitionSubType count]];
    
    
    [sourceViewController.navigationController.view.layer addAnimation:transition
                                                                forKey:kCATransition];
    
    [sourceViewController.navigationController pushViewController:destinationController animated:NO];    
    
}
@end

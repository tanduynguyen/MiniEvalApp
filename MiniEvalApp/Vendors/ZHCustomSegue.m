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


-(void)perform {
    
    UIViewController *sourceViewController = (UIViewController*)[self sourceViewController];
    UIViewController *destinationController = (UIViewController*)[self destinationViewController];                    
    
    CATransition* transition = [CATransition animation];
    transition.duration = .3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    NSArray *arrayCATransition = [NSArray arrayWithObjects: kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade, nil];    
    transition.type = [arrayCATransition objectAtIndex:random() % [arrayCATransition count]];
    
    NSArray *arrayCATransitionSubType = [NSArray arrayWithObjects: kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom, nil];
    transition.subtype = [arrayCATransitionSubType objectAtIndex:random() % [arrayCATransitionSubType count]];
    
    
    [sourceViewController.navigationController.view.layer addAnimation:transition
                                                                forKey:kCATransition];
    
    [sourceViewController.navigationController pushViewController:destinationController animated:NO];    
    
}
@end

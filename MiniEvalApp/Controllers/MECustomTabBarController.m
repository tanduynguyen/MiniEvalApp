//
//  MECustomTabBarController.m
//  MiniEvalApp
//
//  Created by viet on 1/25/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "MECustomTabBarController.h"

@interface MECustomTabBarController ()

@end

@implementation MECustomTabBarController

@synthesize customTabBarView;

- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self hideExistingTabBar];
    
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"MECustomTabBar" owner:self options:nil];
    self.customTabBarView = [nibObjects objectAtIndex:0];
    
    CGRect customTabBarFrame = self.customTabBarView.frame;
    customTabBarFrame.origin.y = self.view.frame.size.height - customTabBarFrame.size.height;
    
    [self.customTabBarView setFrame:customTabBarFrame];
    
    self.customTabBarView.delegate = self;
    
    self.customTabBarView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    
    [self.view addSubview:self.customTabBarView];
}

- (void)hideExistingTabBar
{
	for(UIView *view in self.view.subviews)
	{
		if([view isKindOfClass:[UITabBar class]])
		{
            self.customTabBarView.frame = view.frame;
			view.hidden = YES;
			break;
		}
	}
}


-(void)tabWasSelected:(NSInteger)index
{
    UIViewController *viewController = [self.viewControllers objectAtIndex:index];
    
    UIView * fromView = self.selectedViewController.view;
    UIView * toView = viewController.view;
    
    if (fromView != toView) {    
        NSUInteger fromIndex = [self.viewControllers indexOfObject:self.selectedViewController];
        
        [UIView transitionFromView:fromView
                            toView:toView
                          duration:0.5
                           options: index > fromIndex ? UIViewAnimationOptionTransitionFlipFromLeft : UIViewAnimationOptionTransitionFlipFromRight
                        completion:^(BOOL finished) {
                            if (finished) {
                                self.selectedIndex = index;
                            }
                        }];
    }
}

@end

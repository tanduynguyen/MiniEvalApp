//
//  MECustomTabBarController.m
//  MiniEvalApp
//
//  Created by viet on 1/25/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "MECustomTabBarController.h"

@interface MECustomTabBarController () <MECustomTabBarDelegate>

@end

@implementation MECustomTabBarController

@synthesize customTabBarView;

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.tabBar.hidden = YES;
    
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"MECustomTabBar" owner:self options:nil];
    self.customTabBarView = nibObjects[0];
    
    CGRect customTabBarFrame = self.customTabBarView.frame;
    customTabBarFrame.origin.y = self.view.frame.size.height - customTabBarFrame.size.height;
    
    [self.customTabBarView setFrame:customTabBarFrame];
    
    self.customTabBarView.delegate = self;
    
    self.customTabBarView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    
    [self.view addSubview:self.customTabBarView];
}


-(void)tabWasSelected:(NSInteger)index
{
    if (self.selectedIndex == index)
        return;
    
    UIViewController *viewController = (self.viewControllers)[index];
    
    UIView * fromView = self.selectedViewController.view;
    UIView * toView = viewController.view;
    
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

@end

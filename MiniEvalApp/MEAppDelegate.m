//
//  MEAppDelegate.m
//  MiniEvalApp
//
//  Created by viet on 1/21/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "MEAppDelegate.h"
#import "UIColor+MEColor.h"


@implementation MEAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    
    self.window.backgroundColor = [UIColor lightGrayColor];
    
    [[UINavigationBar appearance] setTintColor:[UIColor kMainColor]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:
     @{UITextAttributeTextColor: [UIColor whiteColor],
      UITextAttributeTextShadowColor: [UIColor kMainColor],
      UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
      UITextAttributeFont: [UIFont fontWithName:@"Helvetica" size:20.0]}];
    
    
    [[UITabBar appearance] setTintColor:[UIColor kDarkOrganColor]];
    
    [[UIBarButtonItem appearance] setTintColor:[UIColor kDarkOrganColor]];
    
    [[UISearchBar appearance] setTintColor:[UIColor kDarkOrganColor]];
    
    return YES;
}

@end

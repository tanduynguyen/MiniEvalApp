//
//  MEAppDelegate.m
//  MiniEvalApp
//
//  Created by viet on 1/21/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "MEAppDelegate.h"


@implementation MEAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    UIColor *DarkOrganColor = UIColorFromRGB(kDarkOrganColor);
    UIColor *MainColor = UIColorFromRGB(kMainColor);
    
    self.window.backgroundColor = [UIColor lightGrayColor];
    
    [[UINavigationBar appearance] setTintColor:MainColor];
    
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor],
      UITextAttributeTextColor,
      MainColor,
      UITextAttributeTextShadowColor,
      [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
      UITextAttributeTextShadowOffset,
      [UIFont fontWithName:@"Helvetica" size:20.0],
      UITextAttributeFont,
      nil]];
    
    
    [[UITabBar appearance] setTintColor:DarkOrganColor];
    
    [[UIBarButtonItem appearance] setTintColor:DarkOrganColor];
    
    [[UISearchBar appearance] setTintColor:DarkOrganColor];
    
    return YES;
}

@end

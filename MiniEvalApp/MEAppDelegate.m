//
//  MEAppDelegate.m
//  MiniEvalApp
//
//  Created by viet on 1/21/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "MEAppDelegate.h"
#import "AFNetworkActivityIndicatorManager.h"

@implementation MEAppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
  
    
    UIColor *DarkOrganColor = UIColorFromRGB(kDarkOrganColor);
    UIColor *MainColor = UIColorFromRGB(kMainColor);
    
    //    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"bk.png"] forBarMetrics:UIBarStyleDefault];
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
    
    return YES;
}

@end
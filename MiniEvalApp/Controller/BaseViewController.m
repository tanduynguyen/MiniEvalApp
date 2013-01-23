//
//  BaseViewController.m
//  RaisedCenterTabBar
//
//  Created by Peter Boctor on 12/15/10.
//
// Copyright (c) 2011 Peter Boctor
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE
//

#import "BaseViewController.h"

@implementation BaseViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *imgInfo = [UIImage imageNamed:@"icon_info.png"];
    UIImage *imgInfoHighlight = [UIImage imageNamed:@"icon_info_selected.png"];
    
    UIImage *imgContacts = [UIImage imageNamed:@"icon_contacts.png"];
    UIImage *imgContactsHighlight = [UIImage imageNamed:@"icon_contacts_selected.png"];
    
    UIImage *imgSettings = [UIImage imageNamed:@"middle_button.png"];
    
    
    UITabBar *tabBar = self.tabBarController.tabBar;
    
    UITabBarItem *firstTabItem = [tabBar.items objectAtIndex:0];
    UITabBarItem *secondTabItem = [tabBar.items objectAtIndex:1];
    // UITabBarItem *thirdTabItem = [tabBar.items objectAtIndex:2];
    //...and so on if you have more than 3 tabs
    
    [firstTabItem setFinishedSelectedImage:imgInfoHighlight withFinishedUnselectedImage:imgInfo];
    [secondTabItem setFinishedSelectedImage:imgContactsHighlight withFinishedUnselectedImage:imgContacts];
    // [thirdTabItem setFinishedSelectedImage:imgSettingsHighlight withFinishedUnselectedImage:imgSettings];
    
//    self.viewControllers = [NSArray arrayWithObjects:
//                            [self viewControllerWithTabTitle:@"Info" image:[UIImage imageNamed:@"icon_info.png"]],
//                            [self viewControllerWithTabTitle:@"News" image:[UIImage imageNamed:nil]],
//                            [self viewControllerWithTabTitle:@"Contacts" image:[UIImage imageNamed:@"icon_contacts.png"]], nil];
}

/*
 -(void)willAppearIn:(UINavigationController *)navigationController
{
    [self addCenterButtonWithImage:[UIImage imageNamed:@"middle_button.png"] highlightImage:nil];
}

// Create a view controller and setup it's tab bar item with a title and image
-(UIViewController*) viewControllerWithTabTitle:(NSString*) title image:(UIImage*)image
{
    UIViewController* viewController = [[UIViewController alloc] init];
    viewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image tag:0];
    return viewController;
}

// Create a custom UIButton and add it to the center of our tab bar
-(void) addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    
    CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
    if (heightDifference < 0)
        button.center = self.tabBar.center;
    else
    {
        CGPoint center = self.tabBar.center;
        center.y = center.y - heightDifference/2.0;
        button.center = center;
    }
    
    [self.view addSubview:button];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
 */

@end

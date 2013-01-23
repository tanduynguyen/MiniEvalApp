//
//  MEInfoViewController.m
//  MiniEvalApp
//
//  Created by viet on 1/21/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "MEInfoViewController.h"

@interface MEInfoViewController ()

@end

@implementation MEInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSURL *url = [NSURL URLWithString:@"http://2359media.com/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    
    UIImage *imgInfo = [UIImage imageNamed:@"icon_info.png"];
    UIImage *imgInfoHighlight = [UIImage imageNamed:@"icon_info_selected.png"];
    
    UIImage *imgContacts = [UIImage imageNamed:@"icon_contacts.png"];
    UIImage *imgContactsHighlight = [UIImage imageNamed:@"icon_contacts_selected.png"];
    
    UIImage *imgSettings = [UIImage imageNamed:@"middle_button.png"];
    
    
    UITabBar *tabBar = self.tabBarController.tabBar;
    
    UITabBarItem *firstTabItem = [tabBar.items objectAtIndex:0];
    UITabBarItem *secondTabItem = [tabBar.items objectAtIndex:1];
    UITabBarItem *thirdTabItem = [tabBar.items objectAtIndex:2];
    
    [firstTabItem setFinishedSelectedImage:imgInfoHighlight withFinishedUnselectedImage:imgInfo];
    [thirdTabItem setFinishedSelectedImage:imgContactsHighlight withFinishedUnselectedImage:imgContacts];
    [secondTabItem setFinishedSelectedImage:imgSettings withFinishedUnselectedImage:imgSettings];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

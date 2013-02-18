//
//  MEInfoViewController.m
//  MiniEvalApp
//
//  Created by viet on 1/21/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "MEInfoViewController.h"

@interface MEInfoViewController ()

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation MEInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSURL *url = [NSURL URLWithString:kInfoWebsite];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    self.webView.scalesPageToFit = YES;
}


@end

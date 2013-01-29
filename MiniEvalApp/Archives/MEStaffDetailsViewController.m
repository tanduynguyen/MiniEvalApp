//
//  MEStaffDetailsViewController.m
//  MiniEvalApp
//
//  Created by viet on 1/23/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "MEStaffDetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MEStaffDetailsViewController ()

@end

@implementation MEStaffDetailsViewController

- (MEPerson *)person
{
    if (!_person) {
        _person = [[MEPerson alloc] init];
    }
    return _person;
}


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
    
    self.title = self.person.name;
    
    // Use NSUserDefault to store the visit count for each person.
    // When a user is selected, increase visit count
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *staffs = [[NSMutableDictionary alloc] init];
    
    staffs = [[defaults objectForKey:STAFFS_KEY] mutableCopy];
    
//    if ([staffs objectForKey:self.person.userId]) {
//        id obj = [staffs objectForKey:self.person.userId];
//        if ([obj isKindOfClass:[NSMutableDictionary class]]) {
//            NSMutableDictionary *staff = [obj mutableCopy];
//            self.person.visitedCount = [(NSNumber  *)[staff valueForKey:@"visitedCount"] unsignedIntegerValue]  + 1;
//            [staff setObject:[NSNumber numberWithUnsignedInt:self.person.visitedCount] forKey:@"visitedCount"];
//            
//            [staffs setObject:staff forKey:self.person.userId];
//        }
//    }
//    else {
//        self.person.visitedCount = 1;
//        NSMutableDictionary *staff = [NSDictionary dictionaryWithObjectsAndKeys:
//                                      [NSNumber numberWithUnsignedInt:self.person.visitedCount], @"visitedCount",
//                                      nil];
//        
//        [staffs setObject:staff forKey:self.person.userId];
//    }
    
    [defaults setObject:staffs forKey:STAFFS_KEY];
    [defaults synchronize];
    
    [self loadDetailsInformation];
    
    [self customizeBackButton];
   
    [self customAddContactButton];
}

- (void)customizeBackButton
{
    //if (self.navigationItem.backBarButtonItem) {
        // Set the custom back button
        UIImage *buttonImage = [UIImage imageNamed:@"icon_back.png"];
        
        //create the button and assign the image
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:buttonImage forState:UIControlStateNormal];
        
        //set the frame of the button to the size of the image (see note below)
        button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
        
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        //create a UIBarButtonItem with the button as a custom view
        UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = customBarItem;
        
        [button setImage:buttonImage forState:UIControlStateHighlighted];
    //}
}

- (void)customAddContactButton
{
//    UIImageView *customButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_add_contact.png"]];
//    [customButton setFrame:CGRectMake(0, 0, 44, 44)];
//    [self.addContact setCustomView:customButton];
   
//    [self.addContact setBackgroundImage:[UIImage imageNamed:@"icon_add_contact.png"] forState:nil barMetrics:nil];
}

- (void)back {
	// Tell the controller to go back
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)loadDetailsInformation
{
    if (self.person.image) {
        #ifdef __MAC_OS_X_VERSION_MIN_REQUIRED
        [self.avatar setImage:self.person.profileImage];
        #else
        [self.avatar setImageWithURL:[NSURL URLWithString:self.person.image] placeholderImage:[UIImage imageNamed:@"image-profile.png"]];
        #endif
    }
    
    self.roleLabel.text = self.person.role;
    self.emailLabel.text = self.person.userName;
    self.contactLabel.text = self.person.contact;
    self.likeLabel.text = self.person.like;
    self.dislikeLabel.text = self.person.dislike;
}

- (IBAction)addContact:(id)sender {
    NSLog(@"add Contact");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

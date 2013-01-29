//
//  MEStaffDetailsTableViewController.m
//  MiniEvalApp
//
//  Created by viet on 1/23/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "MEStaffDetailsTableViewController.h"
#import "MEStaffDetailsCustomViewCell.h"

#import "ADLivelyTableView.h"
#import <QuartzCore/QuartzCore.h>

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>


@interface MEStaffDetailsTableViewController () <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray *items;
@property (nonatomic) BOOL fistLoadTableView;

@end

@implementation MEStaffDetailsTableViewController


- (MEPerson *)person
{
    if (!_person) {
        _person = [[MEPerson alloc] init];
    }
    return _person;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = self.person.name;    

    [self saveVistedCount];
    
    [self customizeBackButton];
    
    [self customAddContactButton];
    
    self.fistLoadTableView = YES;    
    [self initStaffDetailsCustomViewCells];    
    
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];    
}

- (void) viewWillLayoutSubviews
{
    if (self.fistLoadTableView == YES) {
        //  [self.tableView setHidden:YES];
        
        UIColor *DarkOrganColor = UIColorFromRGB(kDarkOrganColor);
        
        UIView *animationView = [[UIView alloc] initWithFrame:self.tableView.frame];
        [animationView setBackgroundColor:[UIColor whiteColor]];        
        
        [self.tableView addSubview:animationView];
        
        for (int i = 0; i < self.items.count; i++) {
            MEStaffDetailsCustomViewCell *cell = (MEStaffDetailsCustomViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];            
            
            UIView *rowView = [[UIView alloc] initWithFrame:cell.frame];
            
            [rowView.layer setCornerRadius:2.0f];
            [rowView.layer setBorderColor:DarkOrganColor.CGColor];
            [rowView.layer setBorderWidth:0.2f];
            [rowView.layer setShadowColor:[UIColor grayColor].CGColor];
            [rowView.layer setShadowOpacity:0.6];
            [rowView.layer setShadowRadius:3.0];
            [rowView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
                                    
            [rowView addSubview:cell.imageCell];
            [rowView addSubview:cell.textCell];
            rowView.alpha = 0;
            
            CGRect customFrame = rowView.frame;
            customFrame.origin.x -= customFrame.size.width;
            [rowView setFrame:customFrame];
            
            [animationView addSubview:rowView];
        }
        
        //[animationView addSubview:[[UIImageView alloc] initWithImage:self.person.avatar]];
        
        [self checkSubviews:animationView atIndex:0];
    }
}

- (void)checkSubviews:(UIView *)animationView
              atIndex:(int)idx
{
    if (idx >= [animationView.subviews count]) {
       
        [self removeAnimationView:animationView];        
        return;
    } 
    
    UIView *mySubview = [animationView.subviews objectAtIndex:idx];
    [UIView animateWithDuration:0.5
                          delay:0
                        options: UIViewAnimationOptionTransitionCurlDown
                     animations:^{
                         mySubview.alpha = 1;                         
                         CGRect customFrame = mySubview.frame;
                         customFrame.origin.x += customFrame.size.width;
                         [mySubview setFrame:customFrame];
                     }
                     completion:^(BOOL finished){ 
                         [self checkSubviews:animationView atIndex:idx + 1];
                     }];
}

- (void)removeAnimationView:(UIView *)animationView
{
    self.fistLoadTableView = NO;
    
    for (int i = 0; i < animationView.subviews.count; i++) {
        MEStaffDetailsCustomViewCell *cell = (MEStaffDetailsCustomViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        UIView *rowView = [animationView.subviews objectAtIndex:i];
        for (UIView *subView in rowView.subviews) {
            [cell addSubview:subView];
        }
       }
    
    [animationView removeFromSuperview];
    [animationView setFrame:CGRectZero];
    
    [self.tableView reloadData];
}


- (void)saveVistedCount
{
    // Use NSUserDefault to store the visit count for each person.
    // When a user is selected, increase visit count
//    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    
//    NSMutableDictionary *staffs = [[NSMutableDictionary alloc] init];
//    
//    staffs = [[defaults objectForKey:STAFFS_KEY] mutableCopy];
//    
    self.person.visitedCount = [[NSNumber alloc] initWithUnsignedInt:[self.person.visitedCount intValue] + 1];
//    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:self.person];
//    //NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:encodedObject];
//    [staffs setObject:[encodedObject mutableCopy] forKey:self.person.userId];
//   // [unarchiver finishDecoding];
//    
//    [defaults setObject:staffs forKey:STAFFS_KEY];
//    [defaults synchronize];
}

- (void)initStaffDetailsCustomViewCells
{
    self.items = [[NSMutableArray alloc] init];
    
    NSString *imageCell;
    NSString *textCell;
    
    imageCell = @"icon_profile.png";    
    textCell = self.person.role;
    NSMutableDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithUnsignedInt:TAG_AVATAR_CELL], @"tag",
                                 textCell, @"textCell",
                                 [NSNumber numberWithUnsignedInt:64], @"sizeAmount",
                                 [NSNumber numberWithUnsignedInt:5], @"topleft",
                                 nil];
    [self.items addObject:dict];
    
    imageCell = @"icon_email.png";
    textCell = self.person.userName;
    [self.items addObject:[NSDictionary dictionaryWithObjectsAndKeys: imageCell, @"imageCell", textCell, @"textCell", [NSNumber numberWithUnsignedInt:TAG_EMAIL_CELL], @"tag", nil]];
    
    if (self.person.contact) {
        imageCell = @"icon_sms.png";
        textCell = self.person.contact;        
        [self.items addObject:[NSDictionary dictionaryWithObjectsAndKeys: imageCell, @"imageCell", textCell, @"textCell", [NSNumber numberWithUnsignedInt:TAG_SMS_CELL], @"tag", nil]];
    }
    
    if (self.person.like) {
        imageCell = @"icon_like.png";
        textCell = self.person.like;
        [self.items addObject:[NSDictionary dictionaryWithObjectsAndKeys: imageCell, @"imageCell", textCell, @"textCell",[NSNumber numberWithUnsignedInt:0], @"tag", nil]];
    }
    
    if (self.person.dislike) {
        imageCell = @"icon_dislike.png";
        textCell = self.person.dislike;
        [self.items addObject:[[NSDictionary alloc] initWithObjectsAndKeys:imageCell, @"imageCell", textCell, @"textCell",[NSNumber numberWithUnsignedInt:0], @"tag", nil]];
    }
    
    if (self.person.visitedCount) {
        imageCell = @"icon_star.png";
        textCell = [NSString stringWithFormat:@"%@ visitors", self.person.visitedCount];
        [self.items addObject:[[NSDictionary alloc] initWithObjectsAndKeys:imageCell, @"imageCell", textCell, @"textCell",[NSNumber numberWithUnsignedInt:0], @"tag", nil]];
    }
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
    
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    //create a UIBarButtonItem with the button as a custom view
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    
    [button setImage:buttonImage forState:UIControlStateHighlighted];
    //}
}

- (void)customAddContactButton
{
    UIImage *addContactImage = [UIImage imageNamed:@"icon_add_contact.png"];
    UIButton *addContactButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addContactButton setBackgroundImage:addContactImage forState:UIControlStateNormal];
    [addContactButton setFrame:CGRectMake(0, 0, addContactImage.size.width, addContactImage.size.height)];
    UIBarButtonItem *reloadBarButton = [[UIBarButtonItem alloc] initWithCustomView:addContactButton];
    [addContactButton addTarget:self action:@selector(addContactAction) forControlEvents:UIControlEventTouchUpInside];

    [self.navigationItem setRightBarButtonItem:reloadBarButton];
}

- (void)backAction {
	// Tell the controller to go back
	[self.navigationController popViewControllerAnimated:YES];
}


- (void)addContactAction {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Address Book" message:[NSString stringWithFormat:@"Do you want to add %@ to your Address Book?", self.person.name] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    // optional - add more buttons:
    [alert addButtonWithTitle:@"Yes"];
    [alert setTag:12];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ([alertView tag] == 12) {
        if (buttonIndex == 1) {     // and they clicked OK.
            ABUnknownPersonViewController *unknownPersonViewController = [[ABUnknownPersonViewController alloc] init];
            unknownPersonViewController.displayedPerson = (ABRecordRef)[self buildContactDetails];
            unknownPersonViewController.allowsAddingToAddressBook = YES;
            [self.navigationController pushViewController:unknownPersonViewController animated:YES];
        }
    }
}

- (ABRecordRef)buildContactDetails {
    ABRecordRef person = ABPersonCreate();
    CFErrorRef  error = NULL;
    
    //name
    ABRecordSetValue(person, kABPersonFirstNameProperty, CFBridgingRetain(self.person.name), NULL);
    
    // email
    ABMutableMultiValueRef email = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(email, CFBridgingRetain(self.person.userName), CFSTR("email"), NULL);
    ABRecordSetValue(person, kABPersonEmailProperty, email, &error);
    CFRelease(email);
    
    // mobile
    ABMutableMultiValueRef mobile = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(mobile, CFBridgingRetain(self.person.contact), CFSTR("mobile"), NULL);
    ABRecordSetValue(person, kABPersonPhoneProperty, mobile, &error);
    CFRelease(mobile);
    
    
//    ABRecordSetValue(person, kABPersonOrganizationProperty, @"2359 Media", &error);
    ABRecordSetValue(person, kABPersonNoteProperty, CFBridgingRetain(self.person.role), &error);
    
    NSData *dataRef = UIImagePNGRepresentation(self.person.avatar);    
    ABPersonSetImageData(person, (CFDataRef)CFBridgingRetain(dataRef), nil);
    
    if (error != NULL) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Can not add %@ to your Address Book?", self.person.name] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        NSLog(@"Error: %@", error);
    }
    
    return person;
}


#pragma mark ABNewPersonViewControllerDelegate methods
// Dismisses the new-person view controller.
- (void)newPersonViewController:(ABNewPersonViewController *)newPersonViewController didCompleteWithNewPerson:(ABRecordRef)person
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Address Book" message:[NSString stringWithFormat:@"%@ has to added to your Address Book?", self.person.name] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StaffDetails";
    MEStaffDetailsCustomViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[MEStaffDetailsCustomViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSDictionary *dict = [self.items objectAtIndex:indexPath.row];
    [cell setContentData:dict];
    if (cell.tag == TAG_AVATAR_CELL) {
        [cell.imageCell setImage:self.person.avatar];
    }
    
    return cell;
}

#define FONT_SIZE 11.0f
#define CELL_CONTENT_WIDTH 222.0f
#define CELL_CONTENT_MARGIN 10.0f
#define CELL_HEIGHT_FIRST_LOAD 70.0f

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    CGFloat height = 0;
    
    // Get the text so we can measure it
    NSDictionary *dict = (NSDictionary *) [self.items objectAtIndex:indexPath.row];
    NSString *text = [dict objectForKey:@"textCell"];
    if ([dict objectForKey:@"sizeAmount"]) {
        height = [(NSNumber *)[dict objectForKey:@"sizeAmount"] intValue];
    }
        
    //UILabel *content = (UILabel *)[[(UITableViewCell *)[(UITableView *)self cellForRowAtIndexPath:indexPath] contentView] viewWithTag:1];
    //text = [items objectAtIndex:indexPath.row];
    
    // Get a CGSize for the width and, effectively, unlimited height
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    // Get the size of the text given the CGSize we just made as a constraint
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:NSLineBreakByCharWrapping];
    
    // Get the height of our measurement
    if (height < size.height) {
        height = size.height;
    }    
        
    if (self.fistLoadTableView && height > CELL_HEIGHT_FIRST_LOAD) {
        height = CELL_HEIGHT_FIRST_LOAD;
    }
    
    // return the height, with a bit of extra padding in
    return height + (CELL_CONTENT_MARGIN * 2);
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MEStaffDetailsCustomViewCell *cell = (MEStaffDetailsCustomViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.tag == TAG_EMAIL_CELL) {
        [self showComposer:@"Hi,\n Just test!"];
    } else if (cell.tag == TAG_SMS_CELL) {
        [self sendInAppSMS];        
    }
    
}


#pragma mark - Email composition

// Displays an email composition interface inside the application. Populates all the Mail fields.
- (void) displayComposerSheet:(NSString *)body {
	
	MFMailComposeViewController *tempMailCompose = [[MFMailComposeViewController alloc] init];
	
	tempMailCompose.mailComposeDelegate = self;
	
	[tempMailCompose setToRecipients:[NSArray arrayWithObject:self.person.userName]];
	//[tempMailCompose setCcRecipients:[NSArray arrayWithObject:@"ipad@me.com"]];
	[tempMailCompose setSubject:@"iPhone App recommendation"];
	[tempMailCompose setMessageBody:body isHTML:NO];
	
    tempMailCompose.view.alpha = 0.5;
    [self presentViewController:tempMailCompose animated:YES completion:^(void){
        [UIView animateWithDuration:0.3 animations:^{
            tempMailCompose.view.alpha = 1;
        }];
    }];
}

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			NSLog(@"Result: canceled");
			break;
		case MFMailComposeResultSaved:
			NSLog(@"Result: saved");
			break;
		case MFMailComposeResultSent:
			NSLog(@"Result: sent");
			break;
		case MFMailComposeResultFailed:
			NSLog(@"Result: failed");
			break;
		default:
			NSLog(@"Result: not sent");
			break;
	}
    
    self.view.alpha = 0.5;    
    [self dismissViewControllerAnimated:YES completion:^(void){
        [UIView animateWithDuration:0.3 animations:^{
            self.view.alpha = 1;
        }];
    }];
}

// Launches the Mail application on the device. Workaround
- (void)launchMailAppOnDevice:(NSString *)body{
	NSString *recipients = [NSString stringWithFormat:@"mailto:%@?subject=%@", self.person.userName, @"iPhone App recommendation"];
	NSString *mailBody = [NSString stringWithFormat:@"&body=%@", body];
	
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, mailBody];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

// Call this method and pass parameters
- (void)showComposer:(id)sender{
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil){
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail]){
			[self displayComposerSheet:sender];
		} else {
			[self launchMailAppOnDevice:sender];
		}
	} else {
		[self launchMailAppOnDevice:sender];
	}
}

#pragma mark - SMS composition

- (void)sendInAppSMS
{
	MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    
	if([MFMessageComposeViewController canSendText])
	{
		picker.body = @"Hello from Duy Nguyen";
		picker.recipients = [NSArray arrayWithObjects:self.person.contact, nil];
		picker.messageComposeDelegate = self;
        [self presentViewController:picker animated:YES completion:^(void){}];
	}
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    UIAlertView *alert;
    
	switch (result) {
		case MessageComposeResultCancelled:
			NSLog(@"Cancelled");
			break;
            
		case MessageComposeResultFailed:            
			alert = [[UIAlertView alloc] initWithTitle:@"MiniEvalApp" message:@"Unknown Error" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];            
			[alert show];
			break;
		case MessageComposeResultSent:
            
			break;
            
		default:
			break;
	}
    
    [self dismissViewControllerAnimated:YES completion:^(void){}];
}

@end

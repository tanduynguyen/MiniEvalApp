//
//  MEStaffDetailsTableViewController.m
//  MiniEvalApp
//
//  Created by viet on 1/23/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "MEStaffDetailsTableViewController.h"
#import "MEStaffDetailsCustomViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface MEStaffDetailsTableViewController ()

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
    
    // Use NSUserDefault to store the visit count for each person.
    // When a user is selected, increase visit count
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *staffs = [[NSMutableDictionary alloc] init];
    
    staffs = [[defaults objectForKey:STAFFS_KEY] mutableCopy];
    
    if ([staffs objectForKey:self.person.userId]) {
        id obj = [staffs objectForKey:self.person.userId];
        if ([obj isKindOfClass:[NSMutableDictionary class]]) {
            NSMutableDictionary *staff = [obj mutableCopy];
            self.person.visitedCount = [(NSNumber  *)[staff valueForKey:@"visitedCount"] unsignedIntegerValue]  + 1;
            [staff setObject:[NSNumber numberWithUnsignedInt:self.person.visitedCount] forKey:@"visitedCount"];
            
            [staffs setObject:staff forKey:self.person.userId];
        }
    }
    else {
        self.person.visitedCount = 1;
        NSMutableDictionary *staff = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithUnsignedInt:self.person.visitedCount], @"visitedCount",
                                      nil];
        
        [staffs setObject:staff forKey:self.person.userId];
    }
    
    [defaults setObject:staffs forKey:STAFFS_KEY];
    [defaults synchronize];
    
    
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


- (IBAction)addContact:(id)sender {
    NSLog(@"add Contact");
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
    return 5;
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
    
    
    switch (indexPath.row) {
        case 0:            
            [cell.imageCell setFrame:CGRectMake(4, 4, 64, 64)];
            if (self.person.image) {
#ifdef __MAC_OS_X_VERSION_MIN_REQUIRED
            [cell.imageCell setImage:self.person.profileImage];
#else
            [cell.imageCell setImageWithURL:[NSURL URLWithString:self.person.image] placeholderImage:[UIImage imageNamed:@"icon_profile.png"]];
#endif
            } else {
                [cell.imageCell setImage:[UIImage imageNamed:@"icon_profile.png"]];
            }
            
            cell.textCell.text = self.person.role;
            break;
            
        case 1:
            [cell.imageCell setImage:[UIImage imageNamed:@"icon_email.png"]];
            cell.textCell.text = self.person.userName;
            break;
            
        case 2:
            if (!self.person.contact) {
                [cell setHidden:YES];
                [cell setFrame:CGRectZero];
            } else {
                [cell.imageCell setImage:[UIImage imageNamed:@"icon_sms.png"]];
                cell.textCell.text = self.person.contact;
            }
            break;
            
        case 3:
            [cell.imageCell setImage:[UIImage imageNamed:@"icon_like.png"]];
            cell.textCell.text = self.person.like;
            break;
            
        case 4:
            [cell.imageCell setImage:[UIImage imageNamed:@"icon_dislike.png"]];
            cell.textCell.text = self.person.dislike;
            break;
        default:
            break;
    }
    
    
    [cell.textCell setNumberOfLines:0];
    [cell.textCell setLineBreakMode:NSLineBreakByWordWrapping];
    
    return cell;
}



#define FONT_SIZE 11.0f
#define CELL_CONTENT_WIDTH 222.0f
#define CELL_CONTENT_MARGIN 10.0f

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    CGFloat height = 0;
    
    NSString *text = @"";
    
    // Get the text so we can measure it
    
    switch (indexPath.row) {
        case 0:
            text = self.person.role;
            break;
            
        case 1:
            text = self.person.userName;
            break;
            
        case 2:
            text = self.person.contact;
            break;
            
        case 3:
            text = self.person.like;
            break;
            
        case 4:
            text = self.person.dislike;
            break;
    }
    
    //UILabel *content = (UILabel *)[[(UITableViewCell *)[(UITableView *)self cellForRowAtIndexPath:indexPath] contentView] viewWithTag:1];
    //text = [items objectAtIndex:indexPath.row];
    
    // Get a CGSize for the width and, effectively, unlimited height
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    // Get the size of the text given the CGSize we just made as a constraint
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:NSLineBreakByCharWrapping];
    
    // Get the height of our measurement
    if (indexPath.row == 0 && size.height < 64) {
        size.height = 54;
    }
    height = size.height;    
    
    
    // return the height, with a bit of extra padding in
    return height + (CELL_CONTENT_MARGIN * 2);
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end

//
//  MEExtendStaffTableViewController.m
//  MiniEvalApp
//
//  Created by viet on 1/21/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "MEExtendStaffTableViewController.h"

@interface MEExtendStaffTableViewController ()

@end

@implementation MEExtendStaffTableViewController

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

#define STAFFS_KEY @"MEExtendStaffTableViewController.2359Staffs"

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;    
    
    self.title = [NSString stringWithFormat:@"%@ - %@", self.navigationItem.title, self.person.name];    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];    
    
    NSDictionary *staffs = [[NSDictionary alloc] init];      
    
    bool find;
    
    for (id obj in [defaults objectForKey:STAFFS_KEY]) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
           NSDictionary *staff = obj;
            if ([self.person.userId isEqualToString:[staff valueForKey:@"userId"]]) {
                self.person.visitedCount = [(NSNumber *)[staff valueForKey:@"visited"] unsignedIntValue] + 1;
                find = true;
            }            
            
            [staffs setValue:self.person forKey:self.person.userId];
        }
    }
    
    if (!find) {
        self.person.visitedCount = 1;
        NSMutableDictionary *staff = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       self.person.name, @"name", nil];
        [staffs setValue:self.person forKey:self.person.userId];
    }
    
    [defaults setObject:staffs forKey:STAFFS_KEY];
    [defaults synchronize];
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
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NSString *cellIdentifier = @"PersonDetails";
    
    cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Visited";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", self.person.visitedCount];
            break;
            
        case 1:
            cell.textLabel.text = @"Name";
            cell.detailTextLabel.text = self.person.name;
            break;
            
        case 2:
            cell.textLabel.text = @"User Name";
            cell.detailTextLabel.text = self.person.userName;
            break;
            
        case 3:
            cell.textLabel.text = @"Role";
            cell.detailTextLabel.text = self.person.role;
            break;
            
        case 4:
            cell.textLabel.text = @"Like";
            cell.detailTextLabel.text = self.person.like;
            break;
            
        case 5:
            cell.textLabel.text = @"Dislike";
            cell.detailTextLabel.text = self.person.dislike;
            break;
            
        case 6:
            cell.textLabel.text = @"Time Stamp";
            // NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            //[dateFormatter setDateFormat:@"dd/mm/YYYY"];
            cell.detailTextLabel.text = (NSString *)self.person.timeStamp;
            break;
    }
    
    [cell.detailTextLabel setNumberOfLines:0];
    [cell.detailTextLabel setLineBreakMode:NSLineBreakByWordWrapping];
    
    return cell;

}


#define FONT_SIZE 15.0f
#define CELL_CONTENT_WIDTH 200.0f
#define CELL_CONTENT_MARGIN 10.0f

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    CGFloat height = tableView.rowHeight;
    
    NSString *text = @"";
    
    // Get the text so we can measure it
    
    switch (indexPath.row) {
        case 1:
            text = self.person.name;
            break;
            
        case 2:
            text = self.person.userName;
            break;
            
        case 3:
            text = self.person.role;
            break;
            
        case 4:
            text = self.person.like;
            break;
            
        case 5:
            text = self.person.dislike;
            break;
            
        case 6:
            text = (NSString *)self.person.timeStamp;
            break;
    }
    
    //UILabel *content = (UILabel *)[[(UITableViewCell *)[(UITableView *)self cellForRowAtIndexPath:indexPath] contentView] viewWithTag:1];
    //text = [items objectAtIndex:indexPath.row];
    
    // Get a CGSize for the width and, effectively, unlimited height
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    // Get the size of the text given the CGSize we just made as a constraint
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:NSLineBreakByCharWrapping];
    
    // Get the height of our measurement
    if (size.height > height) {
        height = size.height;
    }
    
    
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

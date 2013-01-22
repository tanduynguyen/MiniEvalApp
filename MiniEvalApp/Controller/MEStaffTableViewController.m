//
//  MEStaffTableViewController.m
//  MiniEvalApp
//
//  Created by viet on 1/21/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "MEStaffTableViewController.h"
#import "MEAppAPIClient.h"
#import "MEPerson.h"
#include "MEExtendStaffTableViewController.h"
#import "MEStaffViewCell.h"

@interface MEStaffTableViewController ()

@property (strong) NSMutableArray *results;
@property (strong, nonatomic) NSMutableArray *filteredArray;

@end

@implementation MEStaffTableViewController

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

    [[MEAppAPIClient sharedInstance] getPath:kAppAPIPath parameters:nil
                                     success:^(AFHTTPRequestOperation *operation, id response) {
                                         NSLog(@"Response: %@", response);
                                         
                                         NSMutableArray *results = [NSMutableArray array];
                                         if ([response isKindOfClass:[NSData class]]) {
                                             NSError *error;
                                             
                                             NSDictionary *json = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&error];
                                             
                                             if (error) {
                                                 NSLog(@"Error parsing JSON: %@", error);
                                                 return;
                                             }
                                             
                                             for (id obj in json)
                                             {
                                                 if ([obj isKindOfClass:[NSDictionary class]]) {
                                                     MEPerson *person = [[MEPerson alloc] initWithDictionary:(NSDictionary *)obj];
                                                     [results addObject:person];
                                                 }
                                             }
                                             self.results = results;
                                             
                                             self.filteredArray = [NSMutableArray arrayWithCapacity:[self.results count]];
                                             
                                             [self.tableView reloadData];
                                             self.tableView.scrollEnabled = YES;
                                         }
                                     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         NSLog(@"Error fetching persons!");
                                         NSLog(@"%@", error);
                                     }];

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
    int rows = 0;
    
    if (tableView == self.tableView) {
        rows = self.results.count;
    } else if(tableView == self.searchDisplayController.searchResultsTableView){
        rows = self.filteredArray.count;
    }
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Person Item";
    MEStaffViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[MEStaffViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }

    // Configure the cell...
    id obj = [self.results objectAtIndex:indexPath.row];
    
    if(tableView == self.searchDisplayController.searchResultsTableView){
        obj = [self.filteredArray objectAtIndex:indexPath.row];
    }
    
    if ([obj isKindOfClass:[MEPerson class]]) {
        MEPerson *person = obj;
        cell.nameLabel.text = person.name;
        cell.userNameLabel.text = person.userName;
        cell.avatar.image = [UIImage imageNamed:@"person.png"];
        
        [cell.textLabel setAutoresizesSubviews:NO];
    }

    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[MEExtendStaffTableViewController class]]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        MEPerson *person = [self.results objectAtIndex:indexPath.row];
        
        if ([sender isKindOfClass:[UITableViewCell class]]){
            UITableViewCell *currentCell = sender;
            
            if ([currentCell.superview isEqual:self.searchDisplayController.searchResultsTableView]) {
                person = (MEPerson *)[self.filteredArray objectAtIndex:indexPath.row];
            }
        }
        
        MEExtendStaffTableViewController *destinationVC = (MEExtendStaffTableViewController *)segue.destinationViewController;
        destinationVC.person = person;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2) {
        cell.backgroundColor = UIColorFromRGB(kLightOrganColor, 1.0);
    }
}

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

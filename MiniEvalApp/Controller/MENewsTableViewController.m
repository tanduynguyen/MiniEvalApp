//
//  MENewsTableViewController.m
//  MiniEvalApp
//
//  Created by viet on 1/21/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "MENewsTableViewController.h"
#import "MEAppAPIClient.h"
#import "MENews.h"
#import "MENewsDetailsTableViewController.h"
#import "SVPullToRefresh.h"

@interface MENewsTableViewController ()

@property (strong, nonatomic) NSMutableArray *results;
@property (strong, nonatomic) NSMutableArray *filteredArray;

@end

@implementation MENewsTableViewController

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
    
    
    NSURL *url = [NSURL URLWithString:kAppJSONPath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
       
    __weak MENewsTableViewController *weakSelf = self;
    
    // setup pull-to-refresh
    [self.tableView addPullToRefreshWithActionHandler:^{
        int64_t delayInSeconds = 0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            AFJSONRequestOperation *operation = [AFJSONRequestOperation
                                                 JSONRequestOperationWithRequest:request
                                                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, id json) {
                                                     json = [[[json valueForKeyPath:@"responseData"] valueForKeyPath:@"feed"] valueForKeyPath:@"entries"];
                                                     NSMutableArray *results = [NSMutableArray array];
                                                     for (id obj in json)
                                                     {
                                                         if ([obj isKindOfClass:[NSDictionary class]]) {
                                                             MENews *news = [[MENews alloc] initWithDictionary:(NSDictionary *)obj];
                                                             [results addObject:news];
                                                         }
                                                     }
                                                     
                                                     weakSelf.results = results;
                                                     
                                                     weakSelf.filteredArray = [NSMutableArray arrayWithCapacity:[weakSelf.results count]];
                                                     
                                                     [weakSelf.tableView reloadData];
                                                     weakSelf.tableView.scrollEnabled = YES;
                                                     
                                                     [weakSelf.tableView.pullToRefreshView stopAnimating];
                                                 } failure:nil];
            
            [operation start];
        });
    }];
    
    
    // trigger the refresh manually at the end of viewDidLoad
    [self.tableView triggerPullToRefresh];
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
    static NSString *CellIdentifier = @"News Item";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    id obj = [self.results objectAtIndex:indexPath.row];
    
    if(tableView == self.searchDisplayController.searchResultsTableView){
        obj = [self.filteredArray objectAtIndex:indexPath.row];
    }
    
    if ([obj isKindOfClass:[MENews class]]) {
        MENews *news = obj;
        cell.textLabel.text = news.title;
        cell.detailTextLabel.text = news.publishedDate;
    }

    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[MENewsDetailsTableViewController class]]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        MENews *news = [self.results objectAtIndex:indexPath.row];
        
        if ([sender isKindOfClass:[UITableViewCell class]]){
            UITableViewCell *currentCell = sender;
            
            if ([currentCell.superview isEqual:self.searchDisplayController.searchResultsTableView]) {
                news = (MENews *)[self.filteredArray objectAtIndex:indexPath.row];
            }
        }
        
        MENewsDetailsTableViewController *destinationVC = (MENewsDetailsTableViewController *)segue.destinationViewController;
        destinationVC.news = news;
    }
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2) {
        cell.backgroundColor = UIColorFromRGB(kLightOrganColor);
    }
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

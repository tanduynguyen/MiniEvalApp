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
#import "MEStaffCustomViewCell.h"
#import "SVPullToRefresh.h"

@interface MEStaffTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *results;
@property (strong, nonatomic) NSMutableArray *filteredArray;
@property (nonatomic) NSUInteger highestVisitedCount;

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
    
    __weak MEStaffTableViewController *weakSelf = self;
    
    // setup pull-to-refresh
    [self.tableView addPullToRefreshWithActionHandler:^{        
        int64_t delayInSeconds = 0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
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
                                                     
                                                     weakSelf.results = results;                                                     
                                                     weakSelf.filteredArray = [NSMutableArray arrayWithCapacity:[weakSelf.results count]];
                                                     
                                                     [weakSelf reloadInformation];      
                                                     
                                                     weakSelf.tableView.scrollEnabled = YES;                                                     
                                                     [weakSelf.tableView.pullToRefreshView stopAnimating];
                                                 }
                                             }
                                             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                 NSLog(@"Error fetching persons!");
                                                 NSLog(@"%@", error);
                                             }]; 

            
        });
    }];
    
    
    // setup infinite scrolling
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        
        int64_t delayInSeconds = 0.2;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            MEPerson *p = [[MEPerson alloc] init];
            
            p.name = @"TEST";            
            NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
            [DateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            p.userName = [DateFormatter stringFromDate:[NSDate date]];
            
            [weakSelf.results addObject:p];
            
            [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.results.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
            
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
        });
    }];
    
    // trigger the refresh manually at the end of viewDidLoad
    [self.tableView triggerPullToRefresh];

}

- (void)reloadInformation
{
    // To have an indicator which people has the highest visit count (eg. put a star next to person’s name)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *staffs = [[NSMutableDictionary alloc] init];
    
    staffs = [[defaults objectForKey:STAFFS_KEY] mutableCopy];
    
    self.highestVisitedCount = 0;
    
    for (id obj in self.results) {
        MEPerson *person = (MEPerson *) obj;
        if ([staffs objectForKey:person.userId]) {
            id obj = [staffs objectForKey:person.userId];
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSDictionary *staff = obj;
                person.visitedCount = [(NSNumber  *)[staff valueForKey:@"visitedCount"] unsignedIntegerValue];
                
                if (self.highestVisitedCount < person.visitedCount) {
                    self.highestVisitedCount = person.visitedCount;
                }
            }
        }
    }
    
    [self.tableView reloadData];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadInformation];
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
    MEStaffCustomViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[MEStaffCustomViewCell alloc] initWithStyle:UITableViewCellStyleDefault
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
        
        if (person.visitedCount == self.highestVisitedCount) {
            cell.starImage.image = [UIImage imageNamed:@"star.png"];
//            CGRect myFrame = cell.nameLabel.frame;
//            myFrame.size.width -= cell.starImage.frame.size.width;
//            cell.nameLabel.frame = myFrame;
            cell.starImage.hidden = NO;
        } else {
            cell.starImage.hidden = YES;
        }
        
        [cell.nameLabel setNumberOfLines:0];
        [cell.userNameLabel setNumberOfLines:0];
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

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2) {
        cell.backgroundColor = UIColorFromRGB(kLightOrganColor);
    }
}



@end

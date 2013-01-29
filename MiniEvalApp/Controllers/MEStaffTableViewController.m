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
#import "MEStaffDetailsTableViewController.h"
#import "MEStaffCustomViewCell.h"
#import "SVPullToRefresh.h"
#import "ADLivelyTableView.h"

@interface MEStaffTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *results;
@property (strong, nonatomic) NSMutableArray *filteredArray;

- (void)reload:(id)sender;

@end

@implementation MEStaffTableViewController{
@private
    NSMutableArray *persons;
    
    __strong UIActivityIndicatorView *_activityIndicatorView;
}

- (void)reload:(id)sender {
    [_activityIndicatorView startAnimating];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    __weak MEStaffTableViewController *weakSelf = self;
    __weak UIActivityIndicatorView *spinner = _activityIndicatorView;
    
    // setup pull-to-refresh
    [self.tableView addPullToRefreshWithActionHandler:^{
        int64_t delayInSeconds = 0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [MEPerson globalTimelineContactsWithBlock:^(NSMutableArray *results, NSError *error) {
                if (error) {
                    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
                } else {                
                    weakSelf.results = results;
                    weakSelf.filteredArray = [NSMutableArray arrayWithCapacity:[weakSelf.results count]];
                    
                    [weakSelf reloadInformation];
                    
                    weakSelf.tableView.scrollEnabled = YES;
                    [weakSelf.tableView.pullToRefreshView stopAnimating];
                }
                
               [spinner stopAnimating];
                weakSelf.navigationItem.rightBarButtonItem.enabled = YES;
            }];
            
        });
    }];
    
    // setup infinite scrolling
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        
        int64_t delayInSeconds = 0.2;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            if (self.results.count > 0) {
                MEPerson *p = [[MEPerson alloc] init];
                
                NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
                [DateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
                p.name = [DateFormatter stringFromDate:[NSDate date]];
                
                [weakSelf.results addObject:p];
                
                [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.results.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
            }
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
        });
    }];
    
    // trigger the refresh manually at the end of viewDidLoad
    [self.tableView triggerPullToRefresh];
}

#pragma mark - UIViewController

- (void)loadView {
    [super loadView];
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _activityIndicatorView.hidesWhenStopped = YES;
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
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_activityIndicatorView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reload:)];
    
    self.tableView.rowHeight = 72.0f;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    [self reload:nil];   
}


- (void)viewDidUnload
{
    _activityIndicatorView = nil;    
    
    [super viewDidUnload];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.results];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:STAFFS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)reloadInformation
{
    // To have an indicator which people has the highest visit count (eg. put a star next to person’s name)    
    
    NSData *personsData = [[NSUserDefaults standardUserDefaults] objectForKey:STAFFS_KEY];
    NSMutableArray *results = [[NSMutableArray alloc] init];
    results = [NSKeyedUnarchiver unarchiveObjectWithData:personsData];    
    
    
    for (int i = 0; i < self.results.count; i++) {
        MEPerson *person = [self.results objectAtIndex:i];
        NSPredicate *pred = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"SELF.userId = '%@'", person.userId]];
        NSArray *filtered = [results filteredArrayUsingPredicate:pred];
        if (filtered.count > 0) {
            MEPerson *tmp = [filtered objectAtIndex:0];
            person.visitedCount = tmp.visitedCount;
        }
    }
    
    [MEPerson findHighestVisitedCount:self.results];
    
    NSArray * transforms = [NSArray arrayWithObjects:ADLivelyTransformFan, ADLivelyTransformCurl, ADLivelyTransformFade, ADLivelyTransformHelix, ADLivelyTransformWave, nil];
    ADLivelyTableView * livelyTableView = (ADLivelyTableView *)self.tableView;
    livelyTableView.initialCellTransformBlock = nil;
    [livelyTableView reloadData];
    livelyTableView.initialCellTransformBlock = [transforms objectAtIndex:random() % [transforms count]];
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
    MEPerson *person = [self.results objectAtIndex:indexPath.row];
    
    if(tableView == self.searchDisplayController.searchResultsTableView){
        person = [self.filteredArray objectAtIndex:indexPath.row];
    }
    
    cell.person = person;
    
    

    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[MEStaffDetailsTableViewController class]]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        MEPerson *person = [self.results objectAtIndex:indexPath.row];
        
        if ([sender isKindOfClass:[MEStaffCustomViewCell class]]){
            MEStaffCustomViewCell *currentCell = sender;
            
            if ([currentCell.superview isEqual:self.searchDisplayController.searchResultsTableView]) {
                person = (MEPerson *)[self.filteredArray objectAtIndex:indexPath.row];
            }
            
            person.avatar = currentCell.avatar.image;
        }
        
        MEStaffDetailsTableViewController *destinationVC = (MEStaffDetailsTableViewController *)segue.destinationViewController;
        destinationVC.person = person;      
        
    }
}





@end

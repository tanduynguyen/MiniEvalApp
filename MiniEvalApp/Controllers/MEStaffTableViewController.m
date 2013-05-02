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

@interface MEStaffTableViewController () <
UITableViewDelegate,
UITableViewDataSource,
UITabBarControllerDelegate
>

@property (strong, nonatomic) NSMutableArray *results;
@property (strong, nonatomic) NSMutableArray *filteredArray;

- (void)reload:(id)sender;

@end

@implementation MEStaffTableViewController{
@private
    __strong UIActivityIndicatorView *_activityIndicatorView;
}

- (void)reload:(id)sender {
    __weak MEStaffTableViewController *weakSelf = self;
    __weak UIActivityIndicatorView *spinner = _activityIndicatorView;
    
    // setup pull-to-refresh
    [self.tableView addPullToRefreshWithActionHandler:^{
        int64_t delayInSeconds = 0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [spinner startAnimating];
            weakSelf.navigationItem.rightBarButtonItem.enabled = NO;
            [weakSelf.tableView setTableHeaderView:nil];
            
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
    
    
    // trigger the refresh manually at the end of viewDidLoad
    [self.tableView triggerPullToRefresh];
}

-(void)searchStuff:(id)sender {
    if (![self.tableView tableHeaderView]) {
        [self.tableView setTableHeaderView:[[self searchDisplayController] searchBar]];
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    } else {
        [self.tableView setTableHeaderView:nil];
    }
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
    
    UIBarButtonItem *refeshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reload:)];
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchStuff:)];
    
    self.navigationItem.rightBarButtonItems = @[refeshButton, searchButton];
    
    [self.tableView setTableHeaderView:nil];
    
    self.tableView.rowHeight = 72.0f;
    self.tableView.separatorColor = [UIColor clearColor];
    
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
    if (personsData) {
        NSMutableArray *results = [[NSMutableArray alloc] init];
        results = [NSKeyedUnarchiver unarchiveObjectWithData:personsData];
        
        for (int i = 0; i < self.results.count; i++) {
            MEPerson *person = (self.results)[i];
            NSPredicate *pred = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"SELF.userId = '%@'", person.userId]];
            NSArray *filtered = [results filteredArrayUsingPredicate:pred];
            if (filtered.count > 0) {
                MEPerson *tmp = filtered[0];
                person.visitedCount = tmp.visitedCount;
            }
        }
    }
    
    [MEPerson findHighestVisitedCount:self.results];
    
    //set up ADLivelyTableView
    NSArray * transforms = @[ADLivelyTransformFan, ADLivelyTransformCurl, ADLivelyTransformFade, ADLivelyTransformHelix, ADLivelyTransformWave];
    ADLivelyTableView * livelyTableView = (ADLivelyTableView *)self.tableView;
    livelyTableView.initialCellTransformBlock = nil;
    [livelyTableView reloadData];
    livelyTableView.initialCellTransformBlock = transforms[random() % [transforms count]];
    
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
    MEStaffCustomViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[MEStaffCustomViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:CellIdentifier];
    }
    
    MEPerson *person = (self.results)[indexPath.row];
    
    if(tableView == self.searchDisplayController.searchResultsTableView){
        person = (self.filteredArray)[indexPath.row];
        CGRect customFrame = cell.avatar.frame;
        customFrame.size.width /= 1.5;
        customFrame.size.height /= 1.5;
        [cell.avatar setFrame:customFrame];
    }
    
    [cell configureWithData:person atIndex:indexPath];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(MEStaffCustomViewCell *)sender
{
    if (![segue.destinationViewController isKindOfClass:[MEStaffDetailsTableViewController class]])
        return;
    
    NSIndexPath *indexPath = [[self.tableView indexPathsForSelectedRows] lastObject];
    MEPerson *person = (self.results)[indexPath.row];
    
    if ([sender.superview isEqual:self.searchDisplayController.searchResultsTableView]) {
        indexPath = [[self.searchDisplayController.searchResultsTableView indexPathsForSelectedRows] lastObject];
        person = (self.filteredArray)[indexPath.row];
    }
    
    //increase the visited Count
    person.visitedCount = [[NSNumber alloc] initWithUnsignedInt:[person.visitedCount intValue] + 1];
    person.avatar = sender.avatar.image;
    
    MEStaffDetailsTableViewController *destinationVC = (MEStaffDetailsTableViewController *)segue.destinationViewController;
    destinationVC.person = person;
}

#pragma mark Content Filtering
- (void)filterContentForSearchText:(NSString*)searchText
                            scope:(NSString*)scope {
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [self.filteredArray removeAllObjects];
    
    NSString *searchField = ([scope isEqualToString:@"Email"] ? @"userName" : @"name");
    
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.%@ contains[c] %@", searchField, searchText];
    
    self.filteredArray = [NSMutableArray arrayWithArray:[self.results filteredArrayUsingPredicate:predicate]];
}


#pragma mark - UISearchDisplayController Delegate Methods
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [self.searchDisplayController.searchBar scopeButtonTitles][[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [self.searchDisplayController.searchBar scopeButtonTitles][searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
	[self.tableView setTableHeaderView:nil];
}


@end

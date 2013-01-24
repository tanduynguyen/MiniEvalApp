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

@interface MEStaffTableViewController () <UITableViewDelegate, UITableViewDataSource, UITabBarControllerDelegate>

@property (strong, nonatomic) NSMutableArray *results;
@property (strong, nonatomic) NSMutableArray *filteredArray;
@property (nonatomic) NSUInteger highestVisitedCount;

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
    
    [self reload:nil];
        
    UIImage *imgInfo = [UIImage imageNamed:@"icon_info.png"];
    UIImage *imgInfoHighlight = [UIImage imageNamed:@"icon_info_selected.png"];
    
    UIImage *imgContacts = [UIImage imageNamed:@"icon_contacts.png"];
    UIImage *imgContactsHighlight = [UIImage imageNamed:@"icon_contacts_selected.png"];
    
    UIImage *imgSettings = [UIImage imageNamed:@"middle_button.png"];
    
    
    UITabBar *tabBar = self.tabBarController.tabBar;
    
    UITabBarItem *firstTabItem = [tabBar.items objectAtIndex:0];
    UITabBarItem *secondTabItem = [tabBar.items objectAtIndex:1];
    UITabBarItem *thirdTabItem = [tabBar.items objectAtIndex:2];
    
    [thirdTabItem setFinishedSelectedImage:imgInfoHighlight withFinishedUnselectedImage:imgInfo];
    [firstTabItem setFinishedSelectedImage:imgContactsHighlight withFinishedUnselectedImage:imgContacts];
    [secondTabItem setFinishedSelectedImage:imgSettings withFinishedUnselectedImage:imgSettings];
    
    [self.tabBarController setDelegate:self];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {

    NSArray *tabViewControllers = tabBarController.viewControllers;
    UIView * fromView = tabBarController.selectedViewController.view;
    UIView * toView = viewController.view;
    
    if (fromView == toView)
        return false;
    
    NSUInteger fromIndex = [tabViewControllers indexOfObject:tabBarController.selectedViewController];
    NSUInteger toIndex = [tabViewControllers indexOfObject:viewController];
    
    [UIView transitionFromView:fromView
                        toView:toView
                      duration:0.5
                       options: toIndex > fromIndex ? UIViewAnimationOptionTransitionFlipFromLeft : UIViewAnimationOptionTransitionFlipFromRight
                    completion:^(BOOL finished) {
                        if (finished) {
                            tabBarController.selectedIndex = toIndex;
                        }
                    }];
    return true;
}

- (void)viewDidUnload {
    _activityIndicatorView = nil;
    
    [super viewDidUnload];
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
        cell.person = obj;
        
        if (person.visitedCount == self.highestVisitedCount) {
            cell.starImage.hidden = NO;
        } else {
            cell.starImage.hidden = YES;
        }
    }

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
            
            person.avtar = currentCell.avatar.image;
        }
        
        MEStaffDetailsTableViewController *destinationVC = (MEStaffDetailsTableViewController *)segue.destinationViewController;
        destinationVC.person = person;
    }
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2) {
        cell.backgroundColor = UIColorFromRGB(kLightOrganColor);
    }
}



@end

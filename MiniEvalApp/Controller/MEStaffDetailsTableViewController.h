//
//  MEStaffDetailsTableViewController.h
//  MiniEvalApp
//
//  Created by viet on 1/23/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MEPerson.h"

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface MEStaffDetailsTableViewController : UITableViewController <ABNewPersonViewControllerDelegate>

@property (strong, nonatomic) MEPerson *person;

@end

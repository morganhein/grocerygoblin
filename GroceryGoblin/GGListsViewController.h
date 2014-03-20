//
//  GGListsViewController.h
//  GroceryGoblin
//
//  Created by Morgan on 3/20/14.
//  Copyright (c) 2014 MorganJoshEvan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "GGTableViewCellDelegate.h"
#import "GGShoppingList.h"
#import "GGSingleton.h"

@interface GGListsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, GGTableViewCellDelegate>
@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) NSMutableArray *lists;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *createNewList;
- (IBAction)createNewList:(UITextField *)sender;
@property (strong, nonatomic) GGShoppingList *nextList;
@property (strong, nonatomic) GGSingleton *singleton;
@end

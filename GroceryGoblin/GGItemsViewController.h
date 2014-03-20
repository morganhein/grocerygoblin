//
//  GGViewController.h
//  GroceryGoblin
//
//  Created by Morgan on 1/18/14.
//  Copyright (c) 2014 MorganJoshEvan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "GGTableViewCellDelegate.h"
#import "GGShoppingList.h"
#import "GGSingleton.h"

@interface GGItemsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, GGTableViewCellDelegate>
@property (strong, nonatomic) PFUser *user;
@property (weak, nonatomic) IBOutlet UITableView *itemsTableView;
@property (weak, nonatomic) IBOutlet UITextField *createNewItemTextField;
@property (strong, nonatomic) NSMutableArray *displayList;
@property (strong, nonatomic) GGSingleton *singleton;
@property (strong, nonatomic) PFObject *list;
@property (strong, nonatomic) GGShoppingList *currentList;

//these are objects for parse stuff
@property (nonatomic, strong) NSMutableArray *items;
- (IBAction)createNewItemTextField:(UITextField *)sender;

@end

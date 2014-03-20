//
//  GGViewController.h
//  GroceryGoblin
//
//  Created by Morgan on 1/18/14.
//  Copyright (c) 2014 MorganJoshEvan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGTableViewCellDelegate.h"
#import <Parse/Parse.h>

@interface GGViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, GGTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *itemsTableView;
@property (weak, nonatomic) IBOutlet UITextField *createNewItemTextField;
@property (strong, nonatomic) NSMutableArray *displayList;


//these are objects for parse stuff
@property (nonatomic, strong) PFObject *list;
@property (nonatomic, strong) NSMutableArray *items;

- (IBAction)createNewItemTextField:(UITextField *)sender;

@end

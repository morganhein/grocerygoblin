//
//  GGViewController.h
//  GroceryGoblin
//
//  Created by Morgan on 1/18/14.
//  Copyright (c) 2014 MorganJoshEvan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGTableViewCellDelegate.h"

@interface GGViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, GGTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *itemsTableView;
@property (weak, nonatomic) IBOutlet UITextField *createNewItemTextField;
- (IBAction)createNewItemTextField:(UITextField *)sender;

@end

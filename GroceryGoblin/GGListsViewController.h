//
//  GGListsViewController.h
//  GroceryGoblin
//
//  Created by Morgan on 3/20/14.
//  Copyright (c) 2014 MorganJoshEvan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>



@interface GGListsViewController : UIViewController
{
    PFUser *passedUser;
}
@property (weak, nonatomic) PFUser *user;
@property (weak, nonatomic) PFUser *passedUser;
@property (strong, nonatomic) NSMutableArray *lists;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

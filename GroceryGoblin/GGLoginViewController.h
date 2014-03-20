//
//  GGLoginViewController.h
//  GroceryGoblin
//
//  Created by Morgan on 3/19/14.
//  Copyright (c) 2014 MorganJoshEvan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGListsViewController.h"
#import <Parse/Parse.h>

@interface GGLoginViewController : UIViewController {
    GGListsViewController *listsViewController;
}
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) PFUser *user;
@end

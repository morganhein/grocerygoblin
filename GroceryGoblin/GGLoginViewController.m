//
//  GGLoginViewController.m
//  GroceryGoblin
//
//  Created by Morgan on 3/19/14.
//  Copyright (c) 2014 MorganJoshEvan. All rights reserved.
//

#import "GGLoginViewController.h"
#import <Parse/Parse.h>
#import "GGListsViewController.h"

@interface GGLoginViewController ()

@end

@implementation GGLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.passWord.delegate = (id)self;
    self.userName.delegate= (id)self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButton:(UIButton *)sender {
    PFUser *user = [PFUser user];
    user = [PFUser logInWithUsername:self.userName.text password:self.passWord.text];
    if (user) {
        NSLog(@"Success");
        listsViewController = [[GGListsViewController alloc] initWithNibName:nil bundle:Nil];
        listsViewController.passedUser = user;
        [self.view addSubview:listsViewController.view];
//self.listsViewController = [[GGListsViewController alloc] init];
//        [self presentViewController:self.listsViewController animated:YES completion:nil];
//        [self presentViewController:self.listsViewController animated:YES completion:nil];
    } else {
        NSLog(@"Error");
    }
}

- (IBAction)newUserButton:(UIButton *)sender {
    
    PFUser *user = [PFUser user];
    user.username = self.userName.text;	
    user.password = self.passWord.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"Worked");
            // Hooray! Let them use the app now.
        } else {
            NSString *errorString = [error userInfo][@"error"];
            NSLog(errorString);
            // Show the errorString somewhere and let the user try again.
        }
    }];
    NSLog(@"Trying to add new user");
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}
@end

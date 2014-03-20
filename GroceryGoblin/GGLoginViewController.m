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
#import "GGSingleton.h"

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

//making the login button in this method
- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor lightGrayColor];
	// Do any additional setup after loading the view.
    self.passWord.delegate = (id)self;
    self.userName.delegate= (id)self;
    UIFont *buttonFont = [UIFont fontWithName:@"Noteworthy-Bold" size:17.0];
    UIColor *buttonColorDefault = [UIColor colorWithRed:90.0f/255.0f green:90.0f/255.0f blue:90.0f/255.0f alpha:1.0];
    UIColor *buttonColorHighlight = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0];
    UIImage *btn = [UIImage imageNamed:@"Login Blue.png"];
    UIImage *btnh = [UIImage imageNamed:@"Login Blue.png"];
    
    
    UIButton *aboutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [aboutBtn addTarget:self action:@selector(showListsPage) forControlEvents:UIControlEventTouchUpInside];
    //[aboutBtn setTitle:@"Login" forState:UIControlStateNormal];
    [aboutBtn setFrame:CGRectMake(120.0, 270.0, 80.0, 35.0)];
    [aboutBtn setBackgroundImage:btn forState:UIControlStateNormal];
    [aboutBtn setBackgroundImage:btnh forState:UIControlStateHighlighted];
    [aboutBtn.titleLabel setFont:buttonFont];
    [aboutBtn setTitleColor:buttonColorDefault forState:UIControlStateNormal];
    [aboutBtn setTitleColor:buttonColorHighlight forState:UIControlStateHighlighted];
    [self.view addSubview:aboutBtn];
    
    UIImage *newbtn = [UIImage imageNamed:@"Sign up free.png"];
    UIImage *newbtnh = [UIImage imageNamed:@"Sign up free.png"];
    UIButton *newuser = [UIButton buttonWithType:UIButtonTypeCustom];
    [newuser addTarget:self action:@selector(newuserPage) forControlEvents:UIControlEventTouchUpInside];
    //[aboutBtn setTitle:@"Login" forState:UIControlStateNormal];
    [newuser setFrame:CGRectMake(103.0, 330.0, 120.0, 30.0)];
    [newuser setBackgroundImage:newbtn forState:UIControlStateNormal];
    [newuser setBackgroundImage:newbtnh forState:UIControlStateHighlighted];
    [newuser.titleLabel setFont:buttonFont];
    [newuser setTitleColor:buttonColorDefault forState:UIControlStateNormal];
    [newuser setTitleColor:buttonColorHighlight forState:UIControlStateHighlighted];
    //displays the buttons
    [self.view addSubview:newuser];

    
}

- (void) newuserPage {
    PFUser *user = [PFUser user];
    user.username = self.userName.text;
    user.password = self.passWord.text;
    NSLog(@"Trying to add new user");
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [self showListsPage];
        } else {
            NSString *errorString = [error userInfo][@"error"];
//            NSLog(errorString);
            // Show the errorString somewhere and let the user try again.
        }
    }];
}

//this runs the button I made, the green login button
- (void)showListsPage
{
    PFUser *user = [PFUser user];
    user = [PFUser logInWithUsername:self.userName.text password:self.passWord.text];
    if (user) {
        NSLog(@"Success");
        GGSingleton *singletonData = [GGSingleton sharedData];
        [singletonData.items setObject:user forKey:@"user"];
        [self performSegueWithIdentifier:@"toLists" sender:self];

     } else {
         NSLog(@"Error");
     }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toLists"]) {
        GGListsViewController *con = (GGListsViewController *)segue.destinationViewController;
//        con.user = self.user;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}
@end

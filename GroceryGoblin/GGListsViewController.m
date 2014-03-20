//
//  GGListsViewController.m
//  GroceryGoblin
//
//  Created by Morgan on 3/20/14.
//  Copyright (c) 2014 MorganJoshEvan. All rights reserved.
//

#import "GGListsViewController.h"
#import "GGCell.h"
#import "GGShoppingList.h"

@interface GGListsViewController ()

@end

@implementation GGListsViewController


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
    self.user = self.passedUser;
    PFQuery *query = [PFQuery queryWithClassName:@"ShoppingList"];
    [query whereKey:@"users" equalTo:self.user.objectId];
    
    self.lists = [[NSMutableArray alloc] init];
    
    NSArray *tempList = [query findObjects];
    for(PFObject *pfList in tempList){
        NSLog(@"Hey, here's a list! %@", pfList.objectId);
        GGShoppingList *list = [[GGShoppingList alloc] initFromObject:pfList];
        [self.lists addObject:list];
    }
}

//    self.lists = [query findObjects];

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lists.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ident = @"cell";
    GGCell *cell = [tableView dequeueReusableCellWithIdentifier:ident forIndexPath:indexPath];
    int index = [indexPath row];
    GGShoppingList *list = self.lists[index];
    cell.textLabel.text = list.name;
    cell.delegate = self;
    cell.item = list;
    return cell;
}

-(void)itemCompleted:(GGShoppingItem *)shopItem {
    // use the UITableView to animate the removal of this row

}


@end

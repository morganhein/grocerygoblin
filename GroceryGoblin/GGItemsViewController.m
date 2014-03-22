//
//  GGViewController.m
//  GroceryGoblin
//
//  Created by Morgan on 1/18/14.
//  Copyright (c) 2014 MorganJoshEvan. All rights reserved.
//

#import "GGItemsViewController.h"
#import "GGShoppingItem.h"
#import "GGTableViewCell.h"
#import "GGSingleton.h"
#import "GGTableViewCell.h"

@interface GGItemsViewController ()

@end

@implementation GGItemsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.displayList = [[NSMutableArray alloc] init];
    self.singleton = [GGSingleton sharedData];
    self.user = [self.singleton.items valueForKey:@"user"];
    self.currentList = [self.singleton.items valueForKey:@"currentList"];
    PFQuery *query = [PFQuery queryWithClassName:@"ShoppingList"];
    [query whereKey:@"objectId" equalTo:self.currentList.identifier];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            self.list = object;
            NSLog(@"%@", [self.list objectId]);
            PFQuery *itemQuery = [PFQuery queryWithClassName:@"ListItem"];
            [itemQuery orderByDescending:@"createdAt"];
            [itemQuery whereKey:@"ShoppingList" equalTo:self.list];
            NSArray *list2 = [itemQuery findObjects];
            self.items = [self.list objectForKey:@"Items"];

            for(PFObject *item in list2){
                GGShoppingItem *newItem = [GGShoppingItem shoppingItemWithName:([item valueForKey:@"name"]) andQuantity:@1];
                newItem.itemParseObject = item;
                [self.displayList addObject:newItem];
            }
            NSLog(@"Done grabbing items");

            [self.itemsTableView reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
//    //HERE'S SOME SAMPLE CODE FOR ADDING A USER.  Modify the query accordingly.
//    PFQuery *userQuery = [PFUser query];
//    [userQuery whereKey:@"username" equalTo:@"Morgan"];
//    PFUser *secondUser = [PFUser user];
//    secondUser = [[userQuery findObjects] objectAtIndex:0];
//    [self addUser:secondUser toList:self.list];
     
    self.itemsTableView.dataSource = self;
    [self.itemsTableView registerClass:[GGTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.itemsTableView.delegate = self;
    self.itemsTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.itemsTableView.backgroundColor = [UIColor blackColor];
    
    
    self.createNewItemTextField.delegate = (id)self;
    [self.itemsTableView reloadData];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.displayList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ident = @"cell";
    GGTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident forIndexPath:indexPath];
    int index = [indexPath row];
    GGShoppingItem *item = self.displayList[index];
//    cell.textLabel.text = item.name;
    cell.delegate = self;
    cell.listItem = item;
    return cell;
}

//Add the styling
-(UIColor *)colorForIndex:(NSInteger) index {
    NSUInteger iCount = self.displayList.count - 1;
    float value = ((float)index / (float)iCount) * 0.6;
    return [UIColor colorWithRed:1.0 green:value blue:0.0 alpha:1.0];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [self colorForIndex:indexPath.row];
}

-(void)itemDeleted:(NSObject *)obj {
    // use the UITableView to animate the removal of this row
    GGShoppingItem *shopItem = (GGShoppingItem *)obj;
    NSUInteger index = [self.displayList indexOfObject:shopItem];
    [self.itemsTableView beginUpdates];
    [self.displayList removeObject:shopItem];
    [shopItem.itemParseObject deleteInBackground];
    [self.itemsTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]
                          withRowAnimation:UITableViewRowAnimationFade];
    [self.itemsTableView endUpdates];
}

-(void)itemCompleted:(NSObject *)obj {
    
}

- (IBAction)createNewItemTextField:(UITextField *)sender {
    GGShoppingItem *item = [[GGShoppingItem alloc] initItemWithName:sender.text andQuantity:@1];
    [self itemAdded:item];
    self.createNewItemTextField.text = @"";
}

-(void)itemAdded:(GGShoppingItem *)shopItem {
    [self.itemsTableView beginUpdates];
    [self.displayList insertObject:shopItem atIndex:0];
    
    PFObject *newItem = [PFObject objectWithClassName:@"ListItem"];
    newItem[@"name"] = shopItem.name;
    newItem[@"quantity"] = shopItem.quantity;
    [newItem setObject:self.list forKey:@"ShoppingList"];
    shopItem.itemParseObject = newItem;
    [newItem saveInBackground];
    
    [self.itemsTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]withRowAnimation:UITableViewRowAnimationTop];
    [self.itemsTableView endUpdates];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(void) doubleTap:(NSObject *)obj {
    NSLog(@"Yo tapped it twice");
}

@end

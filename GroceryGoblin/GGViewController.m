//
//  GGViewController.m
//  GroceryGoblin
//
//  Created by Morgan on 1/18/14.
//  Copyright (c) 2014 MorganJoshEvan. All rights reserved.
//

#import "GGViewController.h"
#import "GGShoppingItem.h"
#import "GGCell.h"

@interface GGViewController ()

@end

@implementation GGViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.displayList = [[NSMutableArray alloc] init];
    PFUser *user = [PFUser user];
    if([PFUser currentUser] != NULL){
        user = [PFUser currentUser];
    }else{
        user = [PFUser logInWithUsername:@"Josh" password:@"plaintextfolyfe"];
    }
   
  //  [self createNewUserWithName:@"Morgan" andPass:@"iloveboobies"];
   // [self createNewUserWithName:@"Evan" andPass:@"iALSOloveboobies!"];
    
    PFQuery *query = [PFQuery queryWithClassName:@"ShoppingList"];
    [query whereKey:@"users" equalTo:user.objectId];
    
    NSArray *lists = [query findObjects];
    for(PFObject *list in lists){
        NSLog(@"Hey, here's a list! %@", list.objectId);
    }
    
    //MORGAN AND EVAN - CHANGE THE INDEX HERE TO GET THE ITEMS FOR DIFFERENT LISTS THE USER HAS ACCESS TO
    self.list = [lists objectAtIndex:2];

    PFQuery *itemQuery = [PFQuery queryWithClassName:@"ListItem"];
    [itemQuery orderByDescending:@"createdAt"];    
    [itemQuery whereKey:@"ShoppingList" equalTo:self.list];
    NSArray *list2 = [itemQuery findObjects];
    
    
    //HERE'S SOME SAMPLE CODE FOR ADDING A USER.  Modify the query accordingly.
    PFQuery *userQuery = [PFUser query];
    [userQuery whereKey:@"username" equalTo:@"Morgan"];
    PFUser *secondUser = [PFUser user];
    secondUser = [[userQuery findObjects] objectAtIndex:0];
    [self addUser:secondUser toList:self.list];

    
    NSLog(@"%@", [self.list objectId]);
    self.items = [self.list objectForKey:@"Items"];
    for(PFObject *item in list2){
        GGShoppingItem *newItem = [GGShoppingItem shoppingItemWithName:([item valueForKey:@"name"]) andQuantity:@1];
        newItem.itemParseObject = item;
        [self.displayList addObject:newItem];
        
    }
    
    self.itemsTableView.dataSource = self;
    [self.itemsTableView registerClass:[GGCell class] forCellReuseIdentifier:@"cell"];
    
    self.itemsTableView.delegate = self;
    self.itemsTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.itemsTableView.backgroundColor = [UIColor blackColor];
    
    
    self.createNewItemTextField.delegate = (id)self;

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
    GGCell *cell = [tableView dequeueReusableCellWithIdentifier:ident forIndexPath:indexPath];
    int index = [indexPath row];
    GGShoppingItem *item = self.displayList[index];
    cell.textLabel.text = item.name;
    cell.delegate = self;
    cell.item = item;
    return cell;
}

//Add the styling
-(UIColor *)colorForIndex:(NSInteger) index {
    NSUInteger iCount = self.displayList.count - 1;
    float value = ((float)index / (float)iCount) * 0.6;
    return [UIColor colorWithRed:0 green:1 blue:value alpha:0.9];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [self colorForIndex:indexPath.row];
}

-(void)itemCompleted:(NSObject *)obj {
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

-(void)shoppingItemAdded:(GGShoppingItem *)shopItem {
    [self.itemsTableView beginUpdates];
    [self.displayList insertObject:shopItem atIndex:0];
    PFObject *newItem = [PFObject objectWithClassName:@"ListItem"];
    [newItem setObject:[PFUser currentUser] forKey:@"createdBy"];
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


- (IBAction)createNewItemTextField:(UITextField *)sender {
    GGShoppingItem *item = [[GGShoppingItem alloc] initItemWithName:sender.text andQuantity:@1];
    [self shoppingItemAdded:item];
    self.createNewItemTextField.text = @"";
}


-(void) addUser:(PFUser *)user toList:(PFObject *)list{
    [list addObject:user.objectId forKey:@"users"];
    
}

-(PFObject *) makeNewListForUser:(PFUser *)user withListName:(NSString *)listName{
    PFObject *newList = [PFObject objectWithClassName:@"ShoppingList"];
    [newList setObject:user forKey:@"createdBy"];
    [newList setObject:listName forKey:@"ListName"];
    [newList setObject:@[user.objectId] forKey:@"users"];
    [newList saveInBackground];
    return newList;
}
@end

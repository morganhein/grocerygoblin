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
{
    
// FIXME: remove this temp variable or turn it into a private property
NSMutableArray *_shoppingItems;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // FIXME: don't access _variable, use the getter
  //  _shoppingItems = [[NSMutableArray alloc] init];
 //   PFObject *item = [PFObject objectWithClassName:@"ListItem"];
  //  [item setObject:[PFUser currentUser] forKey:@"createdBy"]
  //  [_shoppingItems addObject:[GGShoppingItem shoppingItemWithName:@"Milk" andQuantity:@3]];
  //  [_shoppingItems addObject:[GGShoppingItem shoppingItemWithName:@"Honey" andQuantity:@2]];
   // [_shoppingItems addObject:[GGShoppingItem shoppingItemWithName:@"Butter" andQuantity:@40]];
    
    
    
    
    self.displayList = [[NSMutableArray alloc] init];
    PFUser *user;
    if([PFUser currentUser] != NULL){
        user = [PFUser currentUser];
    }else{
        user = [PFUser logInWithUsername:@"Josh" password:@"plaintextfolyfe"];
    }
    
    PFQuery *query = [PFQuery queryWithClassName:@"ShoppingList"];
    PFQuery *itemQuery = [PFQuery queryWithClassName:@"ListItem"];
    [itemQuery orderByDescending:@"createdAt"];
    [query whereKey:@"createdBy" equalTo:user];
    [query includeKey:@"Items"];
    //PFObject *list = [query findObjects];
    NSArray* lists = [query findObjects];
    self.list = [lists objectAtIndex:0];

    [itemQuery whereKey:@"ShoppingList" equalTo:self.list];
    NSArray *list2 = [itemQuery findObjects];
    
    
//    PFObject *testList = [PFObject objectWithClassName:@"ShoppingList"];
//    [testList setObject:user forKey:@"createdBy"];
//    self.list = testList;
//    
//    
//    PFObject *testItem1 = [PFObject objectWithClassName:@"ListItem"];
//    PFObject *testItem2 = [PFObject objectWithClassName:@"ListItem"];
//    PFObject *testItem3 = [PFObject objectWithClassName:@"ListItem"];
//    PFObject *testItem4 = [PFObject objectWithClassName:@"ListItem"];
//    PFObject *testItem5 = [PFObject objectWithClassName:@"ListItem"];
//    testItem1[@"name"] = @"butter";
//    testItem1[@"quantity"] = @1;
//    //[testItem1 setObject:self.list forKey:@"ShoppingList"];
//    testItem2[@"name"] = @"milk";
//    testItem2[@"quantity"] = @1;
//    //[testItem2 setObject:self.list forKey:@"ShoppingList"];
//    testItem3[@"name"] = @"eggs";
//    testItem3[@"quantity"] = @1;
//    //[testItem3 setObject:self.list forKey:@"ShoppingList"];
//    testItem4[@"name"] = @"beer";
//    testItem4[@"quantity"] = @1;
//    //[testItem4 setObject:self.list forKey:@"ShoppingList"];
//    testItem5[@"name"] = @"soda";
//    testItem5[@"quantity"] = @1;
//    //[testItem5 setObject:self.list forKey:@"ShoppingList"];
//    [self.list saveInBackground];
//    NSArray *items = @[testItem1, testItem2, testItem3, testItem4, testItem5];
//    [self.list setObject:items forKey:@"Items"];
//    [testItem1 saveInBackground];
//    [testItem2 saveInBackground];
//    [testItem3 saveInBackground];
//    [testItem4 saveInBackground];
//    [testItem5 saveInBackground];
//    [self.list saveInBackground];
//    
    
    
    
    

    
    
    //self.list[@"Items"] =
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



//    PFObject *testList = [PFObject objectWithClassName:@"ShoppingList"];
//    [testList setObject:user forKey:@"createdBy"];
//    PFObject *testItem1 = [PFObject objectWithClassName:@"ListItem"];
    //    testItem1[@"name"] = @"butter";
    //    testItem1[@"quantity"] = @1;
    
//    [testList saveInBackground];
   // [testItem1 saveInBackground];
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
    cell.shopItem = item;
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

-(void)shoppingItemCompleted:(GGShoppingItem *)shopItem {
    // use the UITableView to animate the removal of this row
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
  //  [self.items addObject:newItem];
    //self.list[@"Items"] = self.items;
  //  [self.list setObject:self.items forKey:@"Items"];
    //[newItem saveInBackground];
  //  [self.list saveInBackground];
    
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
@end

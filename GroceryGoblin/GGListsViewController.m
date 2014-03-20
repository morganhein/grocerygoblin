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
#import "GGSingleton.h"
#import "GGItemsViewController.h"

@interface GGListsViewController ()

@end

@implementation GGListsViewController


//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //Load the Data Singleton
    self.singleton = [GGSingleton sharedData];
    self.user = [self.singleton.items valueForKey:@"user"];

    
    //Query Parse for our shopping lists
    PFQuery *query = [PFQuery queryWithClassName:@"ShoppingList"];
    [query whereKey:@"users" equalTo:self.user.objectId];
    
    //Create the local list objects
    self.lists = [[NSMutableArray alloc] init];
    
    NSArray *tempList = [query findObjects];
    for(PFObject *pfList in tempList){
        NSLog(@"Hey, here's a list! %@", pfList.objectId);
        GGShoppingList *list = [[GGShoppingList alloc] initFromObject:pfList];
        [self.lists addObject:list];
    }
    
    //Instantiate the tableview methods
    self.tableView.dataSource = self;
    [self.tableView registerClass:[GGCell class] forCellReuseIdentifier:@"cell"];
    
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.backgroundColor = [UIColor blackColor];
    
    //Set the new text field delegate
    self.createNewList.delegate = (id)self;

}

//    self.lists = [query findObjects];

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
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
    cell.delegate = (id)self;
    cell.item = list;
    return cell;
}

-(UIColor *)colorForIndex:(NSInteger) index {
    NSUInteger iCount = self.lists.count - 1;
    float value = ((float)index / (float)iCount) * 0.6;
    return [UIColor colorWithRed:0 green:1 blue:value alpha:0.9];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [self colorForIndex:indexPath.row];
}

- (IBAction)createNewList:(UITextField *)sender {
    NSLog(@"Creating new list");
    GGShoppingList *list = [[GGShoppingList alloc] initWithName:self.createNewList.text];
    [self itemAdded:list];
}

-(void)itemCompleted:(NSObject *)obj {
    // use the UITableView to animate the removal of this row
    GGShoppingList *listItem = (GGShoppingList *)obj;
    NSUInteger index = [self.lists indexOfObject:listItem];
    
    [self.tableView beginUpdates];
    [self.lists removeObject:listItem];
    [listItem.itemParseObject deleteInBackground];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]
                               withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

-(void)itemAdded:(GGShoppingList *)listItem {
    [self.tableView beginUpdates];
    [self.lists insertObject:(GGShoppingList* )listItem atIndex:0];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
}

-(void)doubleTap:(NSObject *)obj {
    NSLog(@"You double tapped");
    self.nextList = (GGShoppingList *)obj;
    [self performSegueWithIdentifier:@"toItems" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toItems"]) {
//        GGItemsViewController *con = (GGItemsViewController *)segue.destinationViewController;
////        con.gglist = self.nextList;
        [self.singleton.items setObject:self.nextList forKey:@"currentList"];
//        [self.singleton.items setValue:self.nextList forKey:@"currentList"];`
    }
}

-(void) addUser:(PFUser *)user toList:(PFObject *)list{
    [list addObject:user.objectId forKey:@"users"];
}
//PFObject *newItem = [PFObject objectWithClassName:@"ListItem"];
//[newItem setObject:[PFUser currentUser] forKey:@"createdBy"];
//newItem[@"name"] = shopItem.name;
//newItem[@"quantity"] = shopItem.quantity;
//[newItem setObject:self.list forKey:@"ShoppingList"];
//shopItem.itemParseObject = newItem;
//[newItem saveInBackground];

@end

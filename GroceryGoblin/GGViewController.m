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

@implementation GGViewController {
    NSMutableArray *_shoppingItems;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _shoppingItems = [[NSMutableArray alloc] init];
    [_shoppingItems addObject:[GGShoppingItem shoppingItemWithName:@"Milk" andQuantity:@3]];
    [_shoppingItems addObject:[GGShoppingItem shoppingItemWithName:@"Honey" andQuantity:@2]];
    [_shoppingItems addObject:[GGShoppingItem shoppingItemWithName:@"Condoms" andQuantity:@40]];
    self.itemsTableView.dataSource = self;
    [self.itemsTableView registerClass:[GGCell class] forCellReuseIdentifier:@"cell"];
    
    self.itemsTableView.delegate = self;
    self.itemsTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.itemsTableView.backgroundColor = [UIColor blackColor];
    
    self.createNewItemTextField.delegate = (id)self;
    
    PFObject *testObject = [PFObject objectWithClassName:@"shoppingList"];
    
    [testObject saveInBackground];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _shoppingItems.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ident = @"cell";
    GGCell *cell = [tableView dequeueReusableCellWithIdentifier:ident forIndexPath:indexPath];
    int index = [indexPath row];
    GGShoppingItem *item = _shoppingItems[index];
    cell.textLabel.text = item.name;
    cell.delegate = self;
    cell.shopItem = item;
    return cell;
}

//Add the styling
-(UIColor *)colorForIndex:(NSInteger) index {
    NSUInteger iCount = _shoppingItems.count - 1;
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
    NSUInteger index = [_shoppingItems indexOfObject:shopItem];
    [self.itemsTableView beginUpdates];
    [_shoppingItems removeObject:shopItem];
    [self.itemsTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]
                          withRowAnimation:UITableViewRowAnimationFade];
    [self.itemsTableView endUpdates];
}

-(void)shoppingItemAdded:(GGShoppingItem *)shopItem {
    [self.itemsTableView beginUpdates];
    [_shoppingItems insertObject:shopItem atIndex:0];
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

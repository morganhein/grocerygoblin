//
//  GroceryGoblinTests.m
//  GroceryGoblinTests
//
//  Created by Morgan on 1/18/14.
//  Copyright (c) 2014 MorganJoshEvan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GGListsViewController.h"
#import "GGCell.h"
#import "GGShoppingList.h"
#import "GGSingleton.h"
#import "GGItemsViewController.h"

@interface GroceryGoblinTests : XCTestCase

@end

@implementation GroceryGoblinTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    self.tableView.dataSource = self;
    [self.tableView registerClass:[GGCell class] forCellReuseIdentifier:@"cell"];
    
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.backgroundColor = [UIColor blackColor];
    
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
    
    -(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return 50.0f;
    }
    
    -(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
        cell.backgroundColor = [self colorForIndex:indexPath.row];
    }
}

@end

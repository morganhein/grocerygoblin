//
//  GGShoppingItems.h
//  GroceryGoblin
//
//  Created by Morgan on 1/18/14.
//  Copyright (c) 2014 MorganJoshEvan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "GGListItem.h"

@interface GGShoppingItem : GGListItem

    @property (nonatomic) NSNumber *quantity;
    @property (nonatomic, strong) PFObject *itemParseObject;

    -(id)initItemWithName:(NSString *)name andQuantity:(NSNumber *)quantity;
    +(id)shoppingItemWithName:(NSString *)name andQuantity:(NSNumber *)quantity;

@end

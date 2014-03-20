//
//  GGShoppingItems.m
//  GroceryGoblin
//
//  Created by Morgan on 1/18/14.
//  Copyright (c) 2014 MorganJoshEvan. All rights reserved.
//

#import "GGShoppingItem.h"

@implementation GGShoppingItem

-(id)initItemWithName:(NSString *)name andQuantity:(NSNumber *)quantity {
    if (self == [super init]) {
        self.name = name;
        self.quantity = quantity;
    }
    return self;
}

+(id)shoppingItemWithName:(NSString *)name andQuantity:(NSNumber *)quantity {
    return [[GGShoppingItem alloc] initItemWithName:name andQuantity:quantity];
}

@end

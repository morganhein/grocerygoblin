//
//  GGShoppingList.m
//  GroceryGoblin
//
//  Created by Josh on 3/13/14.
//  Copyright (c) 2014 MorganJoshEvan. All rights reserved.
//

#import "GGShoppingList.h"

@implementation GGShoppingList

-(id)init:(PFObject  *)list {
    if (self == [super init]) {
        self.identifer = list.objectId;
        self.name = list.objectId;
    }
    return self;
}

-(id)initFromObject:(PFObject *)list {
    return [[GGShoppingList alloc] init:list];
}

@end

//
//  GGShoppingList.h
//  GroceryGoblin
//
//  Created by Josh on 3/13/14.
//  Copyright (c) 2014 MorganJoshEvan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "GGListItem.h"

@interface GGShoppingList : GGListItem

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) PFObject *itemParseObject;

-(id)initFromObject:(PFObject *)list;
-(id)initWithName:(NSString *)name;

@end

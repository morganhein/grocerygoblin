//
//  GGShoppingItems.h
//  GroceryGoblin
//
//  Created by Morgan on 1/18/14.
//  Copyright (c) 2014 MorganJoshEvan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGShoppingItem : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic) NSNumber *quantity;
@property (nonatomic) BOOL purchased;

-(id)initItemWithName:(NSString *)name andQuantity:(NSNumber *)quantity;
+(id)shoppingItemWithName:(NSString *)name andQuantity:(NSNumber *)quantity;

@end
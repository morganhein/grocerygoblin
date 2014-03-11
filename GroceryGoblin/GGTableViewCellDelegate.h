//
//  GGTableViewCellDelegate.h
//  GroceryGoblin
//
//  Created by Morgan on 3/11/14.
//  Copyright (c) 2014 MorganJoshEvan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGshoppingItem.h"

@protocol GGTableViewCellDelegate <NSObject>

-(void) shoppingItemCompleted:(GGShoppingItem *)shopItem;
-(void) shoppingItemAdded:(GGShoppingItem *)shopItem;

@end
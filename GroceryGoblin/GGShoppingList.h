//
//  GGShoppingList.h
//  GroceryGoblin
//
//  Created by Josh on 3/13/14.
//  Copyright (c) 2014 MorganJoshEvan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface GGShoppingList : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *identifer;
@property (nonatomic) BOOL completed;
-(id)initFromObject:(PFObject *)list;
-(id)init:(PFObject *)list;

@end

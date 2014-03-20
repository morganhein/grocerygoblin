//
//  GGShoppingList.m
//  GroceryGoblin
//
//  Created by Josh on 3/13/14.
//  Copyright (c) 2014 MorganJoshEvan. All rights reserved.
//

#import "GGShoppingList.h"
#import "GGSingleton.h"
//#import "GGPFObject.h"

@implementation GGShoppingList

-(id)init:(PFObject  *)list {
    if (self == [super init]) {
        self.identifier = list.objectId;
        self.name = [list objectForKey:@"ListName"];
//        GGPFObject *obj = [[GGPFObject alloc] initFromObject:list];
//        self.name = obj.getInfo;
    }
    return self;
}

-(id)initFromObject:(PFObject *)list {
    return [[GGShoppingList alloc] init:list];
}

-(id)initWithName:(NSString *)name {
    GGSingleton *singletonData = [GGSingleton sharedData];
    PFUser *user = [singletonData.items valueForKey:@"user"];
    PFObject *newList = [PFObject objectWithClassName:@"ShoppingList"];
    [newList setObject:user forKey:@"createdBy"];
    [newList setObject:name forKey:@"ListName"];
    [newList setObject:@[user.objectId] forKey:@"users"];
    [newList saveInBackground];
    return [self initFromObject:newList];
//    return (id)newList;
}

-(id)getId {
    return self.identifier;
}
@end


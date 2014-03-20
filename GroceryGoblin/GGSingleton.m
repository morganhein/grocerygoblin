//
//  GGSingleton.m
//  GroceryGoblin
//
//  Created by iGuest on 3/20/14.
//  Copyright (c) 2014 MorganJoshEvan. All rights reserved.
//

#import "GGSingleton.h"
@implementation GGSingleton

+(id)sharedData {
    static GGSingleton *dataSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataSingleton = [[self alloc] init];
    });
    return dataSingleton;
}

-(id)init {
    if (self = [super init])
    {
        self.items = [[NSMutableDictionary alloc] initWithCapacity:3];
//        currentList = [[NSObject alloc] init];
//        user = [[PFUser alloc] init];
//        lists = [[NSMutableArray alloc] init];
    }
    return self;
}

@end

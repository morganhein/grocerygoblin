//
//  GGSingleton.h
//  GroceryGoblin
//
//  Created by iGuest on 3/20/14.
//  Copyright (c) 2014 MorganJoshEvan. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <Parse/Parse.h>

@interface GGSingleton : NSObject {
    NSMutableDictionary *items;
}
@property (strong, nonatomic) NSMutableDictionary *items;
+(id)sharedData;

@end

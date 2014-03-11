//
//  GGCell.h
//  GroceryGoblin
//
//  Created by Morgan on 3/11/14.
//  Copyright (c) 2014 MorganJoshEvan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGTableViewCellDelegate.h"

@interface GGCell : UITableViewCell
@property (nonatomic) GGShoppingItem *shopItem;
@property (nonatomic, assign) id<GGTableViewCellDelegate> delegate;
@end

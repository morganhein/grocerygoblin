//
//  GGCell.m
//  GroceryGoblin
//
//  Created by Morgan on 3/11/14.
//  Copyright (c) 2014 MorganJoshEvan. All rights reserved.
//

#import "GGCell.h"

@implementation GGCell {
    CGPoint _center;
    BOOL _deleteOnDragRelease;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIGestureRecognizer* recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        recognizer.delegate = self;
        [self addGestureRecognizer:recognizer];
        //NSLog(@"Entered init for initWithStyle");
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:[self superview]];
    if (fabsf(translation.x) > fabsf(translation.y)) {
        return YES;
    }
    return NO;
}

-(void)handleGesture:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _center = self.center;
    }
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:self];
        self.center = CGPointMake(_center.x + translation.x, _center.y);
        _deleteOnDragRelease = self.frame.origin.x > -self.frame.size.width / 2;
        
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGRect originalFrame = CGRectMake(0, self.frame.origin.y,
                                          self.bounds.size.width, self.bounds.size.height);
        if (!_deleteOnDragRelease) {
            [UIView animateWithDuration:0.2
                             animations:^{
                                 self.frame = originalFrame;
                             }
             ];
        }
        if (_deleteOnDragRelease) {
            [self.delegate itemCompleted:self.item];
        }
    }
}

@end

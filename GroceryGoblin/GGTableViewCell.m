//
//  GGCell.m
//  GroceryGoblin
//
//  Created by Morgan on 3/11/14.
//  Copyright (c) 2014 MorganJoshEvan. All rights reserved.
//

#import "GGTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation GGTableViewCell {
    CGPoint _center;
    BOOL _deleteOnDragRelease;
    BOOL _completeOnDragRelease;
    CAGradientLayer *_gradientLayer;
    CALayer *_completedLayer;
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
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        tapGesture.delegate = self;
        tapGesture.numberOfTapsRequired = 2;
        [self addGestureRecognizer:tapGesture];
        
        // add a layer that overlays the cell adding a subtle gradient effect
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = self.bounds;
        _gradientLayer.colors = @[(id)[[UIColor colorWithWhite:1.0f alpha:0.2f] CGColor],
                                  (id)[[UIColor colorWithWhite:1.0f alpha:0.1f] CGColor],
                                  (id)[[UIColor clearColor] CGColor],
                                  (id)[[UIColor colorWithWhite:0.0f alpha:0.1f] CGColor]];
        _gradientLayer.locations = @[@0.00f, @0.01f, @0.95f, @1.00f];
        [self.layer insertSublayer:_gradientLayer atIndex:0];
        
        _completedLayer = [CALayer layer];
        _completedLayer.backgroundColor = [[[UIColor alloc] initWithRed:0.0 green:0.6 blue:0.0 alpha:1.0] CGColor];
        _completedLayer.hidden = YES;
        [self.layer insertSublayer:_completedLayer above:_gradientLayer];
    }
    return self;
}

-(void) layoutSubviews {
    [super layoutSubviews];
    // ensure the gradient layers occupies the full bounds
    _gradientLayer.frame = self.bounds;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        NSLog(@"Always double tap");
        [self.delegate doubleTap:self.listItem];
    }
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]){
        CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:[self superview]];
        //Check for horizontal gesture
        if (fabsf(translation.x) > fabsf(translation.y)) {
            return YES;
        }
    } else if([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]){
        return YES;
    }
    return NO;
}

-(void)handleGesture:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _center = self.center;
    }
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        //Find the center point
        CGPoint center = [recognizer translationInView:self];
        self.center = CGPointMake(_center.x + center.x, _center.y);
        _deleteOnDragRelease = self.frame.origin.x < -self.frame.size.width / 2;
        _completeOnDragRelease = self.frame.origin.x > self.frame.size.width / 2;
        
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGRect originalFrame = CGRectMake(0, self.frame.origin.y,
                                          self.bounds.size.width, self.bounds.size.height);
        if (!_deleteOnDragRelease && !_completeOnDragRelease) {
            [UIView animateWithDuration:0.2
                             animations:^{
                                 self.frame = originalFrame;
                             }
             ];
        }
        if (_deleteOnDragRelease) {
            [self.delegate itemDeleted:self.listItem];
        }
        if (_completeOnDragRelease) {
            self.listItem.completed = YES;
            [UIView animateWithDuration:0.2
                             animations:^{
                                 self.frame = originalFrame;
                             }
             ];
            NSAttributedString *strikeString = [[NSAttributedString alloc] initWithString:_listItem.name attributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInt:NSUnderlineStyleSingle]}];
            self.textLabel.attributedText = strikeString;
            _completedLayer.hidden = NO;
            [self.delegate itemCompleted:self.listItem];
        }
    }
}

-(void)setListItem:(GGListItem *)listItem {
    _listItem = listItem;
    self.textLabel.text = _listItem.name;
    if (_listItem.completed) {
        NSAttributedString *strikeString = [[NSAttributedString alloc] initWithString:_listItem.name attributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInt:NSUnderlineStyleSingle]}];
        self.textLabel.attributedText = strikeString;
        _completedLayer.hidden = NO;
        self.textLabel.attributedText = strikeString;
    }
}

@end

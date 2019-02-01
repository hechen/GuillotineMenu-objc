//
//  UIView+ConstraintExtension.m
//  GuillotineMenu-objc
//
//  Created by hechen on 15/8/28.
//  Copyright (c) 2015年 hechen. All rights reserved.
//

#import "UIView+ConstraintExtension.h"

@implementation UIView (ConstraintExtension)

-(void)addScaleToFitView:(UIView*)fillView edgeInsets:(UIEdgeInsets)insets {
    if(!fillView) {
        return;
    }
    
    [self addConstraint: [NSLayoutConstraint constraintWithItem:fillView
                                                      attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeTop
                                                     multiplier:1.f
                                                       constant:insets.top]];
    
    [self addConstraint: [NSLayoutConstraint constraintWithItem:fillView
                                                      attribute:NSLayoutAttributeLeading
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeLeading
                                                     multiplier:1.f
                                                       constant:insets.left]];
    
    [self addConstraint: [NSLayoutConstraint constraintWithItem:fillView
                                                      attribute:NSLayoutAttributeTrailing
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeTop
                                                     multiplier:1.f
                                                       constant:insets.right]];
    
    [self addConstraint: [NSLayoutConstraint constraintWithItem:fillView
                                                      attribute:NSLayoutAttributeBottom
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeBottom
                                                     multiplier:1.f
                                                       constant:insets.bottom]];
}

-(void) addConstraintsForMenuButton: (UIButton*)button offset: (UIOffset) offset result: (void(^)(NSLayoutConstraint*, NSLayoutConstraint*)) completion {
    NSLayoutConstraint* leading = nil;
    NSLayoutConstraint* top = nil;
    
    if (!button) {
        if (completion) {
            completion(nil, nil);
        }
        
        return;
    }
    
    if(button) {
        [self removeConstraints: button.constraints];
        [button setTranslatesAutoresizingMaskIntoConstraints: NO];
        
        top = [NSLayoutConstraint constraintWithItem:button
                                           attribute:NSLayoutAttributeTop
                                           relatedBy:NSLayoutRelationEqual
                                              toItem:self
                                           attribute:NSLayoutAttributeTop
                                          multiplier:1.0
                                            constant:offset.vertical];
        [self addConstraint:top];
        
        leading = [NSLayoutConstraint constraintWithItem:button
                                               attribute:NSLayoutAttributeLeading
                                               relatedBy:NSLayoutRelationEqual
                                                  toItem:self
                                               attribute:NSLayoutAttributeLeading
                                              multiplier:1.0
                                                constant:offset.horizontal];
        [self addConstraint: leading];
        
        [button addConstraint: [NSLayoutConstraint  constraintWithItem:button
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:1.0f
                                                              constant:30.f]];
        [button addConstraint: [NSLayoutConstraint  constraintWithItem:button
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:1.0f
                                                              constant:30.f]];
    }
    
    // 返回 leading and  top
    if (completion) {
        completion(leading, top);
    }
}

@end

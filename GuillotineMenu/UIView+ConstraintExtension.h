//
//  UIView+ConstraintExtension.h
//  GuillotineMenu-objc
//
//  Created by hechen on 15/8/28.
//  Copyright (c) 2015年 hechen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ConstraintExtension)

-(void) addScaleToFitView : (UIView*)view edgeInsets: (UIEdgeInsets) insets;
-(void) addConstraintsForMenuButton: (UIButton*)button offset: (UIOffset) offset result: (void(^)(NSLayoutConstraint*, NSLayoutConstraint*)) completion;

@end

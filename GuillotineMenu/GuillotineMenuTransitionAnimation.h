//
//  GuillotineMenuTransitionAnimation.h
//  GuillotineMenu-objc
//
//  Created by hechen on 15/8/28.
//  Copyright (c) 2015年 hechen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol GuillotineAnimationProtocol <NSObject>

- (CGFloat) navigationBarHeight;
- (CGPoint) anchorPoint;
- (NSString*) hostTitle;

@end

@protocol GuillotineAnimationDelegate <NSObject>

@optional
- (void) menuDidCollideWithBoundary;
- (void) menuDidFinishPresentation;
- (void) menuDidFinishDismissal;
- (void) willStartPresentation;
- (void) willStartDismissal;

@end



typedef NS_ENUM(NSUInteger, AnimationMode){
    AnimationModePresentation,
    AnimationModeDismissal
};

@interface GuillotineTransitionAnimation : NSObject<UIViewControllerAnimatedTransitioning, UICollisionBehaviorDelegate, UIDynamicAnimatorDelegate>


- (instancetype)initWithMode: (AnimationMode) mode;

@end

//
//  GuillotineMenuViewController.h
//  GuillotineMenu-objc
//
//  Created by hechen on 15/8/28.
//  Copyright (c) 2015年 hechen. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - GuillotineAnimationProtocol

@protocol GuillotineAnimationProtocol <NSObject>

@required
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

@protocol GuillotineMenuViewControllerDelegate <NSObject>

- (void)menuOptionTapped: (NSString*) menuOption;

@end


@interface GuillotineMenuViewController : UIViewController<GuillotineAnimationProtocol>

@property (nonatomic, assign) CGFloat hostNavigationBarHeight;
@property (nonatomic, copy) NSString* hostTitleText;

@property (nonatomic, weak) id<GuillotineMenuViewControllerDelegate> delegate;


- (void)setMenuButtonWithImage: (UIImage*) image;

@end

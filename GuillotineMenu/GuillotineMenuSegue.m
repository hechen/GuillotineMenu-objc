//
//  GuillotineMenuSegue.m
//  GuillotineMenu-objc
//
//  Created by hechen on 15/8/28.
//  Copyright (c) 2015年 hechen. All rights reserved.
//

#import "GuillotineMenuSegue.h"
#import "GuillotineMenuTransitionAnimation.h"
#import <objc/runtime.h>

static char key = 0;

@interface GuillotineMenuSegue ()<UIViewControllerTransitioningDelegate>

@end

@implementation GuillotineMenuSegue
{
    
}

- (instancetype)initWithIdentifier:(NSString *)identifier source:(UIViewController *)source destination:(UIViewController *)destination
{
    if([destination conformsToProtocol:@protocol(GuillotineAnimationDelegate)])
    {
        // do nothing
    }
    else
    {
        NSAssert1(YES, @"Destination must conform to %@ protocol", NSStringFromProtocol(@protocol(GuillotineAnimationProtocol)));
    }
    
    self = [super initWithIdentifier:identifier source:source destination:destination];
    
    return self;
}

- (void)perform
{
    UIViewController* source = self.sourceViewController;
    UIViewController* target = self.destinationViewController;
    
    target.modalPresentationStyle = UIModalPresentationCustom;
    target.transitioningDelegate = self;
    
    [source presentViewController: target animated: YES completion: nil];
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source
{
    objc_setAssociatedObject(presented, &key, self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return [[GuillotineTransitionAnimation alloc] initWithMode:Presentation];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [[GuillotineTransitionAnimation alloc] initWithMode:Dismissal];
}

@end

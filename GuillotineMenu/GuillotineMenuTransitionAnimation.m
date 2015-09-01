//
//  GuillotineMenuTransitionAnimation.m
//  GuillotineMenu-objc
//
//  Created by hechen on 15/8/28.
//  Copyright (c) 2015年 hechen. All rights reserved.
//

#import "GuillotineMenuTransitionAnimation.h"
#import "UIView+ConstraintExtension.h"

static CGFloat const duration                 = 0.6;
static CGFloat const vectorDY                 = 1500;
static CGFloat const vectorDX                 = 0.0;
static CGFloat const initialMenuRotationAngle = -90;
static CGFloat const menuElasticity           = 0.6;

@interface GuillotineTransitionAnimation ()

@property (nonatomic, strong) UIDynamicAnimator* animator;
@property (nonatomic, strong) UIDynamicItemBehavior*  itemBehaviour;
@property (nonatomic, strong) UICollisionBehavior* collisionBehaviour;
@property (nonatomic, strong) UIPushBehavior* fallBehaviour;
@property (nonatomic, strong) UIAttachmentBehavior* attachmentBehaviour;

@end

@implementation GuillotineTransitionAnimation
{
    Mode _mode;
    
    CGPoint anchorPoint;
    CGFloat _statusbarHeight;
    CGFloat _navigationBarHeight;
    
    UIViewController* _menu;
    id<UIViewControllerContextTransitioning> _animationContext;
}


- (instancetype)initWithMode:(Mode)mode
{
    if(self = [super init])
    {
        _mode = mode;
    }
    
    return self;
}

#pragma mark - Setter && Getter
- (UIDynamicAnimator *)animator
{
    if(!_animator)
    {
        _animator = [UIDynamicAnimator new];
    }
    return _animator;
}

- (UICollisionBehavior *)collisionBehaviour
{
    if(!_collisionBehaviour)
    {
        _collisionBehaviour = [UICollisionBehavior new];
    }
    
    return _collisionBehaviour;
}

#pragma mark - Private
- (void) animatePresentation: (id<UIViewControllerContextTransitioning>)context
{
    _menu = [context viewControllerForKey: UITransitionContextToViewControllerKey];
    
    if ([_menu conformsToProtocol:@protocol(GuillotineAnimationDelegate)])
    {
       if([_menu respondsToSelector:@selector(willStartPresentation)])
       {
           id<GuillotineAnimationDelegate> menuProt = (id<GuillotineAnimationDelegate>)_menu;
           [menuProt willStartPresentation];
       }
    }
    
    // Move view off screen to avoid blink at start
    _menu.view.center = CGPointMake(0, CGRectGetHeight(_menu.view.frame));
    
    [_menu beginAppearanceTransition:YES animated:YES];
    
    [context.containerView addSubview:_menu.view];
    
    [self animateMenu:_menu.view context: context];
}


-(void) animateDismissal: (id<UIViewControllerContextTransitioning>) context
{
    _menu = [context viewControllerForKey: UITransitionContextFromViewControllerKey];
    
    if([_menu conformsToProtocol:@protocol(GuillotineAnimationDelegate)])
    {
        if([_menu respondsToSelector:@selector(willStartDismissal)])
        {
            id<GuillotineAnimationDelegate> menuProt = (id<GuillotineAnimationDelegate>)_menu;
            [menuProt willStartDismissal];
        }
    }
    
    UIViewController* host = [context viewControllerForKey: UITransitionContextFromViewControllerKey];
    self.animator.delegate = self;
    
    [self animateMenu:_menu.view context: context];
}

- (void) animateMenu: (UIView*) view context: (id<UIViewControllerContextTransitioning>) context
{
    CGRect vFrame = view.frame;
    NSLog(@"view frame: (%f, %f, %f, %f)", vFrame.origin.x, vFrame.origin.y, vFrame.size.width, vFrame.size.height);
    
    _animationContext = context;
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView: context.containerView];
    _animator.delegate = self;
    
    _statusbarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    if([_menu conformsToProtocol: @protocol(GuillotineAnimationProtocol)])
    {
        id<GuillotineAnimationProtocol> menuProt = (id<GuillotineAnimationProtocol>)_menu;
        _navigationBarHeight = [menuProt navigationBarHeight];
        anchorPoint = [menuProt anchorPoint];
    }
    
    CGVector rotationDirection = CGVectorMake(0, -vectorDY);
    _attachmentBehaviour = [[UIAttachmentBehavior alloc] initWithItem:view
                                                     offsetFromCenter:UIOffsetMake(-view.bounds.size.width / 2 + anchorPoint.x,
                                                                                   -view.bounds.size.height / 2 + anchorPoint.y)
                                                     attachedToAnchor:anchorPoint];
    
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if(_mode == Presentation)
    {
        [self showHostTitleLabel: NO animated: YES];
        view.transform = CGAffineTransformRotate(CGAffineTransformIdentity, (initialMenuRotationAngle / 180.f) * M_PI);
        view.frame = CGRectMake(-_statusbarHeight, -CGRectGetHeight(view.frame) + _statusbarHeight + _navigationBarHeight, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame));
        
        // 向下
        rotationDirection = CGVectorMake(0, vectorDY);
        
        if(UIDeviceOrientationIsLandscape(orientation))
        {
            [self.collisionBehaviour addBoundaryWithIdentifier:@"collide"
                                                     fromPoint:CGPointMake(CGRectGetHeight(context.containerView.frame),
                                                                           CGRectGetHeight(context.containerView.frame) + 0.6)
                                                       toPoint:CGPointMake(CGRectGetHeight(context.containerView.frame),
                                                                           CGRectGetHeight(context.containerView.frame) + 0.6)];
        }
        else
        {
            [self.collisionBehaviour addBoundaryWithIdentifier:@"collide"
                                                     fromPoint:CGPointMake(-0.6, CGRectGetHeight(context.containerView.frame)/2)
                                                       toPoint:CGPointMake(-0.6, CGRectGetHeight(context.containerView.frame))];
        }
    }
    else
    {
        [self showHostTitleLabel:YES animated:YES];
        
        if(UIDeviceOrientationIsLandscape(orientation))
        {
            [self.collisionBehaviour addBoundaryWithIdentifier:@"collide"
                                                     fromPoint:CGPointMake(-0.6, -CGRectGetHeight(context.containerView.frame) / 2.f)
                                                       toPoint:CGPointMake(-0.6, -CGRectGetHeight(context.containerView.frame))];
        }
        else
        {
            [self.collisionBehaviour addBoundaryWithIdentifier:@"collide"
                                                     fromPoint:CGPointMake(CGRectGetHeight(context.containerView.frame)/2,
                                                                           -CGRectGetWidth(context.containerView.frame) + _statusbarHeight + _navigationBarHeight - 0.6)
                                                       toPoint:CGPointMake(CGRectGetHeight(context.containerView.frame),
                                                                           -CGRectGetWidth(context.containerView.frame) + _statusbarHeight + _navigationBarHeight - 0.6)];
        }
    }
    
    [self.animator addBehavior:self.attachmentBehaviour];
    
    [self.collisionBehaviour addItem:view];
    [self.animator addBehavior:self.collisionBehaviour];
    
    self.collisionBehaviour.collisionDelegate = self;
    
    _fallBehaviour = [[UIPushBehavior alloc] initWithItems:@[view] mode:UIPushBehaviorModeContinuous];
    _fallBehaviour.pushDirection = rotationDirection;
    [self.animator addBehavior:self.fallBehaviour];
    [_fallBehaviour addItem:view];
    
    _itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[view]];
    _itemBehaviour.elasticity = menuElasticity;
    _itemBehaviour.resistance = 0.5f;
    _itemBehaviour.friction = 0.5;
    
    [self.animator addBehavior:self.itemBehaviour];
    [_itemBehaviour addItem:view];
}

- (void)showHostTitleLabel :(BOOL)show animated : (BOOL) animated
{
    UILabel* hostTitleLabel = [UILabel new];
    hostTitleLabel.numberOfLines = 1.f;
    
    if([_menu conformsToProtocol:@protocol(GuillotineAnimationProtocol)])
    {
        id<GuillotineAnimationProtocol> menuProt = (id<GuillotineAnimationProtocol>)_menu;
        hostTitleLabel.text = [menuProt hostTitle];
    }
    
    hostTitleLabel.font = [UIFont boldSystemFontOfSize: 17.f];
    hostTitleLabel.textColor = [UIColor whiteColor];
    [hostTitleLabel sizeToFit];
    
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    hostTitleLabel.center = CGPointMake(_navigationBarHeight / 2, CGRectGetWidth(_menu.view.frame) / 2 + statusBarHeight);
    hostTitleLabel.transform = CGAffineTransformMakeRotation( ( 90 * M_PI ) / 180 );
    
    [_menu.view addSubview:hostTitleLabel];
    
    if (_mode == Presentation)
    {
        hostTitleLabel.alpha = 1;
    }
    else
    {
        hostTitleLabel.alpha = 0;
    }
    
    if(animated)
    {
        [UIView animateWithDuration:duration animations:^{
            hostTitleLabel.alpha = show ? 1.f : 0.f;
        }];
        
    }
    else
    {
        hostTitleLabel.alpha = show ? 1.f : 0.f;
    }
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if(_mode == Presentation)
    {
        [self animatePresentation:transitionContext];
    }
    else
    {
        [self animateDismissal:transitionContext];
    }
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return duration;
}

#pragma mark - UICollisionBehaviorDelegate
- (void) collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p
{
    NSLog(@"collided");
    if([_menu respondsToSelector:@selector(menuDidCollideWithBoundary)])
    {
        [_menu performSelector:@selector(menuDidCollideWithBoundary)];
    }
}


#pragma mark - UIDynamicAnimatorDelegate
-(void) dynamicAnimatorDidPause : (UIDynamicAnimator*)animator
{
    if(_mode == Presentation)
    {
        [self.animator removeAllBehaviors];
        
        _menu.view.transform = CGAffineTransformIdentity;
        _menu.view.frame = _animationContext.containerView.bounds;
        
        // when i use this method, something goes wrong~~~ so.
        //[_menu.view.superview addScaleToFitView:_menu.view edgeInsets:UIEdgeInsetsZero];
        anchorPoint = CGPointZero;
        
        [_menu endAppearanceTransition];
        
        NSLog(@"finished");
        
        if([_menu respondsToSelector:@selector(menuDidFinishPresentation)])
        {
            [_menu performSelector:@selector(menuDidFinishPresentation)];
        }
    }
    else if(_mode == Dismissal)
    {
        [_menu.view removeFromSuperview];
        if([_menu respondsToSelector:@selector(menuDidFinishDismissal)])
        {
            [_menu performSelector:@selector(menuDidFinishDismissal)];
        }
    }
 
    [_animationContext completeTransition: YES];
}

-(void) dynamicAnimatorWillResume: (UIDynamicItemBehavior*)animator
{
    NSLog(@"started");
}

@end

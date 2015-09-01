//
//  GuillotineMenuViewController.m
//  GuillotineMenu-objc
//
//  Created by hechen on 15/8/28.
//  Copyright (c) 2015年 hechen. All rights reserved.
//

#import "GuillotineMenuViewController.h"
#import "UIView+ConstraintExtension.h"

static CGFloat const menuButtonLandscapeLeadingConstant = 1;
static CGFloat const menuButtonPortraitLeadingConstant  = 7;
static CGFloat const hostNavigationBarHeightLandscape   = 32;
static CGFloat const hostNavigationBarHeightPortrait    = 44;

@interface GuillotineMenuViewController ()<GuillotineAnimationDelegate>


@property (nonatomic, strong) UIButton* menuButton;
@property (nonatomic, strong) NSLayoutConstraint* menuButtonLeadingConstraint;
@property (nonatomic, strong) NSLayoutConstraint* menuButtonTopConstraint;

@end

@implementation GuillotineMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        UIDeviceOrientation orientation =  [UIDevice currentDevice].orientation;
        
        if(UIDeviceOrientationIsLandscape(orientation))
        {
            self.menuButtonLeadingConstraint.constant = menuButtonLandscapeLeadingConstant;
            self.menuButtonTopConstraint.constant = menuButtonPortraitLeadingConstant;
        }
        else
        {
            CGFloat statusbarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
            self.menuButtonLeadingConstraint.constant = menuButtonPortraitLeadingConstant;
            self.menuButtonTopConstraint.constant = menuButtonPortraitLeadingConstant + statusbarHeight;
        }
    } completion: nil];
}

- (void)closeMenuButtonTapped: (id)sender
{
    [self dismissViewControllerAnimated:YES completion: nil];
}


- (void)setMenuButtonWithImage: (UIImage*) image
{
    const CGFloat statusbarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    const UIImage* buttonImage = [[UIImage alloc] initWithCGImage: image.CGImage scale: 1.0  orientation:UIImageOrientationRight];
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if(UIDeviceOrientationIsLandscape(orientation))
    {
        _menuButton = [[UIButton alloc]initWithFrame: CGRectMake(menuButtonPortraitLeadingConstant, menuButtonPortraitLeadingConstant+statusbarHeight, 30.0, 30.0)];
    }
    else
    {
        _menuButton = [[UIButton alloc]initWithFrame: CGRectMake(menuButtonPortraitLeadingConstant, menuButtonPortraitLeadingConstant+statusbarHeight, 30.0, 30.0)];
    }
    
    [_menuButton setImage:image forState:UIControlStateNormal];
    [_menuButton setImage:image forState:UIControlStateHighlighted];
    _menuButton.imageView.contentMode = UIViewContentModeCenter;
    [_menuButton addTarget:self
                    action:@selector(closeMenuButtonTapped:)
          forControlEvents: UIControlEventTouchUpInside];
    [_menuButton setTranslatesAutoresizingMaskIntoConstraints: NO];
    _menuButton.transform = CGAffineTransformMakeRotation( 90.f * M_PI / 180.f);
    
    [self.view addSubview: _menuButton];
   
    if(UIDeviceOrientationIsLandscape(orientation))
    {
        [self.view addConstraintsForMenuButton:_menuButton
                                        offset:UIOffsetMake(menuButtonLandscapeLeadingConstant, menuButtonPortraitLeadingConstant)
                                        result:^(NSLayoutConstraint *leading, NSLayoutConstraint *top) {
            _menuButtonLeadingConstraint = leading;
            _menuButtonTopConstraint = top;
        }];
    }
    else
    {
        [self.view addConstraintsForMenuButton:_menuButton
                                        offset: UIOffsetMake(menuButtonPortraitLeadingConstant, menuButtonPortraitLeadingConstant + statusbarHeight)
                                        result:^(NSLayoutConstraint *leading, NSLayoutConstraint *top) {
            _menuButtonLeadingConstraint = leading;
            _menuButtonTopConstraint = top;
        }];
    }
}

#pragma mark - GuillotineAnimationProtocol
- (CGFloat)navigationBarHeight
{
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if(UIDeviceOrientationIsLandscape(orientation))
    {
        return hostNavigationBarHeightLandscape;
    }
    else
    {
        return hostNavigationBarHeightPortrait;
    }
}

- (CGPoint)anchorPoint
{
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if(UIDeviceOrientationIsLandscape(orientation))
    {
        return CGPointMake(16, 16);
    }
    else
    {
        return self.menuButton.center;
    }
}

- (NSString *)hostTitle
{
    return self.hostTitleText;
}


#pragma mark - Action
- (IBAction)optionButtonClicked:(UIButton*)sender
{
   NSLog(@"%@", NSStringFromSelector(_cmd));
    [self dismissViewControllerAnimated: YES completion: nil];
    if(self.delegate && [self.delegate respondsToSelector:@selector(menuOptionTapped:)])
    {
        [self.delegate menuOptionTapped: sender.accessibilityLabel];
    }
}


#pragma mark - GuillotineAnimationDelegate
- (void)willStartPresentation
{
   NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)willStartDismissal
{
   NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)menuDidFinishPresentation
{
   NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)menuDidFinishDismissal
{
   NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)menuDidCollideWithBoundary
{
   NSLog(@"%@", NSStringFromSelector(_cmd));
}


@end

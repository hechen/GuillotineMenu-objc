//
//  ViewController.m
//  GuillotineMenu-objc
//
//  Created by hechen on 15/8/28.
//  Copyright (c) 2015年 hechen. All rights reserved.
//

#import "ViewController.h"
#import "GuillotineMenuViewController.h"

static NSString* reuseIdentifier = @"ContentCell";
static const CGFloat cellHeight = 210;
static const CGFloat cellSpacing = 20;

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, GuillotineMenuViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton* barButton;
@property (nonatomic, strong) NSString* destinationTitle;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINavigationBar* navBar = self.navigationController.navigationBar;
    navBar.barTintColor = [UIColor colorWithRed:65.0 / 255.0 green:62.f / 255.f blue:79.f / 255.f alpha:1];
    navBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    
    if([segue.destinationViewController isKindOfClass:[GuillotineMenuViewController class]])
    {
        GuillotineMenuViewController* destinationVC = segue.destinationViewController;
        destinationVC.hostNavigationBarHeight = self.navigationController.navigationBar.frame.size.height;
        destinationVC.hostTitleText           = self.navigationItem.title;
        destinationVC.view.backgroundColor    = self.navigationController.navigationBar.barTintColor;
        [destinationVC setMenuButtonWithImage:self.barButton.imageView.image];
        destinationVC.delegate = self;
    }
    else
    {
        UIViewController* destinationVC = segue.destinationViewController;
        destinationVC.title = self.destinationTitle;
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CGRectGetWidth(collectionView.bounds) - cellSpacing, cellHeight);
}

#pragma mark - GuillotineMenuViewControllerDelegate
- (void)menuOptionTapped:(NSString *)menuOption
{
    self.destinationTitle = menuOption;
    
    [self performSegueWithIdentifier:@"menuOptionSegueID" sender:self];
}


@end

//
//  HBUtilsBaseVC.m
//  HBUtils
//
//  Created by Hoang Ho on 10/18/19.
//  Copyright © 2019 HB. All rights reserved.
//

#import "HBUtilsBaseVC.h"
#import "HBDefineColor.h"
#import "HBUtilsMacros.h"

@interface HBUtilsBaseVC ()

@end

@implementation HBUtilsBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateStatusBar];
    
    self.navigationController.navigationBar.translucent = false;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self setupUI];
    
    if (self.title.length > 0) {
        self.title = self.title;
    }
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    self.titleHeaderLabel.text = title;
}

- (void)setupUI {
    //Do something
}

- (void)prepareForRelease
{
    [NTF_CENTER removeObserver:self];
}

- (IBAction)backAction:(id)sender
{
    [self prepareForRelease];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)closeAction:(id)sender
{
    [self prepareForRelease];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateStatusBar];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateStatusBar];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [[UIApplication sharedApplication] setStatusBarHidden:false withAnimation:UIStatusBarAnimationFade];
    } completion:nil];
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)dealloc
{
    [self prepareForRelease];
    DLog(@"DEALLOC");
}

-(BOOL)shouldAutorotate {
    // Preparations to rotate view go here
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (void)updateStatusBar {
    [[UIApplication sharedApplication] setStatusBarStyle:self.preferredStatusBarStyle animated:YES];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    UIViewController *vc = self;
    while (vc.presentedViewController) {
        vc = vc.presentedViewController;
    }
    if (vc == self) {
        [super presentViewController:viewControllerToPresent animated:flag completion:completion];
    }else {
        [vc presentViewController:viewControllerToPresent animated:flag completion:completion];
    }
}


@end

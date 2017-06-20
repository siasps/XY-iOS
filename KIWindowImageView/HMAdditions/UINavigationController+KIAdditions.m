//
//  UINavigationController+KIAdditions.m
//  Kitalker
//
//  Created by chen on 13-3-28.
//
//

#import "UINavigationController+KIAdditions.h"

#define kUINavigationControllerPullDownViewTag 917996697

@implementation UINavigationController (KIAdditions)


- (void)setNavBarClearColor{
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    
    self.navigationBar.translucent = YES;
    
    self.navigationBar.tintColor = [UIColor clearColor];
    self.navigationBar.barTintColor = [UIColor clearColor];
    
    [self.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    //去除navbar背景色和底部line（ShadowImage：看注释）
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
}


- (void)popToViewControllerAtIndex:(NSUInteger)index {
    NSUInteger count = [self viewControllers].count;
    if (index >= count-1) {
        return ;
    }
    
    [self popToViewController:[[self viewControllers] objectAtIndex:index]
                     animated:YES];
}


#pragma mark - pullDownView

- (void)pullDownView:(UIView *)view {
    UIView *currentPullDownView = [self.view viewWithTag:kUINavigationControllerPullDownViewTag];
    if (currentPullDownView == view) {
        [self hidePullDownView:view];
    }  else {
        [self showPullDownView:view];
    }
}

- (void)showPullDownView:(UIView *)view {
    UIView *currentPullDownView = [self.view viewWithTag:kUINavigationControllerPullDownViewTag];
    if (currentPullDownView != view) {
        if (currentPullDownView != nil) {
            [UIView animateWithDuration:0.3 animations:^{
                CGRect frame = currentPullDownView.frame;
                frame.origin.y = 0-frame.size.height;
                [currentPullDownView setFrame:frame];
            } completion:^(BOOL finished) {
                [view setFrame:currentPullDownView.frame];
                [currentPullDownView removeFromSuperview];
                
                __block CGRect frame = self.topViewController.view.frame;
                frame.origin.y = self.navigationBar.bounds.size.height;
                
                [self.view insertSubview:view belowSubview:self.navigationBar];
                
                [UIView animateWithDuration:0.3 animations:^{
                    frame.origin.y = self.navigationBar.bounds.size.height;
                    [view setFrame:frame];
                } completion:^(BOOL finished) {
                    [view setTag:kUINavigationControllerPullDownViewTag];
                }];
            }];
        } else {
            __block CGRect frame = self.visibleViewController.view.frame;
            frame.origin.y = 0-frame.size.height;
            [view setFrame:frame];
            [self.view insertSubview:view belowSubview:self.navigationBar];
            [UIView animateWithDuration:0.3 animations:^{
                frame.origin.y = self.navigationBar.bounds.size.height;
                [view setFrame:frame];
            } completion:^(BOOL finished) {
                [view setTag:kUINavigationControllerPullDownViewTag];
            }];
        }
    }
}

- (void)hidePullDownView:(UIView *)view {
    UIView *currentPullDownView = [self.view viewWithTag:kUINavigationControllerPullDownViewTag];
    if (currentPullDownView == view) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = currentPullDownView.frame;
            frame.origin.y = 0-frame.size.height;
            [currentPullDownView setFrame:frame];
        } completion:^(BOOL finished) {
            [currentPullDownView removeFromSuperview];
        }];
    }
}

- (void)clearPullDownView {
    UIView *currentPullDownView = [self.view viewWithTag:kUINavigationControllerPullDownViewTag];
    if (currentPullDownView) {
        [self hidePullDownView:currentPullDownView];
    }
}

@end

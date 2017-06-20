//
//  UINavigationController+KIAdditions.h
//  Kitalker
//
//  Created by chen on 13-3-28.
//  
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UINavigationController (KIAdditions)


- (void)setNavBarClearColor;

- (void)popToViewControllerAtIndex:(NSUInteger)index;


//--------pullDownView-----
- (void)pullDownView:(UIView *)view;

- (void)showPullDownView:(UIView *)view;

- (void)hidePullDownView:(UIView *)view;

- (void)clearPullDownView;


@end

//
//  UINavigationBar+KIAdditions.m
//  Homesick
//
//  Created by Huamo on 16/5/11.
//  Copyright © 2016年 Huamo. All rights reserved.
//

#import "UINavigationBar+KIAdditions.h"
#import <objc/runtime.h>


@implementation UINavigationBar (KIAdditions)
static char overlayKey;


#pragma mark - background color

//添加用于改变navbar颜色的层
- (UIView *)overlay
{
    return objc_getAssociatedObject(self, &overlayKey);
}

- (void)setOverlay:(UIView *)overlay
{
    objc_setAssociatedObject(self, &overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//设置navbar背景色
- (void)lt_setBackgroundColor:(UIColor *)backgroundColor
{
    if (!self.overlay) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, -20, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + 20)];
        self.overlay.userInteractionEnabled = NO;
        self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self insertSubview:self.overlay atIndex:0];
        
    }
    self.overlay.backgroundColor = backgroundColor;
}

//设置navbar的便宜，一般是向上偏移44
- (void)lt_setTranslationY:(CGFloat)translationY
{
    self.transform = CGAffineTransformMakeTranslation(0, translationY);
}


//设置navbar的item的alpha值
- (void)lt_setElementsAlpha:(CGFloat)alpha{
    [[self valueForKey:@"_leftViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
        view.alpha = alpha;
    }];
    
    [[self valueForKey:@"_rightViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
        view.alpha = alpha;
    }];
    
    UIView *titleView = [self valueForKey:@"_titleView"];
    titleView.alpha = alpha;
    //    when viewController first load, the titleView maybe nil
    [[self subviews] enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:NSClassFromString(@"UINavigationItemView")]) {
            obj.alpha = alpha;
            *stop = YES;
        }
    }];
}

//重设
- (void)lt_reset{
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.overlay removeFromSuperview];
    self.overlay = nil;
}



//添加分割线
- (void)lt_addNavbarBottomLine{
    //add by chen 添加一个分割线
    UIView *line = [[UIView alloc]init];
    line.frame = CGRectMake(0,CGRectGetHeight(self.bounds) + 20-0.5, SCREEN_WIDTH, 0.5);
    line.backgroundColor = [UIColor grayColor];
    [self.overlay addSubview:line];
    line.tag = 9999;
}

- (void)lt_removeNavbarBottomLine{
    UIView *line = (UIView *)[self.overlay viewWithTag:9999];
    
    if (line) {
        [line removeFromSuperview];
        line = nil;
    }
}


@end

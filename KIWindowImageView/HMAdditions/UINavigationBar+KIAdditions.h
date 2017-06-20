//
//  UINavigationBar+KIAdditions.h
//  Homesick
//
//  Created by Huamo on 16/5/11.
//  Copyright © 2016年 Huamo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (KIAdditions)

- (void)lt_setBackgroundColor:(UIColor *)backgroundColor;
- (void)lt_setElementsAlpha:(CGFloat)alpha;
- (void)lt_setTranslationY:(CGFloat)translationY;
- (void)lt_reset;

- (void)lt_addNavbarBottomLine;
- (void)lt_removeNavbarBottomLine;

@end

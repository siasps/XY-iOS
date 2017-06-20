//
//  HMNineImagesView.h
//  Homesick
//
//  Created by Huamo on 16/2/23.
//  Copyright © 2016年 Huamo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMNineImagesView : UIView

+ (CGFloat)getHeightWithData:(NSArray *)array;

- (void)reloadWithData:(NSArray *)array;

- (void)reloadAllImages:(NSArray *)array;


@end

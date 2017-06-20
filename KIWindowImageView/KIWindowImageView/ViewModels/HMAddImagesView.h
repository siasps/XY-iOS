//
//  HMAddImagesView.h
//  HuaxiajiaboApp
//
//  Created by HuamoMac on 15/10/12.
//  Copyright © 2015年 HuaMo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HMAddImagesViewDelegate;

@interface HMAddImagesView : UIView{
    
}
@property (nonatomic,weak) id<HMAddImagesViewDelegate> delegate;
@property (nonatomic,assign) NSUInteger maxImageNumber;

- (void)reloadWithImages:(NSArray *)images;
+ (CGFloat)getViewheight:(NSArray *)array;
- (NSArray *)getImagesArray;


@end


@protocol HMAddImagesViewDelegate <NSObject>

//actionType:1,add 2,delete 3，收起键盘
- (void)addImagesView:(HMAddImagesView *)addImagesView actionType:(NSInteger)actionType object:(id)object;

@end

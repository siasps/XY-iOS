//
//  HMLeftMenuView.h
//  HuaxiajiaboApp
//
//  Created by HuamoMac on 15/10/9.
//  Copyright © 2015年 HuaMo. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HMLeftMenuViewDelegate;

@interface HMLeftMenuView : UIView

- (id)initWithDelegate:(id<HMLeftMenuViewDelegate>)delegate dataArray:(NSArray *)dataArray;

- (void)show;

- (void)setCurrentStageName:(NSDictionary *)dict;
- (void)setHasBeginStageNum:(NSArray *)hasStageArray;

@end

@protocol HMLeftMenuViewDelegate <NSObject>

- (void)leftMenuView:(HMLeftMenuView *)leftMenuView didSelectedIndex:(NSInteger)index;

@end

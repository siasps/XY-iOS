//
//  HMWindowDefaultImageView.h
//  HuaxiajiaboApp
//
//  Created by HuamoMac on 15/10/20.
//  Copyright © 2015年 HuaMo. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HMWindowDefaultImageViewDelegate;

@interface HMWindowDefaultImageView : UIView{
    
}
@property (nonatomic,weak) id<HMWindowDefaultImageViewDelegate> delegate;


+ (void)showImageWithURLStringArray:(NSArray*)aImageInformationArray selectedIndex:(NSInteger)index originRect:(CGRect)originRect delegate:(id<HMWindowDefaultImageViewDelegate>)delegate;


@end



@protocol HMWindowDefaultImageViewDelegate <NSObject>

@optional

- (void)windowDefaultImageView:(HMWindowDefaultImageView *)windowDefaultImageView deleteIndex:(NSInteger)deleteIndex finished:(BOOL)finished;

@end
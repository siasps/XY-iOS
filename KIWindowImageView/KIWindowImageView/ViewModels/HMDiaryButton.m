//
//  HMDiaryButton.m
//  Huaxiajiabo
//
//  Created by Huamo on 2016/11/30.
//  Copyright © 2016年 Huamo. All rights reserved.
//

#import "HMDiaryButton.h"

@implementation HMDiaryButton

-(id)init
{
    self=[super init];
    if (self) {
        //1设置文字属性
        self.titleLabel.textAlignment=NSTextAlignmentCenter;
        self.titleLabel.font=[UIFont systemFontOfSize:10];
        
        //2设置图片属性
        self.imageView.contentMode=UIViewContentModeScaleAspectFit;
        //self.adjustsImageWhenHighlighted=NO;
        
        
    }
    return self;
}

//-(void)setHighlighted:(BOOL)highlighted{
//    
//}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(2, (contentRect.size.height-16)/2.0, 16, 16);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleY=(contentRect.size.height - 15)/2.0;
    CGFloat titleHeight = 15;
    return CGRectMake(18, titleY, contentRect.size.width-20, titleHeight);
}




@end


@implementation HMDiaryNavButton

-(id)init
{
    self=[super init];
    if (self) {
        //1设置文字属性
        self.titleLabel.textAlignment=NSTextAlignmentCenter;
        self.titleLabel.font=[UIFont systemFontOfSize:10];
        
        //2设置图片属性
        self.imageView.contentMode=UIViewContentModeScaleAspectFit;
        self.adjustsImageWhenHighlighted=NO;
        
        
    }
    return self;
}

-(void)setHighlighted:(BOOL)highlighted{
    
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleY=contentRect.size.height/2.0 + 6;
    CGFloat titleHeight = 10;
    return CGRectMake(0, titleY, contentRect.size.width, titleHeight);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake((contentRect.size.width-20)/2.0, contentRect.size.height-22-14, 20, 20);
}



@end





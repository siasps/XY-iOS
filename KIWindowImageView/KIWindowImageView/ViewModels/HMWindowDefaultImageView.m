//
//  HMWindowDefaultImageView.m
//  HuaxiajiaboApp
//
//  Created by HuamoMac on 15/10/20.
//  Copyright © 2015年 HuaMo. All rights reserved.
//

#import "HMWindowDefaultImageView.h"
#import "KIPageScrollView.h"
#import "KKPageControl.h"



@interface HMWindowDefaultImageView () <KIPageScrollViewDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate> {
    
}
@property (nonatomic,strong)KKPageControl *myPageControl;
@property (nonatomic,assign)BOOL nowImageIsGIF;
@property (nonatomic,assign)CGRect orginRect;
@property (nonatomic,strong)KIPageScrollView *myPageView;
@property (nonatomic,strong) NSMutableArray *imageArray;
@property (nonatomic,strong) UILabel *numLabel;
@property (nonatomic,assign) NSInteger currPage;

@end

@implementation HMWindowDefaultImageView

+ (void)showImageWithURLStringArray:(NSArray*)aImageInformationArray selectedIndex:(NSInteger)index originRect:(CGRect)originRect delegate:(id<HMWindowDefaultImageViewDelegate>)delegate{
    if (aImageInformationArray && [aImageInformationArray isKindOfClass:[NSArray class]]
        && [aImageInformationArray count]>0) {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        HMWindowDefaultImageView *windowImageView = [[HMWindowDefaultImageView alloc]initWithFrame:window.bounds imageArray:aImageInformationArray selectedIndex:index originRect:originRect];
        windowImageView.delegate = delegate;
        [window addSubview:windowImageView];
        [window bringSubviewToFront:windowImageView];
    }
    
}

- (id)initWithFrame:(CGRect)frame imageArray:(NSArray*)aImageInformationArray selectedIndex:(NSInteger)index originRect:(CGRect)originRect{
    self = [super initWithFrame:frame];
    if (self) {
        _imageArray = [[NSMutableArray alloc]init];
        [_imageArray addObjectsFromArray:aImageInformationArray];
        
        _orginRect = originRect;
        _currPage = index;
        
        self.backgroundColor = [UIColor blackColor];
        self.clipsToBounds = YES;
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        
        _myPageView = [[KIPageScrollView alloc] initWithFrame:self.bounds pageSpace:10];
        _myPageView.delegate = self;
        //[_myPageView showPageIndex:index animated:NO];
        [_myPageView setBackgroundColor:[UIColor clearColor]];
        _myPageView.clipsToBounds = YES;
        [self addSubview:_myPageView];
        [_myPageView reloadData];
        [_myPageView scrollToIndex:index animated:NO];
        
        _numLabel = [[UILabel alloc] init];
        _numLabel.backgroundColor = [UIColor clearColor];
        _numLabel.frame = CGRectMake(0, self.height - 40, self.width, 20);
        _numLabel.font = [UIFont systemFontOfSize:16];
        _numLabel.textColor = [UIColor whiteColor];
        _numLabel.textAlignment = NSTextAlignmentCenter;
        _numLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)index+1, (unsigned long)_imageArray.count];
        [self addSubview:_numLabel];
        
        if (originRect.origin.x!=0 && originRect.origin.y!=0) {
            self.center = CGPointMake(originRect.origin.x+originRect.size.width/2.0, originRect.origin.y+originRect.size.height/2.0);
        }
        self.transform = CGAffineTransformScale(self.transform, 0.1, 0.1);
        [UIView beginAnimations:nil context:(__bridge void *)(self)];
        [UIView setAnimationDuration: 0.3];
        self.transform = CGAffineTransformScale(self.transform, 10, 10);
        self.center = [[[[UIApplication sharedApplication] delegate] window]center];
        [UIView commitAnimations];
        
    }
    return self;
}


#pragma mark - 消失自己

//隐藏自己
-(void) cancelSelf{
    
    
    if (_delegate && [_delegate respondsToSelector:@selector(windowDefaultImageView:deleteIndex:finished:)]) {
        [_delegate windowDefaultImageView:self deleteIndex:-1 finished:YES];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformScale(self.transform, 1.0, 1.0);
        self.transform = CGAffineTransformScale(self.transform, 0.1, 0.1);
        if (_orginRect.origin.x!=0 && _orginRect.origin.y!=0) {
            self.center = CGPointMake(_orginRect.origin.x+_orginRect.size.width/2.0, _orginRect.origin.y+_orginRect.size.height/2.0);
        }
        
    } completion:^(BOOL finished) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [self removeFromSuperview];
    }];
}


#pragma mark - KIPageScrollViewDelegate

- (UIView*)pageView:(KIPageScrollView*)pageView viewForPage:(NSInteger)pageIndex{
    UIImageView *itemView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    itemView.userInteractionEnabled = YES;
    itemView.contentMode = UIViewContentModeScaleAspectFit;
    itemView.backgroundColor = [UIColor clearColor];
    
    NSString *imageStr = [_imageArray objectAtIndex:pageIndex];
    if ([imageStr rangeOfString:@"http"].location == NSNotFound) {
        itemView.image = [UIImage imageWithContentsOfFile:imageStr];
    }else{
        [itemView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"default640x640.png"]];
    }
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    tapGestureRecognizer.delegate = self;
    [itemView addGestureRecognizer:tapGestureRecognizer];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(SCREEN_WIDTH-50, 20, 40, 40);
    [deleteBtn setImage:[UIImage imageNamed:@"delete_image.png"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [itemView addSubview:deleteBtn];
    
    
    return itemView;
}

- (NSInteger)numberOfPagesInPageView:(KIPageScrollView*)pageView{
    return [_imageArray count];
}

- (BOOL)pageViewCanRepeat:(KIPageScrollView*)pageView{
    return NO;
}

- (void)pageView:(KIPageScrollView*)pageView didScrolledToPageIndex:(NSInteger)pageIndex{
    _myPageControl.currentPage = pageIndex;
    
    _currPage = pageIndex;
    _numLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)pageIndex+1, (unsigned long)_imageArray.count];
    
//    UIImageView *itemView = (UIImageView*)[_myPageView viewForPageIndex:pageIndex];
//    [itemView.myScrollView setZoomScale:1.0 animated:NO];
}


- (void)singleTap:(UITapGestureRecognizer *)gesture{
    [self cancelSelf];
}



- (void)deleteButtonClick:(UIButton *)button{
    
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"删除图片?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self deleteImage];
    }
}

- (void)deleteImage{
    NSInteger index = _currPage;
    
    
    
    NSInteger nextIndex = index - 1;
    if (_imageArray.count == 1) {
        [self cancelSelf];
        
        
        if (_delegate && [_delegate respondsToSelector:@selector(windowDefaultImageView:deleteIndex:finished:)]) {
            [_delegate windowDefaultImageView:self deleteIndex:index finished:YES];
        }
        
        return;
    }
    
    if (index == 0){
        nextIndex = 0;
    }
    
    [_imageArray removeObjectAtIndex:index];
    _myPageView.currentPageIndex = nextIndex;
    [_myPageView reloadData];
    
    //    _myPageControl.numberOfPages = [_imageArray count];
    //    _myPageControl.currentPage = nextIndex;;
    
    _currPage = nextIndex;
    _numLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)nextIndex+1, (unsigned long)_imageArray.count];
    //[_myPageView showPageIndex:_currPage animated:YES];
    [_myPageView scrollToIndex:_currPage animated:YES];
    
    if (_delegate && [_delegate respondsToSelector:@selector(windowDefaultImageView:deleteIndex:finished:)]) {
        [_delegate windowDefaultImageView:self deleteIndex:index finished:NO];
    }
}

@end

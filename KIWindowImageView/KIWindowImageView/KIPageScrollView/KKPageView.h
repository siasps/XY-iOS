//
//  PageView.h
//  PageView
//
//  Created by 刘 波 on 13-6-17.
//  Copyright (c) 2013年 可可工作室. All rights reserved.
//

#import <UIKit/UIKit.h>


#define VIEW_TAG 9990

typedef enum {
    ScrollDirectionNone = 0,
    ScrollDirectionLeft = 1,
    ScrollDirectionRight = 2
}ScrollDirection;

@protocol KKPageViewDelegate ;

@interface KKPageView : UIView{
    CGFloat nowX;
}

@property(nonatomic,strong)UIScrollView *mainScrollView;
@property(nonatomic,assign)NSInteger currentPageIndex;
@property(nonatomic,assign)CGFloat nowX;

- (id)initWithFrame:(CGRect)frame delegate:(id<KKPageViewDelegate>)aDelegate showIndex:(NSInteger)index;

- (void)reloadPagesForInsertObjectsAtFront:(NSInteger)objectsCount;
- (void)reloadPagesForInsertObjectsAtBehind:(NSInteger)objectsCount;

- (UIView*)viewForPageIndex:(NSInteger)pageIndex;

- (void)selectedPage:(NSInteger)selectedPage;
- (void)reloadPages;

- (void)scrollToIndex:(NSInteger)index;
- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated;


@end


#pragma mark ==================================================
#pragma mark ==代理
#pragma mark ==================================================
@protocol KKPageViewDelegate <NSObject>

@required
- (UIView*)pageView:(KKPageView*)pageView viewForPage:(NSInteger)pageIndex;

- (NSInteger)pageViewTotalPages:(KKPageView*)pageView;

- (BOOL)pageViewCanRepeat:(KKPageView*)pageView;

@optional

- (void)pageView:(KKPageView*)pageView didScrolledToPageIndex:(NSInteger)pageIndex;


@end

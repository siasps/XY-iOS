//
//  PageView.m
//  PageView
//
//  Created by 刘 波 on 13-6-17.
//  Copyright (c) 2013年 可可工作室. All rights reserved.
//

#import "KKPageView.h"

#pragma mark ==================================================
#pragma mark ==私有扩展
#pragma mark ==================================================
@interface KKPageView ()<UIScrollViewDelegate>

@property(nonatomic,assign)id<KKPageViewDelegate> delegate;


@end

@implementation KKPageView
@synthesize mainScrollView;
@synthesize delegate;
@synthesize currentPageIndex;
@synthesize nowX;


- (id)initWithFrame:(CGRect)frame delegate:(id<KKPageViewDelegate>)aDelegate showIndex:(NSInteger)index{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = aDelegate;
        currentPageIndex = index;
        nowX = 0;
        
        mainScrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        mainScrollView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        mainScrollView.pagingEnabled = YES;
        mainScrollView.delegate = self;
        mainScrollView.backgroundColor = [UIColor clearColor];
        [mainScrollView setShowsHorizontalScrollIndicator:NO];
        [self addSubview:mainScrollView];
        
        [self reloadPagesWithNewShowPageNumber:currentPageIndex animated:NO];
    }
    return self;
}

- (void)reloadPagesForInsertObjectsAtFront:(NSInteger)objectsCount{
    for (UIView *view in [mainScrollView subviews]) {
        view.tag = view.tag + objectsCount;
    }
    currentPageIndex = currentPageIndex + objectsCount;
    [self reloadPagesWithNewShowPageNumber:currentPageIndex animated:NO];
    
}

- (void)reloadPagesForInsertObjectsAtBehind:(NSInteger)objectsCount{
    
    [self reloadPagesWithNewShowPageNumber:currentPageIndex animated:NO];
}

- (UIView*)viewForPageIndex:(NSInteger)pageIndex{
    UIView *view = [mainScrollView viewWithTag:VIEW_TAG + pageIndex];
    return view;
}

- (void)selectedPage:(NSInteger)selectedPage{
    currentPageIndex = selectedPage;
    [self reloadPagesWithNewShowPageNumber:currentPageIndex animated:NO];
}

- (void)reloadPages{
    //移除全部
    for (UIView *view in [mainScrollView subviews]) {
        [view removeFromSuperview];
    }
    
    [self reloadPagesWithNewShowPageNumber:0 animated:NO];
}

- (void)scrollToIndex:(NSInteger)index{
    [self scrollToIndex:index animated:NO];
}

- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated{
    [self reloadPagesWithNewShowPageNumber:index animated:animated];
}


#pragma mark ==================================================
#pragma mark ==装载页面
#pragma mark ==================================================


- (NSInteger)getValidNextPageIndexWithPageIndex:(NSInteger)currentIndex{
    NSInteger totalPage = [self.delegate pageViewTotalPages:self];
    
    if (currentIndex == -2) {
        return totalPage - 2;
    }else if (currentIndex == -1){
        return totalPage - 1;
    }else if (currentIndex == totalPage){
        return 0;
    }else if (currentIndex == totalPage + 1){
        return 1;
    }else {
        return currentIndex;
    }
}
- (void)reloadPagesWithNewShowPageNumber:(NSInteger)pageNum animated:(BOOL)animated{
    NSInteger pageCount = [self.delegate pageViewTotalPages:self];
    
    
    
    switch (pageCount) {
        case 0:{
            break;
        }
        case 1:{
            mainScrollView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
            
            UIView *willShowView= [mainScrollView viewWithTag:0+VIEW_TAG];
            if (!willShowView) {
                willShowView = [self.delegate pageView:self viewForPage:0];
                willShowView.tag = 0+VIEW_TAG;
                [mainScrollView addSubview:willShowView];
            }
            [mainScrollView scrollRectToVisible:CGRectZero animated:animated];
            currentPageIndex = 0;
            
            break;
        }
        default:{
            [self reloadPages_WithNewShowPageNumber:pageNum animated:animated];
            break;
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(pageView:didScrolledToPageIndex:)]) {
        [self.delegate pageView:self didScrolledToPageIndex:currentPageIndex];
    }
}

- (void)reloadPages_WithNewShowPageNumber:(NSInteger)pageNum animated:(BOOL)animated{
    BOOL canRepeat = [self.delegate pageViewCanRepeat:self];
    NSInteger pageCount = [self.delegate pageViewTotalPages:self];
    
    currentPageIndex = pageNum;
    
    if (canRepeat) {
        
        NSInteger previousPageIndex2 = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 2];
        NSInteger previousPageIndex1 = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
        NSInteger rearPageIndex1 = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
        NSInteger rearPageIndex2 = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 2];
        
        
        NSMutableArray *arrary = [NSMutableArray array];
        if (pageCount == 2 || pageCount == 3) {
            mainScrollView.contentSize = CGSizeMake(self.frame.size.width*3, self.frame.size.height);
            [arrary addObject:[self.delegate pageView:self viewForPage:previousPageIndex1]];
            [arrary addObject:[self.delegate pageView:self viewForPage:currentPageIndex]];
            [arrary addObject:[self.delegate pageView:self viewForPage:rearPageIndex1]];
        }else if(pageCount == 4){
            mainScrollView.contentSize = CGSizeMake(self.frame.size.width*4, self.frame.size.height);
            [arrary addObject:[self.delegate pageView:self viewForPage:previousPageIndex1]];
            [arrary addObject:[self.delegate pageView:self viewForPage:currentPageIndex]];
            [arrary addObject:[self.delegate pageView:self viewForPage:rearPageIndex1]];
            [arrary addObject:[self.delegate pageView:self viewForPage:rearPageIndex2]];
        }else{
            mainScrollView.contentSize = CGSizeMake(self.frame.size.width*5, self.frame.size.height);
            [arrary addObject:[self.delegate pageView:self viewForPage:previousPageIndex2]];
            [arrary addObject:[self.delegate pageView:self viewForPage:previousPageIndex1]];
            [arrary addObject:[self.delegate pageView:self viewForPage:currentPageIndex]];
            [arrary addObject:[self.delegate pageView:self viewForPage:rearPageIndex1]];
            [arrary addObject:[self.delegate pageView:self viewForPage:rearPageIndex2]];
        }
        
        
        //移除全部
        for (UIView *view in [mainScrollView subviews]) {
            [view removeFromSuperview];
        }
        
        //重新添加
        for (int i=0; i<[arrary count]; i++) {
            UIView *willShowView = [arrary objectAtIndex:i];
            CGRect frame = willShowView.frame;
            willShowView.frame = CGRectMake(self.frame.size.width*i+((NSInteger)frame.origin.x)%((int)(self.frame.size.width)), frame.origin.y, frame.size.width, frame.size.height);
            [mainScrollView addSubview:willShowView];
        }
        
        if (arrary.count >= 5) {
            [mainScrollView scrollRectToVisible:CGRectMake(self.frame.size.width*2, 0, self.frame.size.width, self.frame.size.height) animated:animated];
        }else{
            [mainScrollView scrollRectToVisible:CGRectMake(self.frame.size.width*1, 0, self.frame.size.width, self.frame.size.height) animated:animated];
        }
        
        
        nowX = mainScrollView.contentOffset.x;
    }else{
        mainScrollView.contentSize = CGSizeMake(self.frame.size.width * pageCount, self.frame.size.height);
        
        for (int i = 0; i < pageCount; i++) {
            UIView *willShowView = [mainScrollView viewWithTag:i+VIEW_TAG];
            if (!willShowView) {
                willShowView = [self.delegate pageView:self viewForPage:i];
                willShowView.tag = i+VIEW_TAG;
                
                CGRect frame01 = willShowView.frame;
                CGFloat originX = self.frame.size.width*i+((NSInteger)frame01.origin.x)%((int)(self.frame.size.width));
                willShowView.frame = CGRectMake(originX, frame01.origin.y, frame01.size.width, frame01.size.height);
                [mainScrollView addSubview:willShowView];
            }
        }
        
        
        [mainScrollView scrollRectToVisible:CGRectMake(self.frame.size.width * pageNum, 0, self.frame.size.width, self.frame.size.height) animated:animated];
        
        nowX = mainScrollView.contentOffset.x;
        
    }
    
}

#pragma mark ==================================================
#pragma mark ==滚动处理
#pragma mark ==================================================
- (void)scrollViewDidScrolledWithDirection:(ScrollDirection)direction scrollPages:(NSInteger)pages{
    
    switch (direction) {
        case ScrollDirectionNone:{
            break;
        }
        case ScrollDirectionLeft:{
            
            NSInteger pageNum = currentPageIndex - pages;
            
            NSInteger count = [self.delegate pageViewTotalPages:self];
            if (pageNum<0) {
                pageNum = pageNum + count;
            }
            [self reloadPagesWithNewShowPageNumber:pageNum animated:NO];
            currentPageIndex = pageNum;
            
            break;
        }
        case ScrollDirectionRight:{
            NSInteger pageNum = currentPageIndex + pages;
            
            NSInteger count = [self.delegate pageViewTotalPages:self];
            
            if (pageNum>count-1) {
                pageNum = pageNum - count;
            }
            [self reloadPagesWithNewShowPageNumber:pageNum animated:NO];
            currentPageIndex = pageNum;
            
            break;
        }
        default:
            break;
    }
}


#pragma mark ==================================================
#pragma mark ==UIScrollViewDelegate
#pragma mark ==================================================
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger scrollPages =  ABS(scrollView.contentOffset.x - nowX)/self.frame.size.width;
    
    if (scrollView.contentOffset.x<nowX) {
        [self scrollViewDidScrolledWithDirection:ScrollDirectionLeft scrollPages:scrollPages];
    }
    else if (scrollView.contentOffset.x==nowX){
        [self scrollViewDidScrolledWithDirection:ScrollDirectionNone scrollPages:scrollPages];
    }
    else{
        [self scrollViewDidScrolledWithDirection:ScrollDirectionRight scrollPages:scrollPages];
    }
}




@end

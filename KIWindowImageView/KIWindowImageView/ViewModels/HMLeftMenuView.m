//
//  HMLeftMenuView.m
//  HuaxiajiaboApp
//
//  Created by HuamoMac on 15/10/9.
//  Copyright © 2015年 HuaMo. All rights reserved.
//

#import "HMLeftMenuView.h"


@interface HMLeftMenuView () {
    
}
@property (nonatomic,weak) id<HMLeftMenuViewDelegate> delegate;
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataArray;

@property (nonatomic,assign) NSInteger currIndex;
@property (nonatomic,strong) NSDictionary *currDict;
@property (nonatomic,strong) NSArray *hasBenginArray;

@property (nonatomic,assign) CGFloat bWidth;

@end



@implementation HMLeftMenuView

- (id)initWithDelegate:(id<HMLeftMenuViewDelegate>)delegate dataArray:(NSArray *)dataArray{
    self = [super init];
    if (self) {
        _delegate = delegate;
        _dataArray = [[NSArray alloc]initWithArray:dataArray];
        if (SCREEN_SCALE>1) {
            _bWidth = 50.0f;
        }else{
            _bWidth = 40.0f;
        }
        
        [self customInit];
    }
    return self;
}


#pragma mark - 

- (void)show{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self];
    
    
    NSInteger count = _dataArray.count;
    for (NSInteger i = 0; i<count; i++) {
        UIButton *button = (UIButton *)[_backView viewWithTag:i+1200];
        
        NSInteger index = count-i;
        
        [UIView animateWithDuration:0.1*index
                              delay:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
            
            [button setOriginY:SCREEN_HEIGHT-100 - (_bWidth+10)*index];
        } completion:^(BOOL finished) {
            
        }];
        
    }
    
    
}

- (void)dismiss{
    
    NSInteger count = _dataArray.count;
    for (NSInteger i = 0; i<count; i++) {
        UIButton *button = (UIButton *)[_backView viewWithTag:i+1200];
        
        NSInteger index = count-i;
        
        [UIView animateWithDuration:0.1*index animations:^{
            
            [button setOriginY:SCREEN_HEIGHT-100];
        } completion:^(BOOL finished) {
            
            if (index == _dataArray.count) {
                self.hidden = YES;
                [self removeFromSuperview];
            }
        }];
        
        
    }
    
}

#pragma mark - 数据显示处理

- (void)setCurrentStageName:(NSDictionary *)dict{
    _currDict = [[NSDictionary alloc]initWithDictionary:dict];
    _currIndex = -1;
    
    NSString *name = [_currDict stringValueForKey:@"stage_id"];
    for (NSInteger i=0; i<_dataArray.count; i++) {
        NSDictionary *dict = [_dataArray objectAtIndex:i];
        NSString *tempName = [dict stringValueForKey:JSON_NODE_category_id];
        if ([name isEqualToString:tempName]) {
            _currIndex = i;
            break;
        }
    }
    
    
    [self reloadSubviews];
}

- (void)setHasBeginStageNum:(NSArray *)hasStageArray{
    _hasBenginArray = [[NSArray alloc]initWithArray:hasStageArray];
    
    [self reloadSubviews];
}

- (void)reloadSubviews{
    
    NSInteger count = _dataArray.count;
    for (NSInteger i = count-1; i>=0; i--) {
        UIButton *button = (UIButton *)[_backView viewWithTag:1200+i];
        NSDictionary *dict = [_dataArray objectAtIndex:i];
        
        NSString *name = [dict stringValueForKey:JSON_NODE_category_id];
        BOOL hasThis = NO;
        for (NSInteger i=0; i<_hasBenginArray.count; i++) {
            NSDictionary *dictTemp = [_hasBenginArray objectAtIndex:i];
            NSString *tempName = [dictTemp stringValueForKey:@"stage_id"];
            if ([name isEqualToString:tempName]) {
                hasThis = YES;
                break;
            }
        }
        
        
        if (!hasThis) {
            
            [button setTitleColor:TextColor_3 forState:UIControlStateNormal];
            button.layer.borderColor = TextColor_3.CGColor;
            button.backgroundColor = [UIColor colorWithWhite:0.95 alpha:0.7];
        }else{
            
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.layer.borderColor = [UIColor whiteColor].CGColor;
            button.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.7];
        }
    }
}


#pragma mark - init


- (void)customInit{
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    
    _backView = [[UIView alloc] init];
    _backView.frame = self.bounds;
    _backView.backgroundColor = [UIColor clearColor];
    _backView.userInteractionEnabled = YES;
    [self addSubview:_backView];
    
    UIButton *disButton = [UIButton buttonWithType:UIButtonTypeCustom];
    disButton.frame = self.bounds;
    [disButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    //disButton.backgroundColor = [UIColor grayColor];
    disButton.tag = 1100;
    [_backView addSubview:disButton];
    
    
    NSInteger count = _dataArray.count;
    for (NSInteger i = count-1; i>=0; i--) {
        
        NSDictionary *dict = [_dataArray objectAtIndex:i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(SCREEN_WIDTH-50-15, SCREEN_HEIGHT-100, _bWidth, _bWidth);
        [button setTitle:[dict stringValueForKey:JSON_NODE_category_name] forState:UIControlStateNormal];
        if (SCREEN_SCALE>1) {
            
            button.titleLabel.font = [UIFont systemFontOfSize:14];
        }else{
            
            button.titleLabel.font = [UIFont systemFontOfSize:13];
        }
        [button addTarget:self action:@selector(stageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.7];
        button.tag = 1200+i;
        [_backView addSubview:button];
        button.layer.cornerRadius = _bWidth/2.0f;
        button.layer.borderWidth = 1.0f;
        button.layer.masksToBounds = YES;
        
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        button.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.7];
        
        NSString *name = [dict stringValueForKey:JSON_NODE_category_id];
        BOOL hasThis = NO;
        for (NSInteger i=0; i<_hasBenginArray.count; i++) {
            NSDictionary *dictTemp = [_hasBenginArray objectAtIndex:i];
            NSString *tempName = [dictTemp stringValueForKey:@"stage_id"];
            if ([name isEqualToString:tempName]) {
                hasThis = YES;
                break;
            }
        }
        
        
        if (!hasThis) {
            
            [button setTitleColor:TextColor_3 forState:UIControlStateNormal];
            button.layer.borderColor = TextColor_3.CGColor;
            button.backgroundColor = [UIColor colorWithWhite:0.95 alpha:0.7];
        }
        
        
        if (_currIndex == i) {
            //titleView.textColor = RGB_COLOR_String(@"#FF4A4B");
        }
        
    }
    
}

- (void)stageButtonClick:(UIButton *)button{
    NSInteger index = button.tag - 1200;
    
    NSDictionary *dict = [_dataArray objectAtIndex:index];
    NSString *name = [dict stringValueForKey:JSON_NODE_category_id];
    
    BOOL hasThis = NO;
    for (NSInteger i=0; i<_hasBenginArray.count; i++) {
        NSDictionary *dict = [_hasBenginArray objectAtIndex:i];
        NSString *tempName = [dict stringValueForKey:@"stage_id"];
        if ([name isEqualToString:tempName]) {
            hasThis = YES;
            break;
        }
    }
    if (!hasThis) {
        return;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(leftMenuView:didSelectedIndex:)]) {
        [_delegate leftMenuView:self didSelectedIndex:index];
    }
    [self dismiss];
    
}






@end

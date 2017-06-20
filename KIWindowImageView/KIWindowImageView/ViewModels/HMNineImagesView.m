//
//  HMNineImagesView.m
//  Homesick
//
//  Created by Huamo on 16/2/23.
//  Copyright © 2016年 Huamo. All rights reserved.
//

#import "HMNineImagesView.h"
#import "KIWindowImageView.h"

#define SubNineImageView_Tag  9989


@interface HMNineImagesView () {
    
}
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSArray *allImages;

@end



@implementation HMNineImagesView


- (id)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
        self.clipsToBounds = YES;
        
        _dataArray = [[NSMutableArray alloc]init];
        
    }
    return self;
}


+ (CGFloat)getHeightWithData:(NSArray *)array{
    if (array.count<=0) {
        return 0;
    }
    
    NSInteger rowCount = ceil(array.count / 3.0f);
    
    return rowCount *(55*SCREEN_SCALE + 10) - 10;
}

- (void)reloadWithData:(NSArray *)array{
    [_dataArray removeAllObjects];
    
    [_dataArray addObjectsFromArray:array];
    
    CGFloat width = (SCREEN_WIDTH - 50)/3.0;
    CGFloat padding = 10;
    CGFloat heiht = 55 * SCREEN_SCALE;
    
    
    for (UIImageView *imageView in self.subviews) {
        if ([imageView isKindOfClass:[UIImageView class]]) {
            imageView.hidden = YES;
        }
    }
    
    if (_dataArray.count <=0) {
        [self setHeight:0];
        return;
    }
    
    for (NSInteger i=0; i<_dataArray.count; i++) {
        NSInteger rowV = i%3;
        NSInteger rowH = i/3;
        
        if (_dataArray.count==4) {
            rowV = i % 2;
            rowH = i / 2;
        }
        
        NSDictionary *dict = [_dataArray objectAtIndex:i];
        NSString *small_image_url = [dict stringValueForKey:@"small_image_url"];
        small_image_url = [small_image_url trimWhitespace];
        if (small_image_url.length <= 0) {
            small_image_url = [NSString stringWithFormat:@"%@?imageView2/2/w/200/h/200", [dict stringValueForKey:@"image_url"]];
        }
        
        
        
        
        UIImageView *imageView = (UIImageView *)[self viewWithTag:SubNineImageView_Tag+i];
        if (!imageView) {
            imageView = [[UIImageView alloc]init];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            [self addSubview:imageView];
            imageView.tag = SubNineImageView_Tag+i;
            
            
            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(seeLargeImage:)];
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:gesture];
        }
        
        imageView.hidden = NO;
        imageView.frame = CGRectMake((width+padding)*rowV, (heiht+padding)*rowH, width, heiht);
        [imageView sd_setImageWithURL:[NSURL URLWithString:small_image_url] placeholderImage:[UIImage imageNamed:@"default640x300.png"]];
    }
    
    NSInteger rowCount = ceil(array.count / 3.0f);
    
    CGFloat selfheight=  rowCount *(55*SCREEN_SCALE + 10) - 10;
    
    [self setHeight:selfheight];
}

- (void)reloadAllImages:(NSArray *)array{
    if (!array || array.count<=0) {
        return;
    }
    
    _allImages = [[NSArray alloc]initWithArray:array];
}



//点击第4张图片，查看更多
- (void)seeMoreImages{
    
}

- (void)seeLargeImage:(id)sender{
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *)sender;
    UIImageView *button = (UIImageView *)gesture.view;
    
    NSInteger index = button.tag-SubNineImageView_Tag;
    NSInteger tempIndex = 0;
    NSArray *images = nil;
    NSInteger indexSpace = 0;
    if (_allImages && _allImages.count>0) {
        images = _allImages;
        
        NSDictionary *dict = [_dataArray objectAtIndex:index];
        for (NSInteger i=0; i<_allImages.count; i++) {
            NSDictionary *tempDict = [_allImages objectAtIndex:i];
            if ([tempDict isEqual:dict]) {
                tempIndex = i;
                indexSpace = tempIndex - index;//当前view前面有几个图片
                break;
            }
        }
    }else{
        tempIndex = index;
        indexSpace = 0;
        images = _dataArray;
    }
    
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (NSInteger i=0; i<images.count; i++) {
        NSDictionary *dict = [images objectAtIndex:i];
        
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
        [dictionary setObject:[dict stringValueForKey:@"image_url"] forKey:KIWindowImageView_URL];
        
        if (i-indexSpace>=0 && i-indexSpace<_dataArray.count) {
            UIImageView *imageView = (UIImageView *)[self viewWithTag:SubNineImageView_Tag+i-indexSpace];

            if (imageView.image) {
                [dictionary setObject:imageView.image forKey:KIWindowImageView_PlaceHolderImage];
            }else{
                [dictionary setObject:[UIImage imageNamed:@"default640x300.png"] forKey:KIWindowImageView_PlaceHolderImage];
            }
        }else{
            [dictionary setObject:[UIImage imageNamed:@"default640x300.png"] forKey:KIWindowImageView_PlaceHolderImage];
        }
        
        
        
        [array addObject:dictionary];
    }
    
    CGRect rect = [button convertRect:button.bounds toView:nil];
    [KIWindowImageView showWithImageArray:array selectedIndex:tempIndex originRect:rect];
    
    //[KIWindowImageView showImageWithURLStringArray:array selectedIndex:index originRect:rect];
}



@end

//
//  ViewController.m
//  KIWindowImageView
//
//  Created by peng on 2017/5/22.
//  Copyright © 2017年 peng. All rights reserved.
//

#import "ViewController.h"
#import "HMNineImagesView.h"

@interface ViewController ()
@property (nonatomic,strong) HMNineImagesView *imagesView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _imagesView = [[HMNineImagesView alloc]init];
    [self.view addSubview:_imagesView];
    
    NSString *imageUrl = @"https://img.hxjbcdn.com/8df19a3a-8984-4703-8448-fb97c8af7cb6.jpg";
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dict setObject:imageUrl forKey:@"image_url"];
    NSMutableArray *_allDiaryImages = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < 12; i++) {
        [_allDiaryImages addObject:dict];
    }
    
    
    
    //[_imagesView reloadAllImages:_allDiaryImages];
    //[_imagesView underView:_infoLabel padding:10];
    [_imagesView reloadWithData:_allDiaryImages];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

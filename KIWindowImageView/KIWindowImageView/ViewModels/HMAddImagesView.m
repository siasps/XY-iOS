//
//  HMAddImagesView.m
//  HuaxiajiaboApp
//
//  Created by HuamoMac on 15/10/12.
//  Copyright © 2015年 HuaMo. All rights reserved.
//

#import "HMAddImagesView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "QBImagePickerController.h"
#import "HMWindowDefaultImageView.h"


#define ImageView_tag  500


@interface HMAddImagesView () <QBImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate, UIGestureRecognizerDelegate, HMWindowDefaultImageViewDelegate>{
    
}
@property (nonatomic,strong) UIButton *addImageBtn;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) NSInteger imageIndex; //用于保存图片
@property (nonatomic,assign) NSInteger tempDeleteIndex;

@end



@implementation HMAddImagesView

- (id)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 80);
        self.backgroundColor = [UIColor whiteColor];
        _dataArray = [[NSMutableArray alloc]init];
        _maxImageNumber = 9; //默认
        
        [self initSubviews];
    }
    return self;
}

- (void)reloadWithImages:(NSArray *)images{
    for (NSDictionary *dict in images) {
        [_dataArray addObject:dict];
    }
    
    [self reloadImages];
}

- (void)reloadImages{
    
    NSInteger lineNum = ceil((_dataArray.count + 1)/4.0);
    [self setHeight:lineNum * 70 + 10];
    
    
    //删除视图
    for (UIImageView *imageView in self.subviews) {
        //UIImageView *view = (UIImageView *)[self viewWithTag:i + ImageView_tag ];
        if ([imageView isKindOfClass:[UIImageView class]]) {
            
            [imageView removeFromSuperview];
        }
    }
    
    //视图处理
    for (int i = 0; i< _dataArray.count; i++){
        NSDictionary *image = [_dataArray objectAtIndex:i];
        UIImageView *view = [self addViewWithImage:image frame:[self getImageFrameWithIndex:i]];
        [self addSubview:view];
        view.tag = ImageView_tag + i;
    }
    _addImageBtn.frame = [self getImageFrameWithIndex:_dataArray.count];
    _addImageBtn.hidden = (_dataArray.count >= _maxImageNumber);
}


+ (CGFloat)getViewheight:(NSArray *)array{
    NSInteger lineNum = ceil((array.count + 1)/4.0);
    
    return lineNum * 70 + 10;
}

//注意：在编辑的情况下，部分数据室url，部分是本地路径
- (NSArray *)getImagesArray{
    return _dataArray;
}

- (void)initSubviews{
    
    [self initAddImageBtn];
    
    
}


#pragma mark - 照片添加删除

- (void)initAddImageBtn{
    //width && height = 68
    _addImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _addImageBtn.frame = [self getImageFrameWithIndex:0];
    [_addImageBtn setBackgroundImage:[UIImage imageNamed:@"add_images.png"] forState:UIControlStateNormal];
    [self addSubview:_addImageBtn];
    [_addImageBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (CGRect)getImageFrameWithIndex:(NSInteger)index{
    //大小和间距
    CGFloat button_height          = 60;
    CGFloat button_width           = 60;
    CGFloat button_interval_width  = (SCREEN_WIDTH-50 - 4*button_width) / 5.0f;
    CGFloat button_interval_height = button_interval_width;
    
    long _column = index / 4;//行
    long _line   = index % 4;//列
    
    CGRect rect = CGRectMake(25 + (button_interval_width + button_width) * _line,
                             10 + (button_interval_height + button_height) * _column,
                             button_width, button_height);
    
    return rect;
}

- (UIImageView *)addViewWithImage:(id)imageStr frame:(CGRect)frame{
    
    
    UIImageView *imageview = [[UIImageView alloc]init];
    imageview.frame = frame;
    imageview.userInteractionEnabled = YES;
    imageview.clipsToBounds = NO;
    if ([imageStr isKindOfClass:[NSDictionary class]]) {
        NSString *small_image_url = [NSString stringWithFormat:@"%@?imageView2/2/w/200/h/200", [imageStr stringValueForKey:@"image_url"]];
        [imageview sd_setImageWithURL:[NSURL URLWithString:small_image_url] placeholderImage:[UIImage imageNamed:@"default640x640.png"]];
    }else {
        
        imageview.image = [UIImage imageWithContentsOfFile:imageStr];
    }
    
    //添加图片右上角删除按钮
    UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imageBtn.frame = imageview.bounds;
    [imageBtn addTarget:self action:@selector(showBigImageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [imageview addSubview:imageBtn];
    
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(deleteGesture:)];
    gesture.delegate = self;
    [imageview addGestureRecognizer:gesture];
    
    return imageview;
}


- (void)showBigImageBtnClick:(id)sender{
    UIButton *button = (UIButton *)sender;
    UIImageView *view = (UIImageView *)(button.superview);
    NSInteger _index = view.tag - ImageView_tag;
    
    CGRect rect = [button convertRect:button.bounds toView:nil];
    
    NSMutableArray *imagesStrArray = [[NSMutableArray alloc]init];
    for (id object in _dataArray) {
        if ([object isKindOfClass:[NSDictionary class]]){

            NSString *image_url = [object stringValueForKey:@"image_url"];
//            if ([KIFileCacheManager isExistCacheImageFile:image_url]) {
//                
//                NSString *savePathName = [NSString stringWithFormat:@"%@/%@",[KIFileCacheManager tempImageFilePath],[KIFileCacheManager cachedFileNameForUrl:image_url]];
//                [imagesStrArray addObject:savePathName];
//            }else{
//                [imagesStrArray addObject:image_url];
//            }
            
            [imagesStrArray addObject:image_url];
            
        }else{
            [imagesStrArray addObject:object];
        }
    }
    
    [HMWindowDefaultImageView showImageWithURLStringArray:imagesStrArray selectedIndex:_index originRect:rect delegate:self];
}

- (void)deleteGesture:(UILongPressGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        
        UIImageView *view = (UIImageView *)(gesture.view);
        NSInteger _index = view.tag - ImageView_tag;
        
        _tempDeleteIndex = _index;
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"删除图片?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];

    }
}

- (void)windowDefaultImageView:(HMWindowDefaultImageView *)windowDefaultImageView deleteIndex:(NSInteger)deleteIndex finished:(BOOL)finished{
    
    if (deleteIndex >= 0) {
        [_dataArray removeObjectAtIndex:deleteIndex];
    }
    
    if (finished) {
        [self reloadImages];
        
        if (_delegate && [_delegate respondsToSelector:@selector(addImagesView:actionType:object:)]) {
            [_delegate addImagesView:self actionType:2 object:nil];
        }
    }
}



#pragma mark - 图片处理

- (void)addBtnClick{
    
    if (_delegate && [_delegate respondsToSelector:@selector(addImagesView:actionType:object:)]) {
        [_delegate addImagesView:self actionType:3 object:nil];
    }
    
    if (_dataArray.count >= 9) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"最多可以上传9张图片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                               delegate:self
                                      cancelButtonTitle:@"取消"
                                 destructiveButtonTitle:nil
                                      otherButtonTitles:@"从相册选择", @"从相机拍摄", nil];
    
    [sheet showInView:[[[UIApplication sharedApplication]delegate]window]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self showImagesPicker];
    }else if (buttonIndex == 1){
        [self showCarema];
    }else{
        
    }
}


- (void)addImageWithImageName:(NSString *)imageName imagePath:(NSString *)imagePath{
    
    
    [_dataArray addObject:imagePath];
    
    UIImageView *view = [self addViewWithImage:imagePath frame:[self getImageFrameWithIndex:(_dataArray.count - 1)]];
    [self addSubview:view];
    view.tag = ImageView_tag + _dataArray.count - 1;
    
    //无效，需要调试
//    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(deleteImage:)];
//    gesture.minimumPressDuration = 0.5f;
//    [view addGestureRecognizer:gesture];
    
    _addImageBtn.frame = [self getImageFrameWithIndex:_dataArray.count];
    _addImageBtn.hidden = (_dataArray.count >= _maxImageNumber);
    
    
    if (_delegate && [_delegate respondsToSelector:@selector(addImagesView:actionType:object:)]) {
        [_delegate addImagesView:self actionType:1 object:nil];
    }
}

- (void)deleteImage:(UILongPressGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        UIImageView *imageView = (UIImageView *)gesture.view;
        NSInteger _index = imageView.tag - ImageView_tag;
        _tempDeleteIndex = _index;
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"删除图片?" delegate:self cancelButtonTitle:@"删除" otherButtonTitles:@"取消", nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if (buttonIndex == 1) {
        NSInteger _index = _tempDeleteIndex;
        
        //删除视图
        for (int i = 0; i< _dataArray.count; i++) {
            UIImageView *view = (UIImageView *)[self viewWithTag:i + ImageView_tag ];
            [view removeFromSuperview];
        }
        
        //数据处理
        [_dataArray removeObjectAtIndex:_index];
        
        //视图处理
        for (int i = 0; i< _dataArray.count; i++){
            
            UIImageView *view = [self addViewWithImage:[_dataArray objectAtIndex:i] frame:[self getImageFrameWithIndex:i]];
            [self addSubview:view];
            view.tag = ImageView_tag + i;
        }
        _addImageBtn.frame = [self getImageFrameWithIndex:_dataArray.count];
        _addImageBtn.hidden = (_dataArray.count >= _maxImageNumber);
        
        
        
        if (_delegate && [_delegate respondsToSelector:@selector(addImagesView:actionType:object:)]) {
            [_delegate addImagesView:self actionType:2 object:nil];
        }
    }
}

#pragma mark - camara

- (void)showCarema{
    if (TARGET_IPHONE_SIMULATOR) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"模拟器不能使用相机！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    //判断是否可以打开相机，模拟器此功能无法使用
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = NO;  //是否可编辑
        //摄像头
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        
        [self.viewController presentViewController:picker animated:YES completion:^{
            
        }];
        
    }else{
        //如果没有提示用户
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"你没有摄像头" delegate:nil cancelButtonTitle:@"Drat!" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //得到图片
    UIImage * tempImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    //图片存入相册
    UIImageWriteToSavedPhotosAlbum(tempImage, nil, nil, nil);
    
    
    
    NSString *path = [NSString stringWithFormat:@"%@/Documents/certified%ld.jpg", NSHomeDirectory(), (long)_imageIndex++];
    if (tempImage != nil) {
        UIImage *newImage = [UIImage scaleToSize:tempImage referWidth:600];
        [UIImageJPEGRepresentation(newImage, 0.5) writeToFile:path atomically:YES];
        
        [self addImageWithImageName:@"" imagePath:path];
    }
    
    
    [self dismissController];
}
//点击Cancel按钮后执行方法
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissController];
}

- (void)dismissController{
    
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - QBImagePickerController

- (void)showImagesPicker{
    
    QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.maximumNumberOfSelection = _maxImageNumber - _dataArray.count;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self.viewController presentViewController:navigationController animated:YES completion:NULL];
}


- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets{
    
    NSArray *assetArr = assets;
    
    UIWindow *window = [[[UIApplication sharedApplication]delegate]window];
    [MBProgressHUD showHUDDetailTextToView:window text:@"请稍后..." animated:YES];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        for (NSInteger i=0; i<assetArr.count; i++) {
            
            ALAsset *asset = [assetArr objectAtIndex:i];
            
            
            UIImage *tempImage = [HMAddImagesView fullResolutionImageFromALAsset:asset];
            //NSString *fileName = [[asset defaultRepresentation] filename];
            
            NSString *path = [NSString stringWithFormat:@"%@/Documents/certified%ld.jpg", NSHomeDirectory(), (long)_imageIndex++];
            if (tempImage != nil) {
                UIImage *newImage = [UIImage scaleToSize:tempImage referWidth:600];
                [UIImageJPEGRepresentation(newImage, 1) writeToFile:path atomically:YES];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self addImageWithImageName:@"" imagePath:path];
                    
                    if (i == assetArr.count-1) {
                        
                        [MBProgressHUD hideAllHUDsForView:window animated:YES];
                        [self dismissImagePickerController];
                    }
                });
                
            }
            
        }
    });
    
    
    
}

+ (UIImage *)fullResolutionImageFromALAsset:(ALAsset *)asset
{
    ALAssetRepresentation *assetRep = [asset defaultRepresentation];
    CGImageRef imgRef = [assetRep fullResolutionImage];
    UIImage *img = [UIImage imageWithCGImage:imgRef
                                       scale:assetRep.scale
                                 orientation:(UIImageOrientation)assetRep.orientation];
    return img;
}

- (void)imagesPickerControllerDidCancel:(QBImagePickerController *)imagePickerController{
    
    [self dismissImagePickerController];
}

- (void)dismissImagePickerController
{
    if (self.viewController.presentedViewController) {
        [self.viewController dismissViewControllerAnimated:YES completion:NULL];
    } else {
        [self.viewController.navigationController popToViewController:self.viewController animated:YES];
    }
}

@end

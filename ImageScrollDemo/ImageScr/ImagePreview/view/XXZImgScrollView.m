//
//  XXZImgScrollView.m
//  ImageBrowser Demo
//
//  Created by XXZ on 15/1/17.
//  Copyright (c) 2015年 XXZ CO.,LTD. All rights reserved.
//

//当前屏幕高度
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
//当前频幕的宽
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

#import "XXZImgScrollView.h"

@interface XXZImgScrollView ()<UIScrollViewDelegate>{
    UIImageView *imgView;
    
    CGRect scaleOriginRect;//记录自己的位置
    CGSize imgSize;//图片的大小
    CGRect initRect;//缩放前大小
    BOOL _isDoubleTap;//是否双击
}

@end

@implementation XXZImgScrollView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self settingScrollView];
        [self loadTap];
    }
    return self;
}

-(void)settingScrollView{
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.bouncesZoom = YES;
    self.backgroundColor = [UIColor clearColor];
    self.delegate = self;
    self.minimumZoomScale = 1.0;
    
    imgView = [[UIImageView alloc] init];
    imgView.clipsToBounds = YES;
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:imgView];
}

-(void)setContentWithFrame:(CGRect)rect{
    imgView.frame = rect;
    initRect = rect;
}

-(void)setAnimationRect{
    imgView.frame = scaleOriginRect;
}

-(void)rechangeInitRdct{
    self.zoomScale = 1.0;
    imgView.frame = initRect;
}

-(void)setImage:(UIImage *)image{
    if (image){
        imgView.image = image;
        imgSize = image.size;
        
        //判断首先缩放的值
//        float scaleX = self.frame.size.width/imgSize.width;
//        float scaleY = self.frame.size.height/imgSize.height;
        
        float scaleX = self.frame.size.width/imgSize.width;
        float scaleY = self.frame.size.height/imgSize.height;
        
        //倍数小的，先到边缘
        if (scaleX > scaleY){
            //Y方向先到边缘
            float imgViewWidth = imgSize.width*scaleY;
            self.maximumZoomScale = self.frame.size.width/imgViewWidth;
            
            scaleOriginRect = (CGRect){self.frame.size.width/2-imgViewWidth/2,0,imgViewWidth,self.frame.size.height};
        }else{
            //X先到边缘
            float imgViewHeight = imgSize.height*scaleX;
            self.maximumZoomScale = self.frame.size.height/imgViewHeight;
            
            scaleOriginRect = (CGRect){0,self.frame.size.height/2-imgViewHeight/2,self.frame.size.width,imgViewHeight};
        }
    }
}

#pragma mark -
#pragma mark - scroll delegate
// return a view that will be scaled. if delegate returns nil, nothing happens
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
//    return imgView;
    return nil;
}

// any zoom scale changes
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    CGSize boundsSize = scrollView.bounds.size;
    CGRect imgFrame = imgView.frame;
    CGSize contentSize = scrollView.contentSize;
    CGPoint centerPoint = CGPointMake(contentSize.width/2, contentSize.height/2);
    
    // center horizontally
    if (imgFrame.size.width <= boundsSize.width){
        centerPoint.x = boundsSize.width/2;
    }
    
    // center vertically
    if (imgFrame.size.height <= boundsSize.height){
        centerPoint.y = boundsSize.height/2;
    }
    imgView.center = centerPoint;
}

#pragma mark -
#pragma mark - add tap gesture recognizer
-(void)loadTap{
    // 监听点击
    //单次
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.delaysTouchesBegan = YES;
    singleTap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:singleTap];
    
    //双次
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTap];
}

#pragma mark - handle gesture recognizer
//单次手势处理
- (void)handleSingleTap:(UITapGestureRecognizer *)tap {
    _isDoubleTap = NO;
    //延迟是为了判断是否单击还是双击
    [self performSelector:@selector(hide) withObject:nil afterDelay:0.2f];
}

- (void)hide{
    if (_isDoubleTap) return;//当双击时退出;
    //轻拍一次,图片还原小图,动画延迟0.2f,还原动画时间0.3f
    [self.imgDelegate tapImageViewTappedWithObject:self];
}

//双次手势处理
- (void)handleDoubleTap:(UITapGestureRecognizer *)tap {
#if 0
    _isDoubleTap = YES;
    
    CGPoint touchPoint = [tap locationInView:self];
	if (self.zoomScale == self.maximumZoomScale) {
		[self setZoomScale:self.minimumZoomScale animated:YES];
	} else {
		[self zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 1, 1) animated:YES];
	}
#endif
}

@end

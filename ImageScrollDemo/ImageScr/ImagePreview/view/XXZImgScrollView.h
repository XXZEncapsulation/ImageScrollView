//
//  XXZImgScrollView.h
//  ImageBrowser Demo
//
//  Created by XXZ on 15/1/17.
//  Copyright (c) 2015年 XXZ CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XXZImgScrollViewDelegate <NSObject>

-(void)tapImageViewTappedWithObject:(id)sender;

@end

@interface XXZImgScrollView : UIScrollView

@property (nonatomic, assign) id<XXZImgScrollViewDelegate>imgDelegate;

-(void)setContentWithFrame:(CGRect)rect;
-(void)setImage:(UIImage *)image;//获取图片原始尺寸
-(void)setAnimationRect;
-(void)rechangeInitRdct;

@end

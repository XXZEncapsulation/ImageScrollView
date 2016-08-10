//
//  ImagePreviewController.h
//  ImageScrollDemo
//
//  Created by Jiayu_Zachary on 16/8/10.
//  Copyright © 2016年 Zachary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagePreviewController : UIViewController

/**
 *  是否是图片网址
 */
@property (nonatomic, assign) BOOL isUrl;

/**
 *  浏览图片的当前页
 */
@property (nonatomic, assign) NSInteger currentIndex;

/**
 *  需要展示的图片地址集合(线上)
 */
@property (nonatomic, strong) NSMutableArray *imageUrlArr;

/**
 *  需要展示的图片名称集合(本地)
 */
@property (nonatomic, strong) NSMutableArray *imageNameArr;

/**
 *  是否支持删除
 */
@property (nonatomic, assign) BOOL isDelete;

@end

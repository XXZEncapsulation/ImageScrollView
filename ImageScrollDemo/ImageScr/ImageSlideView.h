//
//  ImageSlideView.h
//  ImageScrollDemo
//
//  Created by Jiayu_Zachary on 16/8/10.
//  Copyright © 2016年 Zachary. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageSlideViewDelegate <NSObject>

- (void)clickImageWithCurrentIndex:(NSInteger)index;

@end

@interface ImageSlideView : UIView

@property (nonatomic, weak) id<ImageSlideViewDelegate>delegate;

/**
 *  当前的图片
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

@end

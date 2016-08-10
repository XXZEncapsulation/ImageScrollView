//
//  ImageSlideView.m
//  ImageScrollDemo
//
//  Created by Jiayu_Zachary on 16/8/10.
//  Copyright © 2016年 Zachary. All rights reserved.
//

#import "ImageSlideView.h"

@interface ImageSlideView () <UIScrollViewDelegate> {
    UIScrollView *_maskScrView;
    UIPageControl *_pageControl;
    UILabel *_pageCount; //显示具体的个数
    BOOL _isUrl; //图片是否是图片地址
}

@end

@implementation ImageSlideView {
    CGRect _originalRect;
    CGFloat _originalWidth;
    CGFloat _originalHeight;
    
    NSInteger _totalCount; //图片总数
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _isUrl = YES; //默认是图片地址
        _totalCount = 0;
        _originalRect = frame;
        _originalWidth = frame.size.width;
        _originalHeight = frame.size.height;
        self.backgroundColor = UICOLOR_LIGHT;
        
        [self buildLayout];
    }
    
    return self;
}

#pragma mark - UIScrollViewDelegate
//偏移量改变, 回调
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
#if 0
    NSInteger index = scrollView.contentOffset.x / _originalWidth;
    _pageControl.currentPage = index;
    _pageCount.text = [NSString stringWithFormat:@"%ld/%ld", (index+1), _totalCount];
#endif
}

//开始滚动后, 回调
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
//    XXZLog(@"scrollViewWillBeginDecelerating");
}

//结束滚动后, 回调
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
#if 1
    NSInteger index = scrollView.contentOffset.x/_originalWidth;
    _pageControl.currentPage = index;
    _pageCount.text = [NSString stringWithFormat:@"%ld/%ld", (index+1), _totalCount];
#endif
}

#pragma mark - action
- (void)singleClickAction:(UIGestureRecognizer *)gr {
    UIImageView *img = (UIImageView *)gr.view;
    NSInteger index = img.tag-1000;
    
    if ([_delegate respondsToSelector:@selector(clickImageWithCurrentIndex:)]) {
        [_delegate clickImageWithCurrentIndex:index];
    }
}

#pragma mark - build layout
- (void)buildLayout {
    [self loadMaskScrollView];
}

#pragma mark - loading
- (void)loadImageViewWithTotalNum:(NSInteger)total currentNum:(NSInteger)current{
    if (_maskScrView.subviews) {
        //若有, 移除所有的子视图
        [_maskScrView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    if (total > 0) {
        //偏移量范围
        _maskScrView.contentSize = CGSizeMake(_originalWidth*total, _originalHeight);
        _maskScrView.contentOffset = CGPointMake(_originalWidth*_currentIndex, 0); //当前偏移量
        
        //图片
        for (int i=0; i<total; i++) {
            UIImageView *img = [[UIImageView alloc] init];
            img.frame = CGRectMake(_originalWidth*i, 0, _originalWidth, _originalHeight);
            img.userInteractionEnabled = YES;
            img.tag = 1000+i;
            
            if (_isUrl) {
                //线上
#warning ...........
            }
            else {
                //本地
                img.image = [UIImage imageNamed:_imageNameArr[i]];
            }
            
            img.clipsToBounds = YES; //减掉溢出边
            img.contentMode = UIViewContentModeScaleAspectFill;
            
            [_maskScrView addSubview:img];
            
            //单击手势
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleClickAction:)];
            [img addGestureRecognizer:tap];
        }
        
        //点
        [self loadPageControlWithTotalNum:total currentNum:current];
        
        //具体个数
        [self loadPageCountViewWithTotalNum:total currentNum:(current+1)];
        
    }
    else {
        XXZLog(@"没有图片");
    }
}

//小点
- (void)loadPageControlWithTotalNum:(NSInteger)total currentNum:(NSInteger)current {
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.frame = CGRectMake(1, _originalHeight-(1+20)*RATIO_WIDTH, _originalWidth-1*2, 20*RATIO_WIDTH);
        _pageControl.userInteractionEnabled = NO;
        _pageControl.hidesForSinglePage = YES;
        
        _pageControl.pageIndicatorTintColor = UICOLOR_FROM(@"#CCCCCC"); //未选中的颜色
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor]; //当前选中的颜色
        
//        _pageControl.backgroundColor = CYAN_COLOR;
        [self addSubview:_pageControl];
    }
    
    _pageControl.numberOfPages = total;
    _pageControl.currentPage = current;
}

//具体个数
- (void)loadPageCountViewWithTotalNum:(NSInteger)total currentNum:(NSInteger)current {
    if (_pageCount == nil) {
        _pageCount = [[UILabel alloc] init];
        _pageCount.frame = CGRectMake(_originalWidth*3/4, _originalHeight-(15+15)*RATIO_WIDTH, _originalWidth/4-15*RATIO_WIDTH, 20*RATIO_WIDTH);
        _pageCount.font = FONT_l2;
        _pageCount.textColor = WHITE_COLOR;
        _pageCount.textAlignment = NSTextAlignmentRight;
//        _pageCount.backgroundColor = CYAN_COLOR;
        [self addSubview:_pageCount];
    }
    
    _pageCount.text = [NSString stringWithFormat:@"%ld/%ld", current, total];
}

- (void)loadMaskScrollView {
    _maskScrView = [[UIScrollView alloc] init];
    _maskScrView.frame = CGRectMake(0, 0, _originalRect.size.width, _originalRect.size.height);
    _maskScrView.showsHorizontalScrollIndicator = NO;
    _maskScrView.pagingEnabled = YES;
    _maskScrView.delegate = self;
    
    [self addSubview:_maskScrView];
}

#pragma mark - getter


#pragma mark - setter
- (void)setImageUrlArr:(NSMutableArray *)imageUrlArr {
    _imageUrlArr = imageUrlArr;
    _isUrl = YES;
    
    //添加图片
    _totalCount = imageUrlArr.count;
    [self loadImageViewWithTotalNum:_totalCount currentNum:_currentIndex];
}

- (void)setImageNameArr:(NSMutableArray *)imageNameArr {
    _isUrl = NO;
    _imageNameArr = imageNameArr;
    
    //添加图片
    _totalCount = imageNameArr.count;
    [self loadImageViewWithTotalNum:_totalCount currentNum:_currentIndex];
}

#pragma mark - dealloc
- (void)dealloc {
    
}

#pragma mark - other
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

//
//  ImagePreviewController.m
//  ImageScrollDemo
//
//  Created by Jiayu_Zachary on 16/8/10.
//  Copyright © 2016年 Zachary. All rights reserved.
//

#import "ImagePreviewController.h"
#import "XXZImgScrollView.h"

@interface ImagePreviewController ()<XXZImgScrollViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIView *scrollPanel;//载体
@property (nonatomic, strong) UIScrollView *myScrollView;
@property (nonatomic, strong) UIPageControl *pageControl;//当前页指示器

@end

@implementation ImagePreviewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self buildLayout];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"商家照片";
}

#pragma mark - XXZImgScrollViewDelegate
-(void)tapImageViewTappedWithObject:(id)sender{
    //隐藏
#if 0
    XXZImgScrollView *tmpImgView = sender;
    
    [UIView animateWithDuration:0.3 animations:^{
        _scrollPanel.alpha = 0;
        _pageControl.alpha = 0;
        
        [tmpImgView rechangeInitRdct];
    }];
#endif
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat pageWidth = scrollView.frame.size.width;
    //获取当前页
    _currentIndex = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageControl.currentPage = _currentIndex;
}

#pragma mark - action
- (void)rightItemAction {
    XXZLog(@"删除");
    
    if (_isUrl) {
        
    }
    else {
        if (_imageNameArr.count <= 1) {
            [MBProgressHUD showMsg:@"至少要有一张照片" toView:self.view];
            return;
        }
        
        [_imageNameArr removeObjectAtIndex:_currentIndex];
        
        if (_currentIndex+1 > _imageNameArr.count) {
            _currentIndex--;
        }
        
        [self addSubImgView:_imageNameArr isDelete:YES];
    }
}

- (void)leftItemAction {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"IMAGE_CURRENTINDEX" object:@(_currentIndex)];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - buildLayout
- (void)buildLayout {
    [self loadLeftItem];
    
    [self loadScrollPanel];
    [self loadMyScrollView];
    [self loadPageControl];
}

#pragma mark - loading
//载体
-(void)loadScrollPanel{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _scrollPanel = [[UIView alloc] initWithFrame:CGRectMake(0, XXZStatusAndNavHeight, SCREEN_WIDTH, SCREEN_HEIGHT-XXZStatusAndNavHeight)];
    _scrollPanel.backgroundColor = BLACK_COLOR;
    [self.view addSubview:self.scrollPanel];//载体视图
}

//滚动视图
-(void)loadMyScrollView{
    _myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_scrollPanel.frame), CGRectGetHeight(_scrollPanel.frame))];//滚动视图
    _myScrollView.backgroundColor = [UIColor clearColor];
    _myScrollView.pagingEnabled = YES;//整页滚动
    _myScrollView.delegate = self;//代理
    [_scrollPanel addSubview:self.myScrollView];
}

//页面指示器
-(void)loadPageControl{
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.frame = CGRectMake(1, CGRectGetHeight(_scrollPanel.frame)-40, CGRectGetWidth(_scrollPanel.frame)-2, 40);
//    _pageControl.backgroundColor = [UIColor cyanColor];
    _pageControl.userInteractionEnabled = NO;
    _pageControl.hidesForSinglePage = YES;
    
    _pageControl.pageIndicatorTintColor = UICOLOR_FROM(@"#333333"); //未选中的颜色
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor]; //当前选中的颜色
    
    [_scrollPanel addSubview:self.pageControl];
}

- (void)loadRightItem {
    UIButton *rightItem = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItem.frame = CGRectMake(0, 0, 40*RATIO_WIDTH, 30*RATIO_WIDTH);
    rightItem.titleLabel.font = FONT_l4;
//    rightItem.backgroundColor = CYAN_COLOR;
    rightItem.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -15);
    [rightItem setTitle:@"删除" forState:UIControlStateNormal];
    [rightItem setTitleColor:UICOLOR_DARK forState:UIControlStateNormal];
    [rightItem addTarget:self action:@selector(rightItemAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:rightItem];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)loadLeftItem {
    UIButton *leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
    leftItem.frame = CGRectMake(0, 0, 40*RATIO_WIDTH, 30*RATIO_WIDTH);
    leftItem.titleLabel.font = FONT_l4;
//    leftItem.backgroundColor = CYAN_COLOR;
    leftItem.contentEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    
    [leftItem setImage:[UIImage imageNamed:@"LeftArrow"] forState:UIControlStateNormal];
    [leftItem addTarget:self action:@selector(leftItemAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:leftItem];
    self.navigationItem.leftBarButtonItem = left;
}


#pragma mark - method
//show
-(void)loadBigImageWith:(NSMutableArray *)imgArr {
    //将载体带到view上面
    [self.view bringSubviewToFront:self.scrollPanel];
    
    //创建所有页
    [self addSubImgView:imgArr isDelete:NO];//添加放大版图片
    
    //布局当前页
    CGPoint contentOffset = _myScrollView.contentOffset;
    contentOffset.x = _currentIndex*self.view.bounds.size.width;
    _myScrollView.contentOffset = contentOffset;//获取相应的偏移量上的图片
    
    XXZImgScrollView *tmpImgScrollView = [[XXZImgScrollView alloc] initWithFrame:(CGRect){contentOffset,_myScrollView.bounds.size}];
    
#warning .....
    if (_isUrl) {
        //[tmpImgScrollView setImage:[UIImage imageNamed:imgArr[_currentIndex]]]; //放大版图片
    }
    else {
        [tmpImgScrollView setImage:[UIImage imageNamed:imgArr[_currentIndex]]]; //放大版图片
    }
    
    tmpImgScrollView.imgDelegate = self;
    [tmpImgScrollView setAnimationRect];
    
    [_myScrollView addSubview:tmpImgScrollView];
}

//添加放大图片
-(void)addSubImgView:(NSMutableArray *)imgArr isDelete:(BOOL)isDelete {
    for (UIView *tmpView in _myScrollView.subviews){
        [tmpView removeFromSuperview];
    }
    
    //滚动范围
    _myScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*imgArr.count, SCREEN_HEIGHT-XXZStatusAndNavHeight);
    _pageControl.numberOfPages = imgArr.count;
    _pageControl.currentPage = _currentIndex;//同步指示器显示位置
    
    for (int i=0; i<imgArr.count; i++){
        if (!isDelete) {
            if (i == _currentIndex){
                continue;
            }
        }
        
        XXZImgScrollView *tmpImgScrollView = [[XXZImgScrollView alloc] initWithFrame:(CGRect){i*_myScrollView.bounds.size.width,0,_myScrollView.bounds.size}];
        
#warning .....
        if (_isUrl) {
            //[tmpImgScrollView setImage:[UIImage imageNamed:_imageUrlArr[i]]]; //放大版图片
        }
        else {
            [tmpImgScrollView setImage:[UIImage imageNamed:_imageNameArr[i]]]; //放大版图片
        }
        
        tmpImgScrollView.imgDelegate = self;
        [tmpImgScrollView setAnimationRect];
        
        [_myScrollView addSubview:tmpImgScrollView];
    }
}

#pragma mark - getter


#pragma mark - setter
- (void)setImageUrlArr:(NSMutableArray *)imageUrlArr {
    _imageUrlArr = imageUrlArr;
    _isUrl = YES;
    
    //添加图片
}

- (void)setImageNameArr:(NSMutableArray *)imageNameArr {
    _isUrl = NO;
    _imageNameArr = imageNameArr;
    
    //添加图片
    [self loadBigImageWith:imageNameArr];
}

- (void)setIsDelete:(BOOL)isDelete {
    if (isDelete) {
        [self loadRightItem];
    }
}

#pragma mark - dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"IMAGE_CURRENTINDEX" object:nil];
}

#pragma mark - other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

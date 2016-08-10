//
//  ViewController.m
//  ImageScrollDemo
//
//  Created by Jiayu_Zachary on 16/8/10.
//  Copyright © 2016年 Zachary. All rights reserved.
//

#import "ViewController.h"

#import "ImageSlideView.h"
#import "ImagePreviewController.h"

@interface ViewController () <ImageSlideViewDelegate>

@end

@implementation ViewController {
    NSMutableArray *_imgArr;
    
    ImageSlideView *_imageSlideView;
    NSInteger _currentIndex;
}

#pragma mark - view will appear & disappear
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //coding...
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //coding...
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self buildLayout];
}

#pragma mark - ImageSlideViewDelegate
- (void)clickImageWithCurrentIndex:(NSInteger)index {
    XXZLog(@"index = %ld", index);
    
    ImagePreviewController *imagePreview = [[ImagePreviewController alloc] init];
    [self.navigationController pushViewController:imagePreview animated:YES];
    
    [imagePreview setIsDelete:YES];
    [imagePreview setIsUrl:NO];
    [imagePreview setCurrentIndex:index];
    [imagePreview setImageNameArr:_imgArr];
}

#pragma mark - action
- (void)currentIndexAction:(NSNotification *)noti {
    NSInteger currentIndex = [noti.object integerValue];
    
    if (_imageSlideView != nil) {
        [_imageSlideView setCurrentIndex:currentIndex];
        [_imageSlideView setImageNameArr:_imgArr];
    }
}

#pragma mark - build layout
- (void)buildLayout {
    //, @"02.jpg", @"03.jpg"
    _imgArr = [NSMutableArray arrayWithObjects:@"01.jpg", @"02.jpg", @"03.jpg", @"01.jpg", @"02.jpg", @"03.jpg", nil];
    
    [self loadImageSlideView];
    
    //预览返回后的下标
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentIndexAction:) name:@"IMAGE_CURRENTINDEX" object:nil];
}

#pragma mark - loading
- (void)loadImageSlideView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _imageSlideView = [[ImageSlideView alloc] initWithFrame:CGRectMake(10, 100, SCREEN_WIDTH-20, 400)];
    _imageSlideView.delegate = self;
    [self.view addSubview:_imageSlideView];
    
    [_imageSlideView setImageNameArr:_imgArr];
}

#pragma mark - getter


#pragma mark - setter


#pragma mark - dealloc
- (void)dealloc {
    
}

#pragma mark - other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

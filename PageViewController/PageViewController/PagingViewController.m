//
//  PagingViewController.m
//  PagingViewController
//
//  Created by LOVEME on 2016/11/6.
//  Copyright © 2016年 汪蕾. All rights reserved.
//

#import "PagingViewController.h"
#import "ContentViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface PagingViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    NSUInteger _currentIndex; //当前显示的索引
    BOOL _isFist;
    
    BOOL transitionFinish; //页面过度是否结束
}

@property (nonatomic,strong)UIPageViewController *pageViewController;

//空手势 在这里起手势锁的作用 在适当的时候禁用UIPageViewController中pan手势  实现既有侧滑返回又无弹簧效果
@property (nonatomic,strong)UIPanGestureRecognizer *fakePan;

@end

@implementation PagingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _isFist = YES;
    [self.view addSubview:self.pageViewController.view];
    [self addChildViewController:self.pageViewController];
    [self.pageViewController didMoveToParentViewController:self];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -- UIPageViewControllerDelegate UIPageViewControllerDataSource
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self.vcArray indexOfObject:viewController];
    if (index == 0 || index == NSNotFound) return nil;
    index --;
    if (self.vcArray.count > index) return self.vcArray[index];
    return nil;
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self.vcArray indexOfObject:viewController];
    if (index == self.vcArray.count || index == NSNotFound) return nil;
    index ++;
    if (self.vcArray.count > index) return self.vcArray[index];
    return nil;
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers
{
    transitionFinish = NO;
    UIViewController *vc = [pendingViewControllers firstObject];
    NSUInteger index = [_vcArray indexOfObject:vc];
    if (index != NSNotFound)
    {
        _currentIndex = index;
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    UIViewController *vc = [previousViewControllers lastObject];
    NSUInteger index = [_vcArray indexOfObject:vc];
    if (index != NSNotFound)
    {
        if (!(finished && completed)) //没有完成页面切换 还原_currentIndex
        {
            _currentIndex = index;
        }
    }
    self.fd_interactivePopDisabled = _currentIndex != 0; //不是第一个vc时禁止pop返回手势
    transitionFinish = YES;
    if (_scrollDidIndex) _scrollDidIndex(_currentIndex);
}

#pragma mark --UIScrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    scrollView.bounces = NO;
//    NSLog(@"x:%f,y:%f",scrollView.contentOffset.x,scrollView.contentOffset.y);
//}

#pragma mark -- UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    if (translation.x <= 0)
    {
        return (_currentIndex == _vcArray.count - 1 && transitionFinish);
    }else
    {
        return (_currentIndex ==0 && transitionFinish);
    }
}

//- (void)fakePanAction
//{
//    DLog(@"假手势在响应!!!");
//}

//非交互切换
- (void)showViewControlleriIndex:(NSUInteger)index animated:(BOOL)animated
{
    if (index == _currentIndex && !_isFist) return;
    if(index > _vcArray.count) return;
    _isFist = NO;
    UIPageViewControllerNavigationDirection direction = UIPageViewControllerNavigationDirectionReverse;
    if (index > _currentIndex)
    {
        direction = UIPageViewControllerNavigationDirectionForward;
    }
    _currentIndex = index;
    __weak typeof(self) ws = self;
    transitionFinish = NO;
    [_pageViewController setViewControllers:@[_vcArray[index]] direction:direction animated:animated completion:^(BOOL finished) {
        if (finished)
        {
            transitionFinish = YES;
            _currentIndex = index;
            ws.fd_interactivePopDisabled = _currentIndex != 0; //不是第一个vc时禁止pop返回手势
        }
    }];
}


#pragma mark -- GET  SET
- (UIPageViewController *)pageViewController
{
    if (!_pageViewController)
    {
        NSDictionary *options =[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationNone]
                                                           forKey: UIPageViewControllerOptionSpineLocationKey];
        _pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                             navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                           options:options];
        
        _pageViewController.doubleSided = NO;
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
        _pageViewController.view.frame = [self gainFrame];
        _pageViewController.view.backgroundColor = [UIColor whiteColor];
        __block UIScrollView *scrollView = nil;
        [_pageViewController.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIScrollView class]])
            {
                scrollView = (UIScrollView *)obj;
            }
        
        }];
        if(scrollView)
        {
//            if (!scrollView.delegate) scrollView.delegate = self;
            _fakePan = [UIPanGestureRecognizer new];
            _fakePan.delegate = self;
            [scrollView addGestureRecognizer:_fakePan];
            [scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.fd_fullscreenPopGestureRecognizer];
            [scrollView.panGestureRecognizer requireGestureRecognizerToFail:_fakePan];
            
            [_fakePan requireGestureRecognizerToFail:self.navigationController.fd_fullscreenPopGestureRecognizer];
        }
    }
    return _pageViewController;
}

- (void)setVcArray:(NSArray<UIViewController *> *)vcArray
{
    _vcArray = vcArray;
    if (_vcArray)
    {
        [_pageViewController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromParentViewController];
        }];
        [_vcArray enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_pageViewController addChildViewController:obj];
        }];
        [self showViewControlleriIndex:0 animated:NO];
    }
}

- (void)setPageViewBackgroundColor:(UIColor *)pageViewBackgroundColor
{
    _pageViewBackgroundColor = pageViewBackgroundColor;
    self.pageViewController.view.backgroundColor = pageViewBackgroundColor;
}

- (CGRect)gainFrame //子类可以重写
{
    return self.view.bounds;
}

@end

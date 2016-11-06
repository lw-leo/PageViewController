//
//  PagingViewController.h
//  PagingViewController
//
//  Created by LOVEME on 2016/11/6.
//  Copyright © 2016年 汪蕾. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PagingViewController : UIViewController
/**
 * 分页视图的frame 子类重写
 * 默认是self.view.bounds
 */
- (CGRect)gainFrame;

/**
 *  pageView背景色
 *  默认whiteColor
 */
@property (nonatomic,strong)UIColor *pageViewBackgroundColor;


/**
 * 所有要显示的vc
 */
@property (nonatomic,strong)NSArray<UIViewController *> *vcArray;

/**
 *  移动到数组中的那个vc
 *  非交互切换
 */
- (void)showViewControlleriIndex:(NSUInteger)index animated:(BOOL)animated;


/**
 *  交互切换完毕
 */
@property (nonatomic,copy)void(^scrollDidIndex)(NSUInteger index);

@end

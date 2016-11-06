//
//  PageViewController.m
//  PageViewController
//
//  Created by LOVEME on 2016/11/6.
//  Copyright © 2016年 汪蕾. All rights reserved.
//

#import "PageViewController.h"
#import "ContentViewController.h"

@interface PageViewController ()

@property (nonatomic,strong) UISegmentedControl *segmentedControl;

@end

@implementation PageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configUI];
}

- (void)configUI
{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"left_arrow"] style:UIBarButtonItemStyleDone target:self action:@selector(clickReturn)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    _segmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"One",@"Two",@"Three"]];
    _segmentedControl.selectedSegmentIndex = 0;
    [_segmentedControl addTarget:self action:@selector(changeSelect) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _segmentedControl;
    
    ContentViewController *content0 = [ContentViewController new];
    ContentViewController *content1 = [ContentViewController new];
    ContentViewController *content2 = [ContentViewController new];
    
    content0.view.backgroundColor = [UIColor redColor];
    content1.view.backgroundColor = [UIColor greenColor];
    content2.view.backgroundColor = [UIColor blueColor];
    
    self.vcArray = @[content0,content1,content2];
    
    __weak typeof(self) ws = self;
    self.scrollDidIndex = ^(NSUInteger index){
        ws.segmentedControl.selectedSegmentIndex = index; //滑动切换 完毕后改变选中指示
    };
}

#pragma mark --Even

- (void)clickReturn
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)changeSelect
{
    [self showViewControlleriIndex:_segmentedControl.selectedSegmentIndex animated:YES];
}
@end

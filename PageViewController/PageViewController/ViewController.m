//
//  ViewController.m
//  PageViewController
//
//  Created by LOVEME on 2016/11/6.
//  Copyright © 2016年 汪蕾. All rights reserved.
//

#import "ViewController.h"
#import "PageViewController.h"

@interface ViewController ()<UITableViewDataSource>

@end

@implementation ViewController

static NSString *identifier = @"cell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.textLabel.text = @"pageViewController";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PageViewController *vc = [PageViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

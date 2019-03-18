//
//  YZSortViewController.m
//  PullDownMenu
//
//  Created by yz on 16/8/12.
//  Copyright © 2016年 yz. All rights reserved.
//

#import "YZCityTableViewController.h"
#import "YZSortCell.h"
extern NSString * const YZUpdateMenuTitleNote;
static NSString * const ID = @"cell";

@interface YZCityTableViewController ()
@property (nonatomic, copy) NSArray *titleArray;
@property (nonatomic, assign) NSInteger selectedCol;
@end

@implementation YZCityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _selectedCol = 0;
    
    _titleArray = @[@"不限",@"北京",@"天津",@"上海",@"重庆",@"河北",@"河南",@"湖北",@"湖南",@"江苏",@"江西",@"辽宁",@"吉林",@"黑龙江",@"陕西",@"山西",@"山东",@"四川",@"青海",@"安徽",@"海南",@"广东",@"贵州",@"浙江",@"福建",@"甘肃",@"云南",@"西藏",@"宁夏",@"广西",@"新疆",@"内蒙古",@"台湾",@"香港",@"澳门"];
    
    [self.tableView registerClass:[YZSortCell class] forCellReuseIdentifier:ID];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_selectedCol inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZSortCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.textLabel.text = _titleArray[indexPath.row];
    if (indexPath.row == 0) {
        [cell setSelected:YES animated:NO];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedCol = indexPath.row;
    
    // 选中当前
    YZSortCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    // 更新菜单标题
    [[NSNotificationCenter defaultCenter] postNotificationName:YZUpdateMenuTitleNote object:self userInfo:@{@"title":cell.textLabel.text}];
    
    
}

@end


//
//  NeedCategoryController.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/6/6.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "NeedCategoryController.h"
#import "ImageLabelLabelArrowCell.h"
#import "NeedStatusController.h"

#define cellIdentifier @"imageLabelLabelArrowCell"
#define RowHeight 48

@interface NeedCategoryController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *titleArr;
@property (nonatomic, strong)NSArray *imageNameArr;

@end

@implementation NeedCategoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"需求";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setArr];
    [self setupView];
    // Do any additional setup after loading the view.
}

- (void)setupView{
    _tableView = ({
        UITableView *tableView = [UITableView new];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = RowHeight;
        tableView.scrollEnabled = NO;
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [tableView registerNib:[UINib nibWithNibName:@"ImageLabelLabelArrowCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellIdentifier];
        tableView.tableFooterView = [UIView new];
        tableView;
    });
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(NAV_HEIGHT);
        make.height.mas_equalTo(_titleArr.count * RowHeight);
    }];
}


- (void)setArr{
    _titleArr = @[@"人员需求", @"承接需求", @"外包需求"];
    _imageNameArr = @[@"internal_task_icon", @"undertake_task_icon", @"outsource_task_icon"];
}


#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ImageLabelLabelArrowCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setOnlyTitle:_titleArr[indexPath.row]];
    [cell setOnlyImage:_imageNameArr[indexPath.row]];
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NeedStatusController *vc = [NeedStatusController new];
    vc.teamModel = _model;
    vc.type = indexPath.row;
    vc.isOwner = _isOwner;
    vc.enterWay = _enterWay;
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

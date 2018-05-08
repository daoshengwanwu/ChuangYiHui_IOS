//
//  TaskCategoryController.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/6/3.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "TaskCategoryController.h"
#import "ImageLabelLabelArrowCell.h"
#import "TaskStatusController.h"

#define cellIdentifier @"imageLabelLabelArrowCell"
#define RowHeight 48

@interface TaskCategoryController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *titleArr;
@property (nonatomic, strong)NSArray *imageNameArr;

@end

@implementation TaskCategoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"任务";
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
    _titleArr = @[@"内部任务", @"承接任务", @"外包任务"];
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
    TaskStatusController *vc = [TaskStatusController new];
    vc.type = indexPath.row;
    //从团队进入
    vc.enterWay = 0;
    vc.teamModel = _teamModel;
    [self.navigationController pushViewController:vc animated:YES];
}



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

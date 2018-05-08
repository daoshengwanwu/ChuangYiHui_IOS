//
//  TeamMemberController.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/6/4.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "TeamMemberController.h"
#import "UserListCell.h"
#import "UserDetailController.h"

#define cellIdentifier @"userListCell"

@interface TeamMemberController ()<UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *memberArr;
@property (nonatomic, assign) NSInteger limit;

@end

@implementation TeamMemberController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"团队成员";
    self.view.backgroundColor = [UIColor whiteColor];
    _limit = 10;
    _memberArr = [NSMutableArray array];
    [self setUpView];
    [self getMembers];
    // Do any additional setup after loading the view.
}

- (void)setUpView{
    _tableView = ({
        UITableView *tableView = [UITableView new];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.emptyDataSetSource = self;
        tableView.emptyDataSetDelegate = self;
        tableView.rowHeight = 102.0f;
        [tableView registerNib:[UINib nibWithNibName:@"UserListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellIdentifier];
        tableView.tableFooterView = [UIView new];
        tableView;
    });
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)getMembers{
    NSString *url = [NSString stringWithFormat:@"%@?limit=%ld",URL_GET_TEAM_MEMBERS(_model.team_id), _limit];
    [SVProgressHUD showWithStatus:@"加载中"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [[NetRequest sharedInstance] httpRequestWithGET:url success:^(id data, NSString *message) {
        
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
        
        _memberArr = [UserModel mj_objectArrayWithKeyValuesArray:data[@"list"]];
        [_tableView reloadData];
        
    } failed:^(id data, NSString *message) {
        NSLog(@"%@",message);
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
        [[SVHudManager sharedInstance] showErrorHudWithTitle:message andTime:1.0f];
        
    }];
}

- (void)deleteMember: (NSInteger)index{
    UserModel *memberModel = [_memberArr objectAtIndex:index];
    [[NetRequest sharedInstance] httpRequestWithDELETE:URL_CHECK_IS_MEMBER(_model.team_id, memberModel.user_id) success:^(id data, NSString *message) {
        [[SVHudManager sharedInstance] showSuccessHudWithTitle:@"删除成员成功" andTime:1.0f];
        //从视图上移除
        [_memberArr removeObjectAtIndex:index];
        [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        
    } failed:^(id data, NSString *message) {
        [[SVHudManager sharedInstance] showErrorHudWithTitle:message andTime:1.0f];
    }];
}


- (void)alert:(NSInteger)index{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除成员吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"点击取消");
        
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deleteMember:index];
    }]];
    
//    [alertController addAction:[UIAlertAction actionWithTitle:@"警告" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//        
//        NSLog(@"点击警告");
//        
//    }]];
    
    
//    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//        
//        NSLog(@"添加一个textField就会调用 这个block");
//        
//    }];
    
    // 由于它是一个控制器 直接modal出来就好了
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    if (section == 0) {
//        return 1;
//    }
    return _memberArr.count;
}


//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 2;
//}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setUserCellByUserModel:[_memberArr objectAtIndex:indexPath.row]];
    return cell;
}


#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UserDetailController *vc =[UserDetailController new];
    vc.hidesBottomBarWhenPushed = YES;
    vc.model = [_memberArr objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isOwner) {
        return YES;
    }
    return NO;
}
//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
//进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self alert:indexPath.row];
    }
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

#pragma mark DZNEmptyDelegate
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"no_record_icon"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"还没有成员~";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
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

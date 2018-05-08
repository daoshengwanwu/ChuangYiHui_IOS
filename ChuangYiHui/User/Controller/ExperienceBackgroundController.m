//
//  ExperienceBackgroundController.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/15.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "ExperienceBackgroundController.h"
#import "ExperienceCell.h"
#import "ExperienceDetailController.h"

#define cellIdentifier @"experienceCell"

@interface ExperienceBackgroundController ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *objectArr;
@property (nonatomic, assign) NSInteger limit;

@end

@implementation ExperienceBackgroundController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _limit = 10;
    _objectArr = @[];
    _tableView = ({
        UITableView *tableView = [UITableView new];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.emptyDataSetSource = self;
        tableView.emptyDataSetDelegate = self;
        tableView.rowHeight = 84.0f;
        tableView.tableFooterView = [UIView new];
        [tableView registerNib:[UINib nibWithNibName:@"ExperienceCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellIdentifier];
        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _limit = 10;
            [self getObjects];
        }];
        tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            _limit += 10;
            [self getObjects];
        }];
        tableView;
    });
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    

    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [self getObjects];
}


- (NSString *)getBaseUrl{
    NSString *baseUrl = @"";
    switch (_type) {
        case 0:
            baseUrl = URL_GET_EDUCATIONS_EXPERIENCE;
            break;
            
        case 1:
            baseUrl = URL_GET_FIELDWORK_EXPERIENCE;
            break;
            
        case 2:
            baseUrl = URL_GET_WORK_EXPERIENCE;
            break;
            
        case 3:
            baseUrl = URL_GET_OTHER_EDUCATIONS_EXPERIENCE(_user_id);
            break;
            
        case 4:
            baseUrl = URL_GET_OTHER_FIELDWORKS_EXPERIENCE(_user_id);
            break;
            
        case 5:
            baseUrl = URL_GET_OTHER_WORKS_EXPERIENCE(_user_id);
            break;
            
        default:
            break;
    }
    return baseUrl;
}



- (void)getObjects{
    NSString *url = [NSString stringWithFormat:@"%@?limit=%ld",[self getBaseUrl], _limit];
    [SVProgressHUD showWithStatus:@"加载中"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [[NetRequest sharedInstance] httpRequestWithGET:url success:^(id data, NSString *message) {
        
        NSLog(@"data：%@", data);
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
        
        _objectArr = [ExperienceModel mj_objectArrayWithKeyValuesArray:data[@"list"]];
        [_tableView reloadData];
        
    } failed:^(id data, NSString *message) {
        NSLog(@"%@",message);
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
    }];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _objectArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ExperienceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ExperienceModel *model = [_objectArr objectAtIndex:indexPath.row];
    [cell setCellByExperienceCell:model];
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ExperienceDetailController *vc = [ExperienceDetailController new];
    vc.editType = 1;
    vc.type = _type;
    vc.model = [_objectArr objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark DZNEmptyDelegate
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"no_record_icon"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"没有记录~";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}


@end

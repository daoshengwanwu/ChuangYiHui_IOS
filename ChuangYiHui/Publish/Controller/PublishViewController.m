#import "PublishViewController.h"
#import "PublishPeopleRequireCell.h"

#define PeopleRequireCellIdentifier @"publishPeopleRequireCell"


@interface PublishViewController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView * peopleRequireTableView;
@property (nonatomic, strong) NSArray * peopleRequires;
@property (nonatomic, assign) NSInteger peopleListLimit;

@end


@implementation PublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initView {
    //初始化人员需求headerView
    UIView * headerView = [UIView new];
    [self.view addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker * make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(45);
        make.top.mas_equalTo(0);
    }];
    
    UIImageView * arrowImageView = [UIImageView new];
    [headerView addSubview:arrowImageView];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(10);
        make.centerY.equalTo(headerView.mas_centerY).with.offset(-2);
    }];
    arrowImageView.image = [UIImage imageNamed:@"arrow"];
    
    UIImageView * imageView = [UIImageView new];
    [headerView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker * make) {
        make.centerY.equalTo(headerView.mas_centerY).with.offset(-2);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(24);
    }];
    imageView.image = [UIImage imageNamed:@"member_icon"];
    
    UILabel * headerTextLabel = [UILabel new];
    [headerView addSubview:headerTextLabel];
    [headerTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(24);
        make.left.equalTo(imageView.mas_right).with.offset(10);
        make.right.mas_equalTo(arrowImageView.mas_left);;
        make.centerY.equalTo(headerView.mas_centerY).with.offset(-2);
    }];
    headerTextLabel.text = @"人员需求";
    headerTextLabel.textColor = [UIColor darkGrayColor];
    
    UIView * bottomLineView = [UIView new];
    [headerView addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(3);
        make.bottom.equalTo(headerView.mas_bottom);
    }];
    bottomLineView.backgroundColor = LINE_COLOR;
    
    //初始化人员需求TableView
    _peopleListLimit = 10;
    _peopleRequires = @[];
    _peopleRequireTableView = ({
        UITableView * tableView = [UITableView new];
        
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.emptyDataSetSource = self;
        tableView.emptyDataSetDelegate = self;
        tableView.rowHeight = 88.0f;
        
        [tableView registerNib:[UINib nibWithNibName:@"PublishPeopleRequireCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:PeopleRequireCellIdentifier];
        
        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _peopleListLimit = 10;
            //在此获取数据并刷新
            [self getPeopleRequires];
        }];
        tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            _peopleListLimit += 10;
            //在此刷新数据
            [self getPeopleRequires];
        }];
        
        tableView;
    });
    
    [self.view addSubview:_peopleRequireTableView];
    [_peopleRequireTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.equalTo(headerView.mas_bottom);
        make.bottom.mas_equalTo(0).with.offset(-TAB_HEIGHT - 90);
    }];

    //初始化承接需求headerView及TableView
    //初始化人员需求headerView
    UIView * underTakeHeaderView = [UIView new];
    [self.view addSubview:underTakeHeaderView];
    [underTakeHeaderView mas_makeConstraints:^(MASConstraintMaker * make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(45);
        make.top.equalTo(_peopleRequireTableView.mas_bottom);
    }];
    
    arrowImageView = [UIImageView new];
    [underTakeHeaderView addSubview:arrowImageView];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(10);
        make.centerY.equalTo(underTakeHeaderView.mas_centerY).with.offset(-2);
    }];
    arrowImageView.image = [UIImage imageNamed:@"arrow"];
    
    imageView = [UIImageView new];
    [underTakeHeaderView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker * make) {
        make.centerY.equalTo(underTakeHeaderView.mas_centerY).with.offset(-2);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(24);
    }];
    imageView.image = [UIImage imageNamed:@"undertake_icon"];
    
    headerTextLabel = [UILabel new];
    [underTakeHeaderView addSubview:headerTextLabel];
    [headerTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(24);
        make.left.equalTo(imageView.mas_right).with.offset(10);
        make.right.mas_equalTo(arrowImageView.mas_left);;
        make.centerY.equalTo(underTakeHeaderView.mas_centerY).with.offset(-2);
    }];
    headerTextLabel.text = @"承接需求";
    headerTextLabel.textColor = [UIColor darkGrayColor];
    
    bottomLineView = [UIView new];
    [underTakeHeaderView addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(3);
        make.bottom.equalTo(underTakeHeaderView.mas_bottom);
    }];
    bottomLineView.backgroundColor = LINE_COLOR;
    //初始化外包需求headerView及TableView
    //初始化人员需求headerView
    UIView * outSourceHeaderView = [UIView new];
    [self.view addSubview:outSourceHeaderView];
    [outSourceHeaderView mas_makeConstraints:^(MASConstraintMaker * make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(45);
        make.top.equalTo(underTakeHeaderView.mas_bottom);
    }];
    
    arrowImageView = [UIImageView new];
    [outSourceHeaderView addSubview:arrowImageView];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(10);
        make.centerY.equalTo(outSourceHeaderView.mas_centerY).with.offset(-2);
    }];
    arrowImageView.image = [UIImage imageNamed:@"arrow"];
    
    imageView = [UIImageView new];
    [outSourceHeaderView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker * make) {
        make.centerY.equalTo(outSourceHeaderView.mas_centerY).with.offset(-2);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(24);
    }];
    imageView.image = [UIImage imageNamed:@"outsource_icon"];
    
    headerTextLabel = [UILabel new];
    [outSourceHeaderView addSubview:headerTextLabel];
    [headerTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(24);
        make.left.equalTo(imageView.mas_right).with.offset(10);
        make.right.mas_equalTo(arrowImageView.mas_left);;
        make.centerY.equalTo(outSourceHeaderView.mas_centerY).with.offset(-2);
    }];
    headerTextLabel.text = @"外包需求";
    headerTextLabel.textColor = [UIColor darkGrayColor];
    
    bottomLineView = [UIView new];
    [outSourceHeaderView addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(3);
        make.bottom.equalTo(underTakeHeaderView.mas_bottom);
    }];
    bottomLineView.backgroundColor = LINE_COLOR;
    
    [self getPeopleRequires];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _peopleRequires.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PublishPeopleRequireCell * cell = [tableView dequeueReusableCellWithIdentifier:PeopleRequireCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell bindData:[_peopleRequires objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"GoToActivityDetail" object: nil];
    //do nothing
}

- (UIImage *)imageForEmptyDataSet: (UIScrollView *)scrollView {
    return [UIImage imageNamed:@"no_record_icon"];
}

- (NSAttributedString *)titleForEmptyDataSet: (UIScrollView *)scrollView {
    NSString *text = @"没有需求~";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (void)getPeopleRequires {
    NSString * url = [NSString stringWithFormat:@"%@?limit=%ld", URL_GET_ALL_MEMBER_NEEDS, _peopleListLimit];
    [SVProgressHUD showWithStatus:@"加载中"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [[NetRequest sharedInstance] httpRequestWithGET:url success:^(id data, NSString *message) {
        [_peopleRequireTableView.mj_header endRefreshing];
        [_peopleRequireTableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
        _peopleRequires = [PublishRequireModel mj_objectArrayWithKeyValuesArray:data[@"list"]];
        [_peopleRequireTableView reloadData];
        
    } failed:^(id data, NSString *message) {
        NSLog(@"%@",message);
        [SVProgressHUD dismiss];
        [[SVHudManager sharedInstance] showErrorHudWithTitle:message andTime:1.0f];
        [_peopleRequireTableView.mj_header endRefreshing];
        [_peopleRequireTableView.mj_footer endRefreshing];
        
    }];
}

@end

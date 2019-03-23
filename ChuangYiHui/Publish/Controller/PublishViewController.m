#import "PublishViewController.h"
#import "PublishPeopleRequireCell.h"
#import "UnderTakeListAdapter.h"
#import "OutSourceAdapter.h"
#import "PeopleRequireDetailController.h"
#import "ZjcgTableViewCell.h"
#import "SyscgTableViewCell.h"
#import "ZjcgAdapter.h"
#import "SyscgAdapter.h"

#define PeopleRequireCellIdentifier @"publishPeopleRequireCell"


@interface PublishViewController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView * peopleRequireTableView;
@property (nonatomic, strong) NSArray * peopleRequires;
@property (nonatomic, assign) NSInteger peopleListLimit;
@property (nonatomic, strong) UIView * peopleHeaderView;

@property (nonatomic, strong) UITableView * underTakeRequireTableView;
@property (nonatomic, strong) NSArray * underTakeRequires;
@property (nonatomic, assign) NSInteger underTakeListLimit;
@property (nonatomic, strong) UIView * underTakeHeaderView;

@property (nonatomic, strong) UITableView * outSourceRequireTableView;
@property (nonatomic, strong) NSArray * outSourceRequires;
@property (nonatomic, assign) NSInteger outSourceListLimit;
@property (nonatomic, strong) UIView * outSourceHeaderView;

@property (nonatomic, assign) NSInteger isPeopleHide;
@property (nonatomic, assign) NSInteger isUnderTakeHide;
@property (nonatomic, assign) NSInteger isOutSourceHide;
@property (nonatomic, assign) NSInteger iszjcgHide;
@property (nonatomic, assign) NSInteger issyscgHide;

@property (nonatomic, strong) UITableView * zjcgTableView;
@property (nonatomic, strong) NSArray * zjcgRequires;
@property (nonatomic, assign) NSInteger zjcgListLimit;
@property (nonatomic, strong) UIView * zjcgHeaderView;

@property (nonatomic, strong) UITableView * syscgTableView;
@property (nonatomic, strong) NSArray * syscgRequires;
@property (nonatomic, assign) NSInteger syscgListLimit;
@property (nonatomic, strong) UIView * syscgHeaderView;

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
        make.height.mas_equalTo(40);
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
    _peopleHeaderView = headerView;
    
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
        make.bottom.mas_equalTo(-TAB_HEIGHT - 160);
    }];

    //初始化承接需求headerView及TableView
    //初始化人员需求headerView
    UIView * underTakeHeaderView = [UIView new];
    [self.view addSubview:underTakeHeaderView];
    [underTakeHeaderView mas_makeConstraints:^(MASConstraintMaker * make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
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
    headerTextLabel.text = @"附能需求";
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
    _underTakeHeaderView = underTakeHeaderView;
    
    //初始化TableView
    _underTakeListLimit = 10;
    _underTakeRequires = @[];
    UnderTakeListAdapter * adapter = [UnderTakeListAdapter new];
    _underTakeRequireTableView = [UITableView new];
    _underTakeRequireTableView.delegate = adapter;
    _underTakeRequireTableView.dataSource = adapter;
    _underTakeRequireTableView.emptyDataSetSource = adapter;
    _underTakeRequireTableView.emptyDataSetDelegate = adapter;
    _underTakeRequireTableView.rowHeight = 88.0f;
    [_underTakeRequireTableView registerNib:[UINib nibWithNibName:@"UnderTakeRequireCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:UnderTakeRequireCellIdentifier];
    _underTakeRequireTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [adapter setLimit:10];
        //在此获取数据并刷新
        [adapter getDataFromServer];
    }];
    _underTakeRequireTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [adapter setLimit:[adapter getLimit] + 10];
        //在此刷新数据
        [adapter getDataFromServer];
    }];
    [adapter setTableView:_underTakeRequireTableView];
    [adapter setUnderTakeRequireList:_underTakeRequires];
    [adapter setLimit:10];
    [adapter setViewController:self];
    
    
    [self.view addSubview:_underTakeRequireTableView];
    [_underTakeRequireTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.equalTo(underTakeHeaderView.mas_bottom);
        make.height.mas_equalTo(0);
    }];
    
    //初始化外包需求headerView及TableView
    //初始化人员需求headerView
    UIView * outSourceHeaderView = [UIView new];
    [self.view addSubview:outSourceHeaderView];
    [outSourceHeaderView mas_makeConstraints:^(MASConstraintMaker * make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
        make.top.equalTo(_underTakeRequireTableView.mas_bottom);
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
    headerTextLabel.text = @"项目需求";
    headerTextLabel.textColor = [UIColor darkGrayColor];
    
    bottomLineView = [UIView new];
    [outSourceHeaderView addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(3);
        make.bottom.equalTo(outSourceHeaderView.mas_bottom);
    }];
    bottomLineView.backgroundColor = LINE_COLOR;
    _outSourceHeaderView = outSourceHeaderView;
    //设置OutSourceTableView
    _outSourceListLimit = 10;
    _outSourceRequires = @[];
    OutSourceAdapter * outSourceAdapter = [OutSourceAdapter new];
    _outSourceRequireTableView = [UITableView new];
    _outSourceRequireTableView.delegate = outSourceAdapter;
    _outSourceRequireTableView.dataSource = outSourceAdapter;
    _outSourceRequireTableView.emptyDataSetSource = outSourceAdapter;
    _outSourceRequireTableView.emptyDataSetDelegate = outSourceAdapter;
    _outSourceRequireTableView.rowHeight = 88.0f;
    [_outSourceRequireTableView registerNib:[UINib nibWithNibName:@"OutSourceRequireCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:OutSourceRequireCellIdentifier];
    _outSourceRequireTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [outSourceAdapter setLimit:10];
        //在此获取数据并刷新
        [outSourceAdapter getDataFromServer];
    }];
    _outSourceRequireTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [outSourceAdapter setLimit:[adapter getLimit] + 10];
        //在此刷新数据
        [outSourceAdapter getDataFromServer];
    }];
    [outSourceAdapter setTableView:_outSourceRequireTableView];
    [outSourceAdapter setUnderTakeRequireList:_outSourceRequires];
    [outSourceAdapter setLimit:10];
    [outSourceAdapter setViewController:self];
    
    [self.view addSubview:_outSourceRequireTableView];
    [_outSourceRequireTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.equalTo(outSourceHeaderView.mas_bottom);
        make.height.mas_equalTo(0);
    }];
    
    //初始化专家成果headerView
    UIView * zjcgView = [UIView new];
    [self.view addSubview:zjcgView];
    [zjcgView mas_makeConstraints:^(MASConstraintMaker * make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(_outSourceRequireTableView.mas_bottom);
    }];
    
    arrowImageView = [UIImageView new];
    [zjcgView addSubview:arrowImageView];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(10);
        make.centerY.equalTo(zjcgView.mas_centerY).with.offset(-2);
    }];
    arrowImageView.image = [UIImage imageNamed:@"arrow"];
    
    imageView = [UIImageView new];
    [zjcgView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker * make) {
        make.centerY.equalTo(zjcgView.mas_centerY).with.offset(-2);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(24);
    }];
    imageView.image = [UIImage imageNamed:@"zjcg_icon"];
    
    headerTextLabel = [UILabel new];
    [zjcgView addSubview:headerTextLabel];
    [headerTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(24);
        make.left.equalTo(imageView.mas_right).with.offset(10);
        make.right.mas_equalTo(arrowImageView.mas_left);;
        make.centerY.equalTo(zjcgView.mas_centerY).with.offset(-2);
    }];
    headerTextLabel.text = @"专家成果";
    headerTextLabel.textColor = [UIColor darkGrayColor];
    
    bottomLineView = [UIView new];
    [zjcgView addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(3);
        make.bottom.equalTo(zjcgView.mas_bottom);
    }];
    bottomLineView.backgroundColor = LINE_COLOR;
    
    
    _zjcgHeaderView = zjcgView;

    //初始化TableView
    _zjcgListLimit = 10;
    _zjcgRequires = @[];
    ZjcgAdapter * zjcgadapter = [ZjcgAdapter new];
    _zjcgTableView = [UITableView new];
    _zjcgTableView.delegate = zjcgadapter;
    _zjcgTableView.dataSource = zjcgadapter;
    _zjcgTableView.emptyDataSetSource = zjcgadapter;
    _zjcgTableView.emptyDataSetDelegate = zjcgadapter;
    _zjcgTableView.rowHeight = 88.0f;
    [_zjcgTableView registerNib:[UINib nibWithNibName:@"ZjcgTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:ZjcgCellIdentifier];
    _zjcgTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [zjcgadapter setLimit:10];
        //在此获取数据并刷新
        [zjcgadapter getDataFromServer];
    }];
    _zjcgTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [zjcgadapter setLimit:[adapter getLimit] + 10];
        //在此刷新数据
        [zjcgadapter getDataFromServer];
    }];
    [zjcgadapter setTableView:_zjcgTableView];
    [zjcgadapter setZjcgList:_zjcgRequires];
    [zjcgadapter setLimit:10];
    [zjcgadapter setViewController:self];
    
    
    [self.view addSubview:_zjcgTableView];
    [_zjcgTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.equalTo(zjcgView.mas_bottom);
        make.height.mas_equalTo(0);
    }];
    
    //初始化实验室成果headerView及TableView
    UIView * syscgHeaderView = [UIView new];
    [self.view addSubview:syscgHeaderView];
    [syscgHeaderView mas_makeConstraints:^(MASConstraintMaker * make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
        make.top.equalTo(_zjcgTableView.mas_bottom);
    }];
    
    arrowImageView = [UIImageView new];
    [syscgHeaderView addSubview:arrowImageView];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(10);
        make.centerY.equalTo(syscgHeaderView.mas_centerY).with.offset(-2);
    }];
    arrowImageView.image = [UIImage imageNamed:@"arrow"];
    
    imageView = [UIImageView new];
    [syscgHeaderView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker * make) {
        make.centerY.equalTo(syscgHeaderView.mas_centerY).with.offset(-2);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(24);
    }];
    imageView.image = [UIImage imageNamed:@"syscg_icon"];
    
    headerTextLabel = [UILabel new];
    [syscgHeaderView addSubview:headerTextLabel];
    [headerTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(24);
        make.left.equalTo(imageView.mas_right).with.offset(10);
        make.right.mas_equalTo(arrowImageView.mas_left);;
        make.centerY.equalTo(syscgHeaderView.mas_centerY).with.offset(-2);
    }];
    headerTextLabel.text = @"实验室成果";
    headerTextLabel.textColor = [UIColor darkGrayColor];
    
    bottomLineView = [UIView new];
    [syscgHeaderView addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(3);
        make.bottom.equalTo(syscgHeaderView.mas_bottom);
    }];
    bottomLineView.backgroundColor = LINE_COLOR;
    _syscgHeaderView = syscgHeaderView;
    
    //初始化TableView
    _syscgListLimit = 10;
    _syscgRequires = @[];
    SyscgAdapter * syscgadapter = [SyscgAdapter new];
    _syscgTableView = [UITableView new];
    _syscgTableView.delegate = syscgadapter;
    _syscgTableView.dataSource = syscgadapter;
    _syscgTableView.emptyDataSetSource = syscgadapter;
    _syscgTableView.emptyDataSetDelegate = syscgadapter;
    _syscgTableView.rowHeight = 88.0f;
    [_syscgTableView registerNib:[UINib nibWithNibName:@"SyscgTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:SyscgCellIdentifier];
    _syscgTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [syscgadapter setLimit:10];
        //在此获取数据并刷新
        [syscgadapter getDataFromServer];
    }];
    _syscgTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [syscgadapter setLimit:[adapter getLimit] + 10];
        //在此刷新数据
        [syscgadapter getDataFromServer];
    }];
    [syscgadapter setTableView:_syscgTableView];
    [syscgadapter setSyscgList:_syscgRequires];
    [syscgadapter setLimit:10];
    [syscgadapter setViewController:self];
    
    
    [self.view addSubview:_syscgTableView];
    [_syscgTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.equalTo(syscgHeaderView.mas_bottom);
        make.height.mas_equalTo(0);
    }];
    
    [self getPeopleRequires];
    [adapter getDataFromServer];
    [outSourceAdapter getDataFromServer];
    [zjcgadapter getDataFromServer];
    [syscgadapter getDataFromServer];
    
    
    UITapGestureRecognizer * peopleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(peopleTaped:)];
    [headerView addGestureRecognizer:peopleTap];
    
    UITapGestureRecognizer * underTakeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(underTakeTaped:)];
    [underTakeHeaderView addGestureRecognizer:underTakeTap];
    
    UITapGestureRecognizer * outSourceTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(outSourceTaped:)];
    [outSourceHeaderView addGestureRecognizer:outSourceTap];
    
    UITapGestureRecognizer * zjcgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zjcgTaped:)];
    [zjcgView addGestureRecognizer:zjcgTap];
    
    UITapGestureRecognizer * syscgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(syscgTaped:)];
    [syscgHeaderView addGestureRecognizer:syscgTap];
    
    _isPeopleHide = 0;
    _isUnderTakeHide = 1;
    _isOutSourceHide = 1;
    _iszjcgHide = 1;
    _issyscgHide = 1;
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
    [self presentViewController:[[PeopleRequireDetailController alloc] initWithPublishRequireModel:[_peopleRequires objectAtIndex:indexPath.row] Type:0] animated:true completion:^{
        //跳转完成后需要执行的事件；
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //在设置高度的回调中获取当前indexpath的cell 然后返回给他的frame的高度即可。在创建cell的时候记得最后把cell.frame.size.height 等于你内容的高。
    
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    /*此写法会导致循环引用。引起崩溃
     UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
     */
    
    return cell.frame.size.height;
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
    [[NetRequest sharedInstance] httpRequestWithGETandSort:url success:^(id data, NSString *message) {
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

- (void)peopleTaped:(UITapGestureRecognizer *)gr {
    if (!_isPeopleHide) {
        [self hidePeopleTableView];
        _isPeopleHide = 1;
    } else {
        [self hideUnderTakeTableView];
        [self hideOutSourceTableView];
        [self hidezjcgTableView];
        [self hidesyscgTableView];
        [self showPeopleTableView];
        _isPeopleHide = 0;
    }
}

- (void)underTakeTaped:(UITapGestureRecognizer *)gr {
    if (!_isUnderTakeHide) {
        [self hideUnderTakeTableView];
        _isUnderTakeHide = 1;
    } else {
        [self hidePeopleTableView];
        [self hideOutSourceTableView];
        [self hidezjcgTableView];
        [self hidesyscgTableView];
        [self showUnderTakeTableView];
        _isUnderTakeHide = 0;
    }
}

- (void)outSourceTaped:(UITapGestureRecognizer *)gr {
    if (!_isOutSourceHide) {
        [self hideOutSourceTableView];
        _isOutSourceHide = 1;
    } else {
        [self hideUnderTakeTableView];
        [self hidePeopleTableView];
        [self hidezjcgTableView];
        [self hidesyscgTableView];
        [self showOutSourceTableView];
        _isOutSourceHide = 0;
    }
}

- (void)zjcgTaped:(UITapGestureRecognizer *)gr {
    if (!_iszjcgHide) {
        [self hidezjcgTableView];
        _iszjcgHide = 1;
    } else {
        [self hidePeopleTableView];
        [self hideOutSourceTableView];
        [self hideUnderTakeTableView];
        [self hidesyscgTableView];
        [self showzjcgTableView];
        _iszjcgHide = 0;
    }
}

- (void)syscgTaped:(UITapGestureRecognizer *)gr {
    if (!_issyscgHide) {
        [self hidesyscgTableView];
        _issyscgHide = 1;
    } else {
        [self hideUnderTakeTableView];
        [self hidePeopleTableView];
        [self hidezjcgTableView];
        [self hideOutSourceTableView];
        [self showsyscgTableView];
        _issyscgHide = 0;
    }
}

- (void)hidePeopleTableView {
    [_peopleRequireTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.equalTo(_peopleHeaderView.mas_bottom);
        make.height.mas_equalTo(0);
    }];
}

- (void)showPeopleTableView {
    [_peopleRequireTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.equalTo(_peopleHeaderView.mas_bottom);
        make.bottom.mas_equalTo(0).with.offset(-TAB_HEIGHT - 160);
    }];
}

- (void)hideUnderTakeTableView {
    [_underTakeRequireTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.equalTo(_underTakeHeaderView.mas_bottom);
        make.height.mas_equalTo(0);
    }];
}

- (void)showUnderTakeTableView {
    [_underTakeRequireTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.equalTo(_underTakeHeaderView.mas_bottom);
        make.bottom.mas_equalTo(0).with.offset(-TAB_HEIGHT - 120);
    }];
}

- (void)hideOutSourceTableView {
    [_outSourceRequireTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.equalTo(_outSourceHeaderView.mas_bottom);
        make.height.mas_equalTo(0);
    }];
}

- (void)showOutSourceTableView {
    [_outSourceRequireTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.equalTo(_outSourceHeaderView.mas_bottom);
        make.bottom.mas_equalTo(0).with.offset(-TAB_HEIGHT-80);
    }];
}
- (void)hidezjcgTableView {
    [_zjcgTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.equalTo(_zjcgHeaderView.mas_bottom);
        make.height.mas_equalTo(0);
    }];
}

- (void)showzjcgTableView {
    [_zjcgTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.equalTo(_zjcgHeaderView.mas_bottom);
        make.bottom.mas_equalTo(0).with.offset(-TAB_HEIGHT-40);
    }];
}
- (void)hidesyscgTableView {
    [_syscgTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.equalTo(_syscgHeaderView.mas_bottom);
        make.height.mas_equalTo(0);
    }];
}

- (void)showsyscgTableView {
    [_syscgTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.equalTo(_syscgHeaderView.mas_bottom);
        make.bottom.mas_equalTo(0).with.offset(-TAB_HEIGHT);
    }];
}
@end

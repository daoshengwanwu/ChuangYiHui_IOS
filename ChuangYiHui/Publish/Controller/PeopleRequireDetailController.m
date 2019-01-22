//
//  PeopleRequireDetailController.m
//  ChuangYiHui
//
//  Created by BaiHaoran on 2018/5/17.
//  Copyright © 2018年 litingdong. All rights reserved.
//

#import "PeopleRequireDetailController.h"

@interface PeopleRequireDetailController ()

@property(nonatomic, strong) PublishRequireModel * model;

@property(nonatomic, assign) NSInteger type;

@property(nonatomic, strong) UILabel * teamName;
@property(nonatomic, strong) UILabel * needTitle;
@property(nonatomic, strong) UILabel * field;
@property(nonatomic, strong) UILabel * skill;
@property(nonatomic, strong) UILabel * degree;
@property(nonatomic, strong) UILabel * age;
@property(nonatomic, strong) UILabel * deadline;
@property(nonatomic, strong) UILabel * area;
@property(nonatomic, strong) UILabel * gender;
@property(nonatomic, strong) UILabel * number;
@property(nonatomic, strong) UILabel * startTime;
@property(nonatomic, strong) UILabel * endTime;

@end

@implementation PeopleRequireDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //状态栏size
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
                         
    [self.view setBackgroundColor:COLOR(255, 255, 255)];
    
    UIColor * blueTextColor = COLOR(50, 177, 230);
    UIColor * lineColor = COLOR(196, 196, 196);
    UIColor * grayTextColor = COLOR(119, 119, 119);
    UIColor * lightGray = COLOR(250, 250, 250);
    
    //标题栏容器
    UIView * header = [UIView new];
    [self.view addSubview:header];
    [header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(rectStatus.size.height);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    //标题栏左侧回退按钮
    UIImageView * imageView = [UIImageView new];
    [header addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0).with.offset(16);
        make.centerY.equalTo(header.mas_centerY);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(10);
    }];
    [imageView setImage:[UIImage imageNamed:@"back"]];
    [imageView setUserInteractionEnabled:YES];
    UITapGestureRecognizer * backTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTapped:)];
    [imageView addGestureRecognizer:backTap];
    
    //标题栏标题
    UILabel * label = [UILabel new];
    [header addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(header.mas_centerY);
        make.centerX.equalTo(header.mas_centerX);
    }];
    label.font = [UIFont systemFontOfSize:21];
    if (_type == 0) {
    label.text = @"人员需求详情";
    } else if (_type == 1) {
        label.text = @"承接需求详情";
    } else if (_type == 2) {
        label.text = @"课题需求详情";
    }
    label.textColor = blueTextColor;
    
    //标题栏举报
    label = [UILabel new];
    [header addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(header.mas_centerY);
        make.right.mas_equalTo(0).with.offset(-16);
    }];
    label.text = @"举报";
    label.textColor = blueTextColor;
    
    //需求发布方Label
    label  = [UILabel new];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(10);
        make.top.mas_equalTo(header.mas_bottom).with.offset(10);
    }];
    label.text = @"需求发布方";
    label.textColor = grayTextColor;
    label.font = [UIFont systemFontOfSize:14];
    
    //灰色横线
    UIView * line = [UIView new];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(2);
        make.top.equalTo(label.mas_bottom).offset(8);
    }];
    line.backgroundColor = lineColor;
    
    //头像
    imageView = [UIImageView new];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0).offset(15);
        make.top.equalTo(line.mas_bottom).offset(8);
        make.height.mas_equalTo(46);
        make.width.mas_equalTo(46);
    }];
    imageView.image = [UIImage imageNamed:@"default_team_head"];
    
    //团队名称
    label = [UILabel new];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(10);
        make.centerY.equalTo(imageView.mas_centerY);
    }];
    label.text = _model.team_name;
    _teamName = label;
    
    //粗线
    line = [UIView new];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(12);
        make.top.equalTo(imageView.mas_bottom).offset(5);
    }];
    line.backgroundColor = lightGray;
    
    //需求详情
    label = [UILabel new];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(10);
        make.top.equalTo(line.mas_bottom).offset(5);
    }];
    label.text = @"需求详情";
    label.textColor = grayTextColor;
    label.font = [UIFont systemFontOfSize:14];
    
    //下边的线
    line = [UIView new];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(2);
        make.top.mas_equalTo(label.mas_bottom).offset(5);
    }];
    line.backgroundColor = lineColor;
    
    //需求详情container
    UIView * container = [UIView new];
    [self.view addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(10);
        make.top.equalTo(line.mas_bottom).offset(10);
    }];
    
    //标题
    label = [UILabel new];
    [container addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
    }];
    label.text = _model.title;
    _needTitle = label;
    
    //领域，描述， 描述
    UILabel * label2 = [UILabel new];
    [container addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(20);
        make.left.mas_equalTo(0);
    }];
    if (_type == 0) {
    label2.text = @"领域：";
    } else if (_type == 1) {
        label2.text = @"描述：";
    } else if (_type == 2) {
        label2.text = @"描述：";
    }
    label2.textColor = grayTextColor;
    label2.font = [UIFont systemFontOfSize:14];
    
    label = [UILabel new];
    [container addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label2.mas_right).offset(35);
        make.centerY.equalTo(label2.mas_centerY);
    }];
    label.text = _model.field;
    label.textColor = blueTextColor;
    _field = label;
    
    //技能，擅长领域，领域
    label2 = [UILabel new];
    [container addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(10);
        make.left.mas_equalTo(0);
    }];
    if (_type == 0) {
        label2.text = @"技能：";
    } else if (_type == 1) {
        label2.text = @"擅长领域：";
    } else if (_type == 2) {
        label2.text = @"领域：";
    }
    label2.textColor = grayTextColor;
    label2.font = [UIFont systemFontOfSize:14];
    
    label = [UILabel new];
    [container addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label2.mas_right).offset(35);
        make.centerY.equalTo(label2.mas_centerY);
    }];
    label.text = _model.skill;
    label.textColor = blueTextColor;
    _skill = label;
    
    //学历，擅长技能，技能
    label2 = [UILabel new];
    [container addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(10);
        make.left.mas_equalTo(0);
    }];
    if (_type == 0) {
        label2.text = @"学历：";
    } else if (_type == 1) {
        label2.text = @"擅长技能：";
    } else if (_type == 2) {
        label2.text = @"技能：";
    }
    label2.textColor = grayTextColor;
    label2.font = [UIFont systemFontOfSize:14];
    
    label = [UILabel new];
    [container addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label2.mas_right).offset(35);
        make.centerY.equalTo(label2.mas_centerY);
    }];
    label.text = _model.degree;
    label.textColor = blueTextColor;
    _degree = label;
    
    //性别，服务地区，学历
    label2 = [UILabel new];
    [container addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(10);
        make.left.mas_equalTo(0);
    }];
    if (_type == 0) {
        label2.text = @"性别：";
    } else if (_type == 1) {
        label2.text = @"服务地区：";
    } else if (_type == 2) {
        label2.text = @"学历：";
    }
    label2.textColor = grayTextColor;
    label2.font = [UIFont systemFontOfSize:14];
    
    label = [UILabel new];
    [container addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label2.mas_right).offset(35);
        make.centerY.equalTo(label2.mas_centerY);
    }];
    label.text = _model.gender;
    label.textColor = blueTextColor;
    _gender = label;
    
    //地区，酬劳，人数
    label2 = [UILabel new];
    [container addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(10);
        make.left.mas_equalTo(0);
    }];
    if (_type == 0) {
        label2.text = @"地区：";
    } else if (_type == 1) {
        label2.text = @"酬劳：";
    } else if (_type == 2) {
        label2.text = @"人数：";
    }
    label2.textColor = grayTextColor;
    label2.font = [UIFont systemFontOfSize:14];
    
    label = [UILabel new];
    [container addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label2.mas_right).offset(35);
        make.centerY.equalTo(label2.mas_centerY);
    }];
    label.text = _model.province;
    label.textColor = blueTextColor;
    _area = label;
    
    //年龄，截止日期，地区
    label2 = [UILabel new];
    [container addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(10);
        make.left.mas_equalTo(0);
    }];
    if (_type == 0) {
        label2.text = @"年龄：";
    } else if (_type == 1) {
        label2.text = @"截止日期：";
    } else if (_type == 2) {
        label2.text = @"地区：";
    }
    label2.textColor = grayTextColor;
    label2.font = [UIFont systemFontOfSize:14];
    
    label = [UILabel new];
    [container addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label2.mas_right).offset(35);
        make.centerY.equalTo(label2.mas_centerY);
    }];
    label.text = @"不限";
    label.textColor = blueTextColor;
    _age = label;
    
    //名额，开始时间，费用
    label2 = [UILabel new];
    [container addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(10);
        make.left.mas_equalTo(0);
    }];
    if (_type == 0) {
        label2.text = @"名额：";
    } else if (_type == 1) {
        label2.text = @"开始时间：";
    } else if (_type == 2) {
        label2.text = @"费用：";
    }
    label2.textColor = grayTextColor;
    label2.font = [UIFont systemFontOfSize:14];
    
    label = [UILabel new];
    [container addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label2.mas_right).offset(35);
        make.centerY.equalTo(label2.mas_centerY);
    }];
    label.text = @"人力资源";
    label.textColor = blueTextColor;
    _number = label;
    
    //截止日期，结束时间，截止日期
    label2 = [UILabel new];
    [container addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(10);
        make.left.mas_equalTo(0);
    }];
    if (_type == 0) {
        label2.text = @"截止日期：";
    } else if (_type == 1) {
        label2.text = @"结束时间：";
    } else if (_type == 2) {
        label2.text = @"截止日期：";
    }
    label2.textColor = grayTextColor;
    label2.font = [UIFont systemFontOfSize:14];
    
    label = [UILabel new];
    [container addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label2.mas_right).offset(5);
        make.centerY.equalTo(label2.mas_centerY);
    }];
    label.text = _model.deadline;
    label.textColor = blueTextColor;
    _deadline = label;
    
    if (_type == 2) {
        //开始时间
        label2 = [UILabel new];
        [container addSubview:label2];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.mas_bottom).offset(10);
            make.left.mas_equalTo(0);
        }];
        label2.text = @"开始时间：";
        label2.textColor = grayTextColor;
        label2.font = [UIFont systemFontOfSize:14];
        
        label = [UILabel new];
        [container addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label2.mas_right).offset(5);
            make.centerY.equalTo(label2.mas_centerY);
        }];
        label.text = _model.deadline;
        label.textColor = blueTextColor;
        _startTime = label;
        
        //结束时间
        label2 = [UILabel new];
        [container addSubview:label2];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.mas_bottom).offset(10);
            make.left.mas_equalTo(0);
        }];
        label2.text = @"结束时间：";
        label2.textColor = grayTextColor;
        label2.font = [UIFont systemFontOfSize:14];
        
        label = [UILabel new];
        [container addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label2.mas_right).offset(5);
            make.centerY.equalTo(label2.mas_centerY);
        }];
        label.text = _model.deadline;
        label.textColor = blueTextColor;
        _endTime = label;
    }
    
    //底部灰色
    line = [UIView new];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label2.mas_bottom);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    line.backgroundColor = lightGray;
    
    //底部按钮
    UIButton * btn = [UIButton new];
    [line addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(20);
        make.height.mas_equalTo(38);
    }];
    [btn setTitle:@"申请加入" forState:UIControlStateNormal];
    btn.backgroundColor = blueTextColor;
    
    [btn addTarget:self action:@selector(onJoinClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self getNeedDetail];
}

- (void)backTapped:(UITapGestureRecognizer *)gr {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onJoinClick {
    NSString * url = nil;
    if (_type == 0) {
        url = [NSString stringWithFormat:@"%@teams/%@/needs/member_requests/", BASE_URL, _model.id];
    } else if (_type == 1 || _type == 2) {
        url = [NSString stringWithFormat:@"%@teams/%@/needs/requests/%@/", BASE_URL, _model.team_id, _model.id];
    }
    
    [[NetRequest sharedInstance] httpRequestWithPost:url parameters:nil withToken:YES success:^(id data, NSString *message) {
        UIAlertController * dialog = [UIAlertController alertControllerWithTitle:message message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [dialog addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil]];
        [self presentViewController:dialog animated:YES completion:nil];
    } failed:^(id data, NSString *message) {
        UIAlertController * dialog = [UIAlertController alertControllerWithTitle:message message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [dialog addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil]];
        [self presentViewController:dialog animated:YES completion:nil];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (PeopleRequireDetailController*)initWithPublishRequireModel:(PublishRequireModel *)model Type:(NSInteger)type {
    _model = model;
    _type = type;
    
    return self;
}

- (void)getNeedDetail {
    NSString * needId = _model.id;
    NSString * url = [NSString stringWithFormat:@"%@teams/needs/%@/", BASE_URL, needId];
    [[NetRequest sharedInstance] httpRequestWithGET:url success:^(id data, NSString *message) {
        _model = [PublishRequireModel mj_objectWithKeyValues:data];
        [self updateView];
    } failed:^(id data, NSString *message) {
        NSLog(@"%@", message);
    }];
}

- (void)updateView {
    if (_type == 0) { //人员需求详情
        _needTitle.text = _model.title;
        _field.text = _model.field;
        _skill.text = _model.skill;
        if ([_model.gender isEqualToString:@"0"]) {
            _gender.text = @"不限";
        } else if ([_model.gender isEqualToString:@"1"]) {
            _gender.text = @"男";
        } else {
            _gender.text = @"女";
        }
        _area.text = _model.province;
        _number.text = _model.number;
        _deadline.text = _model.deadline;
    } else if (_type == 1) { //承接需求
        _field.text = _model.Description;
        _skill.text = _model.field;
        _degree.text = _model.skill;
        _gender.text = _model.province;
        _area.text = _model.cost;
        _age.text = _model.deadline;
        _number.text = _model.time_started;
        _deadline.text = _model.time_ended;
    } else if (_type == 2) { //外包需求
        _field.text = _model.Description;
        _skill.text = _model.field;
        _degree.text = _model.skill;
        _gender.text = _model.degree;
        _area.text = _model.number;
        _age.text = _model.province;
        _number.text = _model.cost;
        _deadline.text = _model.deadline;
        _startTime.text = _model.time_started;
        _endTime.text = _model.time_ended;
    }
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

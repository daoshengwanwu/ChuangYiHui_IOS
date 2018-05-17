//
//  PeopleRequireDetailController.m
//  ChuangYiHui
//
//  Created by BaiHaoran on 2018/5/17.
//  Copyright © 2018年 litingdong. All rights reserved.
//

#import "PeopleRequireDetailController.h"

@interface PeopleRequireDetailController ()

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
    
    //标题栏标题
    UILabel * label = [UILabel new];
    [header addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(header.mas_centerY);
        make.centerX.equalTo(header.mas_centerX);
    }];
    label.font = [UIFont systemFontOfSize:21];
    label.text = @"人员需求详情";
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
    label.text = @"团队名称";
    
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
    label.text = @"标题";
    
    //领域
    UILabel * label2 = [UILabel new];
    [container addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(20);
        make.left.mas_equalTo(0);
    }];
    label2.text = @"领域：";
    label2.textColor = grayTextColor;
    label2.font = [UIFont systemFontOfSize:14];
    
    label = [UILabel new];
    [container addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label2.mas_right).offset(35);
        make.centerY.equalTo(label2.mas_centerY);
    }];
    label.text = @"文化传媒";
    label.textColor = blueTextColor;
    
    //技能
    label2 = [UILabel new];
    [container addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(10);
        make.left.mas_equalTo(0);
    }];
    label2.text = @"技能：";
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
    
    //学历
    label2 = [UILabel new];
    [container addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(10);
        make.left.mas_equalTo(0);
    }];
    label2.text = @"学历：";
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
    
    //性别
    label2 = [UILabel new];
    [container addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(10);
        make.left.mas_equalTo(0);
    }];
    label2.text = @"性别：";
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
    
    //地区
    label2 = [UILabel new];
    [container addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(10);
        make.left.mas_equalTo(0);
    }];
    label2.text = @"地区：";
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
    
    //年龄
    label2 = [UILabel new];
    [container addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(10);
        make.left.mas_equalTo(0);
    }];
    label2.text = @"年龄：";
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
    
    //名额
    label2 = [UILabel new];
    [container addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(10);
        make.left.mas_equalTo(0);
    }];
    label2.text = @"名额：";
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
    
    //截止日期
    label2 = [UILabel new];
    [container addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(10);
        make.left.mas_equalTo(0);
    }];
    label2.text = @"截止日期：";
    label2.textColor = grayTextColor;
    label2.font = [UIFont systemFontOfSize:14];
    
    label = [UILabel new];
    [container addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label2.mas_right).offset(5);
        make.centerY.equalTo(label2.mas_centerY);
    }];
    label.text = @"人力资源";
    label.textColor = blueTextColor;
    
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

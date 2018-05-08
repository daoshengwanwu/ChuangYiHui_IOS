//
//  MemberNeedDetailController.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/7/21.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "MemberNeedDetailController.h"

@interface MemberNeedDetailController ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *team_name;
@property (weak, nonatomic) IBOutlet UILabel *need_title;
@property (weak, nonatomic) IBOutlet UILabel *field;
@property (weak, nonatomic) IBOutlet UILabel *skill;
@property (weak, nonatomic) IBOutlet UILabel *degree;
@property (weak, nonatomic) IBOutlet UILabel *gender;
@property (weak, nonatomic) IBOutlet UILabel *area;
@property (weak, nonatomic) IBOutlet UILabel *age;
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UILabel *deadline;
@property (weak, nonatomic) IBOutlet UITextView *need_description;



@end

@implementation MemberNeedDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getTeamNeedDetail];
    // Do any additional setup after loading the view.
}


- (void)initViewByModel:(NeedModel *)needModel{
    NSArray *sexArr = @[@"不限", @"男", @"女"];
    [_icon sd_setImageWithURL:[NSURL URLWithString:URLFrame(needModel.icon_url)] placeholderImage:[UIImage imageNamed:@"default_team_head"]];
    _need_title.text = needModel.title;
    _team_name.text = needModel.team_name;
    _field.text = needModel.field;
    _skill.text = needModel.skill;
    _degree.text = needModel.degree;
    _gender.text = [sexArr objectAtIndex:[needModel.gender integerValue]];
    _area.text = needModel.province;
    _age.text = [NSString stringWithFormat:@"%@-%@", needModel.age_min, needModel.age_max];
    _number.text = needModel.number;
    _deadline.text = needModel.deadline;
    _need_description.text = needModel.need_description;
}

- (void)getTeamNeedDetail{
    [[NetRequest sharedInstance] httpRequestWithGET:URL_GET_TEAM_NEED_DETAIL(_needModel.need_id) success:^(id data, NSString *message) {
        NeedModel *needModel = [NeedModel mj_objectWithKeyValues:data];
        [self initViewByModel:needModel];
    } failed:^(id data, NSString *message) {
        
    }];
}

//申请加入的监听
- (IBAction)applyAction:(id)sender {
    [[NetRequest sharedInstance] httpRequestWithPost:URL_GET_TEAM_MEMBER_NEED_REQUESTS(_needModel.need_id) parameters:@{} withToken:NO success:^(id data, NSString *message) {
        [[SVHudManager sharedInstance] showSuccessHudWithTitle:@"申请成功" andTime:1.0f DoneBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } failed:^(id data, NSString *message) {
        [[SVHudManager sharedInstance] showSuccessHudWithTitle:@"申请失败" andTime:1.5f];
    }];
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

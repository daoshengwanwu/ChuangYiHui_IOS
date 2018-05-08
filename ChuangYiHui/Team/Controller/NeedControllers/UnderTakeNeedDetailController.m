//
//  UnderTakeNeedDetailController.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/7/21.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "UnderTakeNeedDetailController.h"

@interface UnderTakeNeedDetailController ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *team_name;
@property (weak, nonatomic) IBOutlet UILabel *need_title;
@property (weak, nonatomic) IBOutlet UILabel *field;
@property (weak, nonatomic) IBOutlet UILabel *skill;
@property (weak, nonatomic) IBOutlet UILabel *area;
@property (weak, nonatomic) IBOutlet UILabel *deadline;
@property (weak, nonatomic) IBOutlet UITextView *need_description;
@property (weak, nonatomic) IBOutlet UILabel *start_time;
@property (weak, nonatomic) IBOutlet UILabel *end_time;
@property (weak, nonatomic) IBOutlet UILabel *fee;
@end

@implementation UnderTakeNeedDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getTeamNeedDetail];
    // Do any additional setup after loading the view.
}

- (void)initViewByModel:(NeedModel *)needModel{
    [_icon sd_setImageWithURL:[NSURL URLWithString:URLFrame(needModel.icon_url)] placeholderImage:[UIImage imageNamed:@"default_team_head"]];
    _need_title.text = needModel.title;
    _team_name.text = needModel.team_name;
    _field.text = needModel.field;
    _skill.text = needModel.skill;
    _area.text = needModel.province;
    _deadline.text = needModel.deadline;
    _need_description.text = needModel.need_description;
    _start_time.text = needModel.time_started;
    _end_time.text = needModel.time_ended;
}

- (void)getTeamNeedDetail{
    [[NetRequest sharedInstance] httpRequestWithGET:URL_GET_TEAM_NEED_DETAIL(_needModel.need_id) success:^(id data, NSString *message) {
        NeedModel *needModel = [NeedModel mj_objectWithKeyValues:data];
        [self initViewByModel:needModel];
    } failed:^(id data, NSString *message) {
        
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

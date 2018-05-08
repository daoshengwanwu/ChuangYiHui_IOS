//
//  OutSourceNeedDetailController.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/7/21.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "OutSourceNeedDetailController.h"
#import "ActionSheetStringPicker.h"

@interface OutSourceNeedDetailController ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *team_name;
@property (weak, nonatomic) IBOutlet UILabel *need_title;
@property (weak, nonatomic) IBOutlet UILabel *field;
@property (weak, nonatomic) IBOutlet UILabel *skill;
@property (weak, nonatomic) IBOutlet UILabel *degree;
@property (weak, nonatomic) IBOutlet UILabel *area;
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UITextView *need_description;
@property (weak, nonatomic) IBOutlet UILabel *fee;
@property (weak, nonatomic) IBOutlet UILabel *start_time;
@property (weak, nonatomic) IBOutlet UILabel *end_time;


@property (nonatomic, strong)NSArray *teamArr;
@property (nonatomic, strong)NSMutableArray *teamNameArr;


@end

@implementation OutSourceNeedDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getTeamNeedDetail];
    [self getTeams];
    // Do any additional setup after loading the view.
}

- (void)initViewByModel:(NeedModel *)needModel{
    [_icon sd_setImageWithURL:[NSURL URLWithString:URLFrame(needModel.icon_url)] placeholderImage:[UIImage imageNamed:@"default_team_head"]];
    _need_title.text = needModel.title;
    _team_name.text = needModel.team_name;
    _field.text = needModel.field;
    _skill.text = needModel.skill;
    _degree.text = needModel.degree;
    _area.text = needModel.province;
    _number.text = needModel.number;
    _fee.text = needModel.cost;
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

- (void)getTeams{
    NSString *url = [NSString stringWithFormat:@"%@?limit=%d",URL_GET_OWNED_TEAMS, 1000];
    [[NetRequest sharedInstance] httpRequestWithGET:url success:^(id data, NSString *message) {
        _teamArr = [TeamModel mj_objectArrayWithKeyValuesArray:data[@"list"]];
        _teamNameArr = [NSMutableArray array];
        for (TeamModel *team in _teamArr) {
            [_teamNameArr addObject:team.name];
        }
    } failed:^(id data, NSString *message) {
    }];
}

- (IBAction)applyButtonAction:(id)sender {
    [ActionSheetStringPicker showPickerWithTitle:@"请选择团队" rows:@[_teamNameArr] initialSelection:@[@0] doneBlock:^(ActionSheetStringPicker *picker, NSArray *selectedIndex, NSArray *selectedValue) {
        TeamModel *model = [_teamArr objectAtIndex:[selectedIndex[0] integerValue]];
        [self applyToServerByTeamId:model.team_id];
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self.view];

}

- (void)applyToServerByTeamId: (NSString *)team_id{
    [[NetRequest sharedInstance] httpRequestWithPost:URL_GET_TEAM_COPORATION_REQUESTS(team_id, _needModel.need_id)  parameters:@{} withToken:NO success:^(id data, NSString *message) {
        [[SVHudManager sharedInstance] showSuccessHudWithTitle:@"申请成功" andTime:1.0f DoneBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } failed:^(id data, NSString *message) {
        [[SVHudManager sharedInstance] showErrorHudWithTitle:@"申请失败" andTime:1.0f];
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

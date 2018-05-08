//
//  TaskDetailController.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/6/8.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "TaskDetailController.h"
#import "TaskInternalReleaseController.h"

@interface TaskDetailController ()

@property (weak, nonatomic) IBOutlet UIImageView *headIcon;
@property (weak, nonatomic) IBOutlet UILabel *team_name;
@property (weak, nonatomic) IBOutlet UILabel *executor_name;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *submitNum;
@property (weak, nonatomic) IBOutlet UILabel *assignNum;
@property (weak, nonatomic) IBOutlet UILabel *timeCreated;
@property (weak, nonatomic) IBOutlet UILabel *deadline;
@property (weak, nonatomic) IBOutlet UITextView *content;
@property (weak, nonatomic) IBOutlet UILabel *taskTitle;

@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@end

@implementation TaskDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [self getTaskDetail];
}

- (void)getTaskDetail{
    [[NetRequest sharedInstance] httpRequestWithGET:URL_GET_INTERNAL_TASK_DETAIL(_taskModel.task_id) success:^(id data, NSString *message) {
        _taskModel = [TaskModel mj_objectWithKeyValues:data];
        [self setTaskContent];
    } failed:^(id data, NSString *message) {
        
    }];
}


- (void)setTaskContent{
    [_headIcon sd_setImageWithURL:[NSURL URLWithString:URLFrame(_taskModel.icon_url)] placeholderImage:[UIImage imageNamed:@"default_team_head"]];
    _team_name.text = _taskModel.team_name;
    _executor_name.text = _taskModel.executor_name;
    _status.text = [self getStatusText:_taskModel.status];
    _submitNum.text = [NSString stringWithFormat:@"%@次", _taskModel.submit_num];
    _assignNum.text = [NSString stringWithFormat:@"%@次", _taskModel.assign_num];
    _timeCreated.text = _taskModel.time_created;
    _deadline.text = _taskModel.deadline;
    _content.text = _taskModel.content;
    if (_enterWay == 0) {
        //团队
        if ([_taskModel.status integerValue] == 1) {
            //再派任务
            [_leftButton setTitle:@"再派任务" forState:UIControlStateNormal];
            [_rightButton setTitle:@"返回" forState:UIControlStateNormal];
        }else if([_taskModel.status integerValue] == 3){
            [_leftButton setTitle:@"验收通过" forState:UIControlStateNormal];
            [_rightButton setTitle:@"拒绝" forState:UIControlStateNormal];
        }else{
            [_leftButton setHidden:YES];
            [_rightButton setHidden:YES];
        }
    }else{
        //个人
        if ([_taskModel.status integerValue] == 0) {
            [_leftButton setTitle:@"同意接受" forState:UIControlStateNormal];
            [_rightButton setTitle:@"拒绝接受" forState:UIControlStateNormal];
        }else if([_taskModel.status integerValue] == 2){
            [_leftButton setTitle:@"已完成，提交" forState:UIControlStateNormal];
            [_rightButton setTitle:@"返回" forState:UIControlStateNormal];
        }else if([_taskModel.status integerValue] == 4){
            [_leftButton setTitle:@"已完成，再次提交" forState:UIControlStateNormal];
            [_rightButton setTitle:@"返回" forState:UIControlStateNormal];
        }else{
            [_leftButton setHidden:YES];
            [_rightButton setHidden:YES];
        }
    }
}


- (NSString *)getStatusText: (NSString *)status{
    /*('等待接受', 0), ('再派任务', 1),
     ('等待完成', 2), ('等待验收', 3),
     ('再次提交', 4), ('按时结束', 5),
     ('超时结束', 6), ('终止', 7)*/
    NSString *statusText = @"";
    switch ([status integerValue]) {
        case 0:
            statusText = @"等待接受";
            break;
        case 1:
            statusText = @"再派任务";
            break;
        case 2:
            statusText = @"等待完成";
            break;
        case 3:
            statusText = @"等待验收";
            break;
        case 4:
            statusText = @"再次提交";
            break;
        case 5:
            statusText = @"按时结束";
            break;
        case 6:
            statusText = @"超时结束";
            break;
        case 7:
            statusText = @"终止";
            break;
            
        default:
            break;
    }
    return statusText;
}


//改变任务的状态
- (void)changeTaskStatus: (NSString *)status{
    NSDictionary *params = @{@"status" : status};
    [[NetRequest sharedInstance] httpRequestWithPost:URL_GET_INTERNAL_TASK_DETAIL(_taskModel.task_id) parameters:params withToken:NO success:^(id data, NSString *message) {
       [[SVHudManager sharedInstance] showSuccessHudWithTitle:@"操作成功" andTime:1.0f DoneBlock:^{
           [self.navigationController popViewControllerAnimated:YES];
       }];
    } failed:^(id data, NSString *message) {
        [[SVHudManager sharedInstance] showErrorHudWithTitle:@"操作失败" andTime:1.0f];
    }];
}

- (IBAction)leftButtonAction:(id)sender {
    if (_enterWay == 0) {
        //团队
        if ([_taskModel.status integerValue] == 1) {
            //再派任务
            //跳转到分派任务页面
            TaskInternalReleaseController *vc = [TaskInternalReleaseController new];
            vc.enterWay = 1;
            vc.taskModel = _taskModel;
            vc.model = _teamModel;
            vc.resignDoneBlock = ^{
                
            };
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if([_taskModel.status integerValue] == 3){
            //验收
            [self changeTaskStatus:@""];
        }else{
            [_leftButton setHidden:YES];
            [_rightButton setHidden:YES];
        }
    }else{
        //个人
        if ([_taskModel.status integerValue] == 0) {
            [self changeTaskStatus:@"2"];
        }else if([_taskModel.status integerValue] == 2){
            [self changeTaskStatus:@"3"];
        }else if([_taskModel.status integerValue] == 4){
            [self changeTaskStatus:@"3"];
        }else{
            [_leftButton setHidden:YES];
            [_rightButton setHidden:YES];
        }
    }

}

- (IBAction)rightButtonAction:(id)sender {
    if (_enterWay == 0) {
        //团队
        if ([_taskModel.status integerValue] == 1) {
            //再派任务
            [self.navigationController popViewControllerAnimated:YES];
        }else if([_taskModel.status integerValue] == 3){
            [self changeTaskStatus:@"4"];
        }else{
            [_leftButton setHidden:YES];
            [_rightButton setHidden:YES];
        }
    }else{
        //个人
        if ([_taskModel.status integerValue] == 0) {
            [self changeTaskStatus:@"1"];
        }else if([_taskModel.status integerValue] == 2){
            [self.navigationController popViewControllerAnimated:YES];
        }else if([_taskModel.status integerValue] == 4){
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [_leftButton setHidden:YES];
            [_rightButton setHidden:YES];
        }
    }
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

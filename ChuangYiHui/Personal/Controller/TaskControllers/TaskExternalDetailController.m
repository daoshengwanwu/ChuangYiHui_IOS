//
//  TaskExternalDetailController.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/6/8.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "TaskExternalDetailController.h"

@interface TaskExternalDetailController ()

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
@property (weak, nonatomic) IBOutlet UILabel *expend;
@property (weak, nonatomic) IBOutlet UILabel *expendActual;

@end

@implementation TaskExternalDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getTaskDetail];
    // Do any additional setup after loading the view.
}

- (void)getTaskDetail{
    [[NetRequest sharedInstance] httpRequestWithGET:URL_GET_EXTERNAL_TASK_DETAIL(_taskModel.task_id) success:^(id data, NSString *message) {
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
    _expend.text = _taskModel.expend;
    _expendActual.text = _taskModel.expend_actual;
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

//
//  TaskModel.h
//  ChuangYiHui
//
//  Created by litingdong on 2017/6/6.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskModel : NSObject

@property (nonatomic, copy)NSString *task_id;
@property (nonatomic, copy)NSString *team_id;
@property (nonatomic, copy)NSString *team_name;
@property (nonatomic, copy)NSString *icon_url;

/*('等待接受', 0), ('再派任务', 1),
 ('等待完成', 2), ('等待验收', 3),
 ('再次提交', 4), ('按时结束', 5),
 ('超时结束', 6), ('终止', 7)*/
@property (nonatomic, copy)NSString *status;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *time_created;
@property (nonatomic, copy)NSString *executor_id;
@property (nonatomic, copy)NSString *executor_name;

@property (nonatomic, copy)NSString *content;
//花费
@property (nonatomic, copy)NSString *expend;
//实际费用
@property (nonatomic, copy)NSString *expend_actual;
//分派次数
@property (nonatomic, copy)NSString *assign_num;
//提交次数
@property (nonatomic, copy)NSString *submit_num;
//支付次数
@property (nonatomic, copy)NSString *pay_num;
//任务期限
@property (nonatomic, copy)NSString *deadline;
//任务完成时间
@property (nonatomic, copy)NSString *finish_time;



@end

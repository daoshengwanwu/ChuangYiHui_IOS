//
//  InternalTaskCell.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/6/6.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "InternalTaskCell.h"

@interface InternalTaskCell()

@property (weak, nonatomic) IBOutlet UIImageView *head_icon;
@property (weak, nonatomic) IBOutlet UILabel *task_title;
@property (weak, nonatomic) IBOutlet UILabel *complete_percentage;
@property (weak, nonatomic) IBOutlet UILabel *task_status;

@end

@implementation InternalTaskCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setCellByTaskModel:(TaskModel *)model{
    _task_title.text = model.title;
    [_head_icon sd_setImageWithURL:[NSURL URLWithString:URLFrame(model.icon_url)] placeholderImage:[UIImage imageNamed:@"default_user_head"]];
    //进度
    _complete_percentage.text = [self getRate:model.status];
    //阶段
    _task_status.text = [self getStage:model.status];
}

/*('等待接受', 0), ('再派任务', 1),
 ('等待完成', 2), ('等待验收', 3),
 ('再次提交', 4), ('按时结束', 5),
 ('超时结束', 6), ('终止', 7)*/
- (NSString *)getRate: (NSString *)status{
    if ([status integerValue] == 0||[status integerValue] == 1) {
        return @"0%";
    }else if([status integerValue] == 2 || [status integerValue] == 4){
        return @"33%";
    }else if([status integerValue] == 3 ){
        return @"66%";
    }else if([status integerValue] == 5 || [status integerValue] == 6){
        return @"100%";
    }else{
        return @"100%";
    }
}

- (NSString *)getStage: (NSString *)status{
    NSArray *stageArr = @[@"等待接受", @"再派任务", @"等待完成", @"等待验收", @"再次提交", @"按时结束", @"超时结束", @"终止"];
    return stageArr[[status integerValue]];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

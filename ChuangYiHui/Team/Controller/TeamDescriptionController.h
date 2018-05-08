//
//  TeamDescriptionController.h
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/19.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamDescriptionController : UIViewController


//0 可编辑 1 只能查看
@property (nonatomic, assign)NSInteger type;

@property (nonatomic, strong)void(^setContentBlock)(NSString *content);

@property (nonatomic, strong)NSString *team_description;

@end

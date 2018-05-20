//
//  PeopleRequireDetailController.h
//  ChuangYiHui
//
//  Created by BaiHaoran on 2018/5/17.
//  Copyright © 2018年 litingdong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublishRequireModel.h"

@interface PeopleRequireDetailController : UIViewController

- (PeopleRequireDetailController*)initWithPublishRequireModel:(PublishRequireModel*)model Type:(NSInteger)type;

@end

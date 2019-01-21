//
//  ZjcgDetailController.h
//  ChuangYiHui
//
//  Created by p1p1us on 2019/1/16.
//  Copyright © 2019年 litingdong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublishRequireModel.h"

@interface ZjcgDetailController : UIViewController

- (ZjcgDetailController*)initWithPublishRequireModel:(PublishRequireModel*)model Type:(NSInteger)type;

@end

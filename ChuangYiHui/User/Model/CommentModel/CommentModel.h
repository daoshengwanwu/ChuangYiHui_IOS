//
//  CommentModel.h
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/25.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject

@property (nonatomic, copy)NSString *comment_id;
@property (nonatomic, copy)NSString *author_id;
@property (nonatomic, copy)NSString *author_name;
@property (nonatomic, copy)NSString *icon_url;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *time_created;

@end

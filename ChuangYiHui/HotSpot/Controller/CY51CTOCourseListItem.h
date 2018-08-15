//
//  CY51CTOCourseListItem.h
//  ChuangYiHui
//
//  Created by BaiHaoran on 2018/8/13.
//  Copyright © 2018年 litingdong. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CY51CTOCourseListItem : NSObject

@property (nonatomic, strong) NSString * course_id; //课程id
@property (nonatomic, strong) NSString * title; //课程标题
@property (nonatomic, strong) NSString * img_mid; //封面图地址
@property (nonatomic, strong) NSString * lec_name; //讲师姓名
@property (nonatomic, strong) NSString * parent_name; //一级分类
@property (nonatomic, strong) NSString * cat_name; //二级分类
@property (nonatomic, strong) NSString * lession_nums; //课时数
@property (nonatomic, strong) NSString * study_nums; //学习人数

@end

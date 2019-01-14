//
//  HttpURL.h
//  GoldUnion
//
//  Created by GYY on 20/04/2016.
//  Copyright © 2016 LEE . All rights reserved.
//

#ifndef HttpURL_h
#define HttpURL_h

//测试的服务器
//#define SERVER_DOMIN       @"120.27.30.169"

//甲方的服务器
#define SERVER_DOMIN       @"www.chuangyh.com:8000"


#define BASE_URL  [NSString stringWithFormat:@"http://%@/", SERVER_DOMIN]

#define URLFrame(str)       [NSString stringWithFormat: @"%@%@", BASE_URL, str]


#pragma mark 创友模块

//get 获取用户列表 post 注册
#define URL_GET_USERS URLFrame(@"users/")
#define URL_GET_TEAMS URLFrame(@"teams/")
#define URL_GET_SELF_PROFILE URLFrame(@"users/current/profile/")
#define URL_GET_FRIENDS URLFrame(@"users/current/friends/")
#define URL_GET_FOLLOWERS URLFrame(@"users/current/followers/")
#define URL_GET_COMPETITIONS URLFrame(@"users/current/competition/")
#define URL_GET_SCORE_RECORDS URLFrame(@"users/current/score_records/")
#define URL_GET_FRIEND_REQUESTS URLFrame(@"users/current/friend_requests/")
#define URL_GET_TEAM_INVITATIONS URLFrame(@"users/current/invitations/")
#define URL_GET_RELATED_TEAMS URLFrame(@"users/current/teams/")
#define URL_GET_OWNED_TEAMS URLFrame(@"users/current/teams/owned/")
#define URL_GET_FOLLOWED_USERS URLFrame(@"users/current/followed/users/")
#define URL_GET_FOLLOWED_TEAMS URLFrame(@"users/current/followed/teams/")
#define URL_CREATE_EDUCATION_EXPERIENCE URLFrame(@"users/current/experiences/education/")
#define URL_CREATE_FIELDWORK_EXPERIENCE URLFrame(@"users/current/experiences/fieldwork/")
#define URL_CREATE_WORK_EXPERIENCE URLFrame(@"users/current/experiences/work/")
//登录
#define URL_LOGIN URLFrame(@"users/token/")
//修改头像
#define URL_CHANGE_USER_ICON URLFrame(@"users/current/icon/")
//验证码
#define URL_SEND_SMS_CODE URLFrame(@"users/validation_code/")
//忘记密码
#define URL_FORGET_PASSWORD URLFrame(@"users/password_forgotten/")
//上传认证的身份证图片
#define URL_UPLOAD_ID_CARD_IMAGE URLFrame(@"users/current/id_card/")
//上传认证的其他图片
#define URL_UPLOAD_OTHER_IMAGE URLFrame(@"users/current/other_card/")
//身份认证
#define URL_IDENTITY_VERIFY URLFrame(@"users/current/other_identity_verification/")

//意见反馈
#define URL_FEEDBACK URLFrame(@"users/current/feedback/")
//绑定手机号
#define URL_BIND_PHONE URLFrame(@"users/current/bind_phone_number/")
//修改密码
#define URL_CHANGE_PASSWORD URLFrame(@"users/current/password/")

#define URL_GET_OTHER_USER_PROFILE(userId) [NSString stringWithFormat: @"%@users/%@/profile/", BASE_URL, userId]
#define URL_GET_OTHER_USER_RELATED_TEAMS(userId) [NSString stringWithFormat: @"%@users/%@/joined_teams/", BASE_URL, userId]
#define URL_GET_OTHER_USER_OWNED_TEAMS(userId) [NSString stringWithFormat: @"%@users/%@/owned_teams/", BASE_URL, userId]
//检测是否点赞
#define URL_CHECK_IF_LIKE(userId) [NSString stringWithFormat: @"%@users/current/liked/users/%@/", BASE_URL, userId]
//检测是否点赞活动/竞赛
#define URL_CHECK_IF_LIKE_ACTIVITY(type,activityId) [NSString stringWithFormat: @"%@users/current/liked/%@/%@/", BASE_URL, type, activityId]
//get 检测是否点赞动态 post点赞  delete取消点赞
#define URL_CHECK_IF_LIKE_ACTION(type,userId) [NSString stringWithFormat: @"%@users/current/liked/%@_actions/%@/", BASE_URL, type, userId]
//检测是否收藏动态
#define URL_CHECK_IF_FAVOR_ACTION(type,userId) [NSString stringWithFormat: @"%@users/current/favored/%@_actions/%@/", BASE_URL, type, userId]

//检测是否收藏活动/竞赛
#define URL_CHECK_IF_FAVOR_ACTICITY(type,activityID) [NSString stringWithFormat: @"%@users/current/favored/%@/%@/", BASE_URL, type, activityID]

//检测是否是好友
#define URL_CHECK_IF_FRIEND(myId, otherId) [NSString stringWithFormat: @"%@users/%@/friends/%@/", BASE_URL, myId, otherId]
//发送好友请求
#define URL_SEND_FRIEND_REQUEST(userId) [NSString stringWithFormat: @"%@users/%@/friend_requests/", BASE_URL, userId]
//get:获取某个用户的评论 post:对某个用户评价
#define URL_GET_USER_COMMENTS(userId) [NSString stringWithFormat: @"%@users/%@/comments/", BASE_URL, userId]
//get:获取某个动态的评论 post:对某个动态评论
#define URL_GET_EVENT_COMMENTS(type,event_id) [NSString stringWithFormat: @"%@users/current/%@_action/%@/comments/", BASE_URL, type, event_id]
//举报
#define URL_REPORT URLFrame(@"users/current/report/")
//点赞和取消点赞
#define URL_LIKE_AND_UNLIKE(userId) [NSString stringWithFormat: @"%@users/current/liked/users/%@/", BASE_URL, userId]

//获取教育经历
#define URL_GET_EDUCATIONS_EXPERIENCE URLFrame(@"users/current/experiences/education/")
//获取实习经历
#define URL_GET_FIELDWORK_EXPERIENCE URLFrame(@"users/current/experiences/fieldwork/")
//获取工作经历
#define URL_GET_WORK_EXPERIENCE URLFrame(@"users/current/experiences/work/")

//获取他人的教育经历
#define URL_GET_OTHER_EDUCATIONS_EXPERIENCE(userId) [NSString stringWithFormat: @"%@users/%@/experiences/education/", BASE_URL, userId]
//获取他人的实习经历
#define URL_GET_OTHER_WORKS_EXPERIENCE(userId) [NSString stringWithFormat: @"%@users/%@/experiences/work/", BASE_URL, userId]
//获取他人的工作经历
#define URL_GET_OTHER_FIELDWORKS_EXPERIENCE(userId) [NSString stringWithFormat: @"%@users/%@/experiences/fieldwork/", BASE_URL, userId]
//删除/修改工作经历
#define URL_DELETE_POST_EXPERIENCE(expId) [NSString stringWithFormat: @"%@users/experiences/%@/", BASE_URL, expId]
//关注
//判断是否关注，关注，取消关注
#define URL_FOCUS_USER(userId) [NSString stringWithFormat: @"%@users/current/followed/users/%@/", BASE_URL, userId]
//判断是否关注团队，关注，取消关注
#define URL_FOCUS_TEAM(teamId) [NSString stringWithFormat: @"%@users/current/followed/teams/%@/", BASE_URL, teamId]




#pragma mark 团队模块

//创建团队
#define URL_CREATE_TEAM URLFrame(@"teams/")
//获取团队的资料
#define URL_GET_TEAM_PROFILE(teamId) [NSString stringWithFormat: @"%@teams/%@/profile/", BASE_URL, teamId]
//修改团队的头像
#define URL_CHANGE_TEAM_ICON(teamId) [NSString stringWithFormat: @"%@teams/%@/icon/", BASE_URL, teamId]
//检测是否点赞，点赞或取消点赞
#define URL_TEAM_LIKE_AND_UNLIKE(teamId) [NSString stringWithFormat: @"%@users/current/liked/teams/%@/", BASE_URL, teamId]

//get 检测是否是团队成员
//post 将目标用户添加为自己的团队成员
#define URL_CHECK_IS_MEMBER(teamId, userId) [NSString stringWithFormat: @"%@teams/%@/members/%@/", BASE_URL, teamId, userId]
//获取团队成员列表
#define URL_GET_TEAM_MEMBERS(teamId) [NSString stringWithFormat: @"%@teams/%@/members/", BASE_URL, teamId]
//忽略某个用户的加入团队请求
#define URL_DELETE_TEAM_MEMBER_REQUESTS(teamId, userId) [NSString stringWithFormat: @"%@teams/%@/member_requests/%@/", BASE_URL, teamId, userId]
//get 获取团队的用户加入申请  post 向团队发送加入申请
#define URL_TEAM_MEMBER_REQUESTS(teamId) [NSString stringWithFormat: @"%@teams/%@/member_requests/", BASE_URL, teamId]
//向用户发出加入团队的邀请
#define URL_TEAM_INVITE(teamId, userId) [NSString stringWithFormat: @"%@teams/%@/invitations/%@/", BASE_URL, teamId, userId]
//最近访客
#define URL_TEAM_VISITORS(teamId) [NSString stringWithFormat: @"%@teams/%@/visitors/", BASE_URL, teamId]


#pragma mark 任务模块

//获取我的内部任务
#define URL_GET_MY_INTERNAL_TASKS URLFrame(@"teams/owned_internal_tasks/")
//获取团队的内部任务列表 和 发布内部任务
#define URL_GET_TEAM_INTERNAL_TASKS(teamId) [NSString stringWithFormat: @"%@teams/%@/internal_tasks/", BASE_URL, teamId]
//再派任务的情况下，修改任务详情 post
#define URL_CHANGE_INTERNAL_TASKS(taskId) [NSString stringWithFormat: @"%@teams/internal_tasks/%@/", BASE_URL, taskId]
//获取内部任务详情(get)  和  改变内部任务的状态(post)
#define URL_GET_INTERNAL_TASK_DETAIL(taskId) [NSString stringWithFormat: @"%@teams/%@/internal_task/", BASE_URL, taskId]


//获取团队的外部任务列表 和 发布外部任务
#define URL_GET_TEAM_EXTERNAL_TASKS(teamId) [NSString stringWithFormat: @"%@teams/%@/external_tasks/", BASE_URL, teamId]
//再派任务的情况下，修改外部任务详情 post
#define URL_CHANGE_EXTERNAL_TASKS(taskId) [NSString stringWithFormat: @"%@teams/external_tasks/%@/", BASE_URL, taskId]
//获取外部任务详情(get)  和  改变外部任务的状态(post)
#define URL_GET_EXTERNAL_TASK_DETAIL(taskId) [NSString stringWithFormat: @"%@teams/%@/external_task/", BASE_URL, taskId]


#pragma mark 需求模块
//获取所有的人员需求
#define URL_GET_ALL_MEMBER_NEEDS  URLFrame(@"teams/needs/member/")
//获取所有的外包需求
#define URL_GET_ALL_OUTSOURCE_NEEDS URLFrame(@"teams/needs/outsource/")
//获取所有的承接需求
#define URL_GET_ALL_UNDERTAKE_NEEDS URLFrame(@"teams/needs/undertake/")

//获取所有的专家成果
#define URL_GET_ALL_ZJCG URLFrame(@"users/achievements/")
//获取所有的实验室成果
#define URL_GET_ALL_SYSCG URLFrame(@"labs/achievements/")

//获取关注的人员动态
#define URL_GET_FOLLOWED_USER_EVENT URLFrame(@"users/current/followed_user/actions/")
//获取关注的团队动态
#define URL_GET_FOLLOWED_TEAM_EVENT URLFrame(@"users/current/followed_team/actions/")

//获取所有的人员动态
#define URL_GET_ALL_USER_EVENT URLFrame(@"users/current/user_actions/")
//获取所有的团队动态
#define URL_GET_ALL_TEAM_EVENT URLFrame(@"users/current/team_actions/")

//获取所有的专家动态
#define URL_GET_ALL_EXPERT_EVENT URLFrame(@"users/current/expert_actions/")
//获取所有的实验室动态
#define URL_GET_ALL_LAB_EVENT URLFrame(@"users/current/lab_actions/")

//获取某个团队的人员需求
#define URL_GET_TEAM_MEMBER_NEEDS(teamId) [NSString stringWithFormat: @"%@teams/%@/needs/member/", BASE_URL, teamId]
//获取某个团队的外包需求
#define URL_GET_TEAM_OUTSOURCE_NEEDS(teamId) [NSString stringWithFormat: @"%@teams/%@/needs/outsource/", BASE_URL, teamId]
//获取某个团队的承接需求
#define URL_GET_TEAM_UNDERTAKE_NEEDS(teamId) [NSString stringWithFormat: @"%@teams/%@/needs/undertake/", BASE_URL, teamId]

//获取需求详情
#define URL_GET_TEAM_NEED_DETAIL(needId) [NSString stringWithFormat: @"%@teams/needs/%@/", BASE_URL, needId]

//get:获取人员需求的加入申请列表  post:向人员需求发出加入申请
#define URL_GET_TEAM_MEMBER_NEED_REQUESTS(needId) [NSString stringWithFormat: @"%@teams/%@/needs/member_requests/", BASE_URL, needId]
//post:将目标成员添加为自己的成员 delete:忽视目标成员的请求
#define URL_ACCEPT_TEAM_MEMBER_NEED_REQUESTS(needId, userId) [NSString stringWithFormat: @"%@teams/%@/needs/member_requests/%@/", BASE_URL, needId, userId]
//get 获取需求的合作申请列表  post 发送请求
#define URL_GET_TEAM_COPORATION_REQUESTS(teamId, needId) [NSString stringWithFormat: @"%@teams/%@/needs/requests/%@/", BASE_URL, teamId, needId]
//post 同意团队的合作申请并将队长添加到自己团队 get 获取团队的合作申请  delete 忽略团队的合作请求
#define URL_AGREE_TEAM_COPORATION_REQUESTS(teamId, needId) [NSString stringWithFormat: @"%@teams/%@/needs/request/%@/", BASE_URL, teamId, needId]


#pragma mark 成果模块
//获取某个团队的成果
#define URL_GET_TEAM_ACHIEVEMENTS(teamId) [NSString stringWithFormat: @"%@teams/%@/achievements/", BASE_URL, teamId]
//获取所有的成果
#define URL_GET_ALL_ACHIEVEMENTS URLFrame(@"teams/achievements/")


#pragma mark 活动模块
#define URL_GET_ALL_ACTIVITIES URLFrame(@"activity/")
//获取活动的详情
#define URL_GET_ACTIVITY_DETAIL(activityId) [NSString stringWithFormat: @"%@activity/%@/", BASE_URL, activityId]
//获取活动的评论
#define URL_GET_ACTIVITY_COMMENTS(activityId) [NSString stringWithFormat: @"%@activity/%@/comments/", BASE_URL, activityId]
//获取活动的参与用户列表
#define URL_GET_ACTIVITY_PARTICIPATE_USERS(activityId) [NSString stringWithFormat: @"%@activity/%@/user_participators/", BASE_URL, activityId]
//根据名字搜索活动
#define URL_SEARCH_ACTIVITY(name) [NSString stringWithFormat: @"%@activity/search/?name=%@", BASE_URL, name]
//筛选活动
#define URL_SCREEN_ACTIVITY [NSString stringWithFormat: @"%@activity/screen/", BASE_URL]
//获取活动的粉丝列表
#define URL_GET_ACTIVITY_FANS(activityId) [NSString stringWithFormat: @"%@activity/%@/followers/", BASE_URL, activityId]



#pragma mark 竞赛模块
#define URL_GET_ALL_COMPETITIONS  URLFrame(@"competition/")
//获取竞赛排名
#define URL_GET_COMPETITION_RANK(competitionId) [NSString stringWithFormat: @"%@competition/%@/awards/", BASE_URL, competitionId]
//获取竞赛的详情
#define URL_GET_COMPETITION_DETAIL(competitionId) [NSString stringWithFormat: @"%@competition/%@/", BASE_URL, competitionId]
//获取竞赛的团队参与列表
#define URL_GET_COMPETITION_PARTICIPATE_TEAMS(competitionId)  [NSString stringWithFormat: @"%@competition/%@/team_participators/", BASE_URL, competitionId]
//获取竞赛的评论
#define URL_GET_COMPETITION_COMMENTS(competitionId)  [NSString stringWithFormat: @"%@competition/%@/comments/", BASE_URL, competitionId]
//根据名字搜索竞赛
#define URL_SEARCH_COMPETITION(name) [NSString stringWithFormat: @"%@competition/search/?name=%@", BASE_URL, name]
//筛选活动
#define URL_SCREEN_COMPETITION [NSString stringWithFormat: @"%@competition/screen/", BASE_URL]
//获取竞赛的通知
#define URL_GET_COMPETITION_NOTIFICATIONS(competitionId) [NSString stringWithFormat: @"%@competition/%@/notifications/", BASE_URL, competitionId]
//获取团队的上传文件信息
#define URL_GET_TEAM_UPLOAD_FILE_LIST(teamId) [NSString stringWithFormat: @"%@competition/%@/files/", BASE_URL, teamId]
//get 获取某个竞赛的上传文件信息  post 上传文件
#define URL_GET_TEAM_UPLOAD_FILE_LIST_OF_COMPETITION(teamId, competitionId) [NSString stringWithFormat: @"%@competition/%@/files/%@/", BASE_URL, teamId, competitionId]
//获取竞赛的粉丝列表
#define URL_GET_COMPETITION_FANS(competitionId) [NSString stringWithFormat: @"%@competition/%@/followers/", BASE_URL, competitionId]

#define URL_51CTO_BASE = @"http://openedu.51cto.com/api/"
#define URL_51CTO_BASE_TEST = @"http://test.openedu.51cto.com/api/"
#define URL_COURSE_LIST = @"course/course_list"
#define URL_COURSE_DETAIL = @"course/course_detail"
#define URL_COURSE_LESSON = @"course/course_lesson"


#endif /* HttpURL_h */

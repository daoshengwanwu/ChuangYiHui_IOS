//
//  CompetitionDetailControllerViewController.m
//  ChuangYiHui
//
//  Created by litingdong on 2018/6/11.
//  Copyright © 2018年 p1p1us. All rights reserved.
//

#import "CompetitionDetailControllerViewController.h"
#import "UserManager.h"
#import "PersonalQRCodeController.h"
#import "ObjectListController.h"
#import "OwendTeamPickerView.h"
#import "LabelLabelArrowCell.h"

@interface CompetitionDetailControllerViewController ()<OwendTeamPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *competition_title;
@property (weak, nonatomic) IBOutlet UILabel *competition_title_detail;
@property (weak, nonatomic) IBOutlet UILabel *participate_count;
@property (weak, nonatomic) IBOutlet UIImageView *collect_image;
@property (weak, nonatomic) IBOutlet UIImageView *likeImage;
@property (weak, nonatomic) IBOutlet UILabel *liker_count;
@property (weak, nonatomic) IBOutlet UIImageView *QRCode_image;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UITextView *competition_detail;
@property (weak, nonatomic) IBOutlet UIButton *join_in_button;
@property (weak, nonatomic) IBOutlet UILabel *comment_label;
@property (weak, nonatomic) IBOutlet UIView *comment_view;


@property (nonatomic, strong)OwendTeamPickerView *owendteamPickerView;

@property (nonatomic, assign)BOOL isLiked;
//检测是否是朋友
@property (nonatomic, assign)BOOL isFriend;
//判断是否已经关注
@property (nonatomic, assign)BOOL isFocused;
//判断是否已经报名
@property (nonatomic, assign)BOOL applied;
//名额已满，来晚了
@property (nonatomic, assign)BOOL is_status1_but_full;
@property (nonatomic, assign)NSInteger likerCount;

//@property (nonatomic, assign)NSInteger user_participator_count;
//@property (nonatomic, assign)NSInteger team_participator_count;

@end

@implementation CompetitionDetailControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isLiked = NO;
    _isFocused = NO;
    _applied = NO;
    
    [self judgeApplied];
    [self getCompetitionProfile];
    [self checkIfLike:_model.competition_id];
    [self checkIfCollected:_model.competition_id];
    //    [self addBottonView];
    
}


- (void)back{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//获取个人资料
- (void)getCompetitionProfile{
    [[NetRequest sharedInstance] httpRequestWithGET:URL_GET_COMPETITION_DETAIL(_model.competition_id) success:^(id data, NSString *message) {
        _model = [CompetitionModel mj_objectWithKeyValues:data];
        _liker_count.text = _model.liker_count;
        _likerCount = [_model.liker_count integerValue];
        _participate_count.text =  [NSString stringWithFormat:@"%@/%@团队已报名", _model.team_participator_count, _model.allow_team ];
        //        _user_participator_count = [_model.user_participator_count integerValue];
        _competition_detail.text = _model.content;
        _competition_title.text = _model.name;
        _competition_title_detail.text = [NSString stringWithFormat:@"%@至%@   %@", _model.time_started, _model.time_ended, _model.province];
        //        _time_started = _model.time_started;
        //        _time_ended = _model.time_ended;
        //        _province = _model.province;
        //        _allow_user = _model.allow_user;
        if ([_model.status isEqualToString:@"0"]){
            _status.text = @"未开始";
            _status.textColor = [UIColor grayColor];
            [_join_in_button setTitle:@"竞赛未开始" forState:UIControlStateNormal];
            _join_in_button.backgroundColor = [UIColor grayColor];//button的背景颜色
        }
        else if ([_model.status isEqualToString:@"1"]){
            if (_applied){
//                NSLog(@"22222");
                _status.text = @"当前排名";
                [_join_in_button setTitle:@"已报名" forState:UIControlStateNormal];
                
            }
            else{
                if([_model.user_participator_count isEqualToString:_model.allow_user]) {
                    _status.text = @"名额已满";
                    _status.textColor = [UIColor redColor];
                    [_join_in_button setTitle:@"名额已满" forState:UIControlStateNormal];
                    _join_in_button.backgroundColor = [UIColor grayColor];//button的背景颜色
                    _is_status1_but_full = YES;
                }else{
                    //                    ActivityAvailable.setText("可报名");
                    //                    ActivityAppliedOrNot.setText("我要报名");
                    //                    ll_Apply.setBackgroundColor(Color.rgb(255,165,0));
                }
            }
        }
        else if ([_model.status isEqualToString:@"6"]){
            _status.text = @"竞赛结束";
            _status.textColor = [UIColor redColor];
            [_join_in_button setTitle:@"竞赛结束" forState:UIControlStateNormal];
            _join_in_button.backgroundColor = [UIColor grayColor];//button的背景颜色
        }
        else{
            if (_applied) {
                _status.text = @"进行中";
                [_join_in_button setTitle:@"查看详情" forState:UIControlStateNormal];
//                _join_in_button.backgroundColor = [UIColor grayColor];//button的背景颜色
            }
            else{
                _status.text = @"报名结束";
                [_join_in_button setTitle:@"报名结束" forState:UIControlStateNormal];
                _join_in_button.backgroundColor = [UIColor grayColor];//button的背景颜色
            }
        }
        //        _status.text = _model.status;
        [self getCommentDetail];
        
        UITapGestureRecognizer *likeviewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeTap:)];
        _likeImage.userInteractionEnabled = YES;  //这句话千万不能忘记了
        [_likeImage addGestureRecognizer:likeviewTap];
        
        UITapGestureRecognizer *collectviewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(collectTap:)];
        _collect_image.userInteractionEnabled = YES;  //这句话千万不能忘记了
        [_collect_image addGestureRecognizer:collectviewTap];
        
        UITapGestureRecognizer *qrcodeviewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(QRCodeTap:)];
        _QRCode_image.userInteractionEnabled = YES;  //这句话千万不能忘记了
        [_QRCode_image addGestureRecognizer:qrcodeviewTap];
        
        UITapGestureRecognizer *commentviewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTap:)];
        _comment_view.userInteractionEnabled = YES;  //这句话千万不能忘记了
        [_comment_view addGestureRecognizer:commentviewTap];
        
        UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)];
        [_status addGestureRecognizer:labelTapGestureRecognizer];
        _status.userInteractionEnabled = YES; // 可以理解为设置label可被点击
        
        [_join_in_button addTarget:self action:@selector(joinTap) forControlEvents:UIControlEventTouchUpInside];
        
    } failed:^(id data, NSString *message) {
        [SVProgressHUD showErrorWithStatus:message];
    }];
}
//点赞、取消点赞
- (void)likeTap:(UITapGestureRecognizer *)recognizer
{
    if(_isLiked){
        [self unLike:_model.competition_id];
    }else{
        [self like:_model.competition_id];
    }
}
- (void)labelClick:(UITapGestureRecognizer *)recognizer
{
    if ([_status.text isEqualToString:@"当前排名"]) {
        ObjectListController *vc = [ObjectListController new];
        //    vc.object_id = [NSString stringWithFormat:@"%ld", recognizer.view.tag];
        vc.object_id = _model.competition_id;
        vc.displayType = Competition_Rank;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
//收藏、取消收藏
- (void)collectTap:(UITapGestureRecognizer *)recognizer
{
    if(_isFocused){
        [self unFocus:_model.competition_id];
    }else{
        [self focus:_model.competition_id];
    }
}
//点击二维码
- (void)QRCodeTap:(UITapGestureRecognizer *)recognizer
{
    UIStoryboard *personalSB = [UIStoryboard storyboardWithName:@"Personal" bundle:nil];
    PersonalQRCodeController *vc = [personalSB instantiateViewControllerWithIdentifier:@"QRCodeController"];
    vc.object_id = _model.competition_id;
    vc.type = @"competition";
    [self.navigationController pushViewController:vc animated:YES];
}

//点击评论
- (void)commentTap:(UITapGestureRecognizer *)recognizer
{
    //    _personactionArr[]
    ObjectListController *vc = [ObjectListController new];
    //    vc.object_id = [NSString stringWithFormat:@"%ld", recognizer.view.tag];
    vc.object_id = _model.competition_id;
    vc.displayType = Competition_Comments;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)joinTap{
    if (_applied==NO&&[_model.status isEqualToString:@"1"]) {
        if(_is_status1_but_full){
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                           message:@"亲，名额已满，你来晚了！"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      //响应事件
                                                                      NSLog(@"action = %@", action);
                                                                  }];
            //            UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault
            //                                                                 handler:^(UIAlertAction * action) {
            //                                                                     //响应事件
            //                                                                     NSLog(@"action = %@", action);
            //                                                                 }];
            
            [alert addAction:defaultAction];
            //            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else{
//            //显示弹出框列表选择
//            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
//                                                                           message:@"请选择一个团队报名"
//                                                                    preferredStyle:UIAlertControllerStyleActionSheet];
//
//            UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
//                                                                 handler:^(UIAlertAction * action) {
//                                                                     //响应事件
//                                                                     NSLog(@"action = %@", action);
//                                                                 }];
//            UIAlertAction* deleteAction = [UIAlertAction actionWithTitle:@"团队" style:UIAlertActionStyleDestructive
//                                                                 handler:^(UIAlertAction * action) {
//                                                                     //响应事件
//                                                                     NSLog(@"action = %@", action);
//                                                                 }];
//            UIAlertAction* saveAction = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault
//                                                               handler:^(UIAlertAction * action) {
//                                                                   //响应事件
//                                                                   NSLog(@"action = %@", action);
//                                                               }];
//            [alert addAction:saveAction];
//            [alert addAction:cancelAction];
//            [alert addAction:deleteAction];
//            [self presentViewController:alert animated:YES completion:nil];
            //队伍
            _owendteamPickerView = [[OwendTeamPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            _owendteamPickerView.delegate = self;
            UIWindow *win=[UIApplication sharedApplication].keyWindow;
            [win addSubview:_owendteamPickerView];
//            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
//                                                                           message:@"是否确认报名？"
//                                                                    preferredStyle:UIAlertControllerStyleAlert];
//                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault
//                                                                      handler:^(UIAlertAction * action) {
//                                                                          //响应事件
//                                                                          [[NetRequest sharedInstance] httpRequestWithPost:URL_GET_COMPETITION_PARTICIPATE_TEAMS(_model.competition_id) parameters:nil withToken:YES success:^(id data, NSString *message) {
//                                                                              UIAlertController* alert1 = [UIAlertController alertControllerWithTitle:@"提示"
//                                                                                                                                              message:@"报名成功！"
//                                                                                                                                       preferredStyle:UIAlertControllerStyleAlert];
//
//                                                                              UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
//                                                                                                                                    handler:^(UIAlertAction * action) {
//                                                                                                                                        //响应事件
//                                                                                                                                        NSLog(@"action = %@", action);
//                                                                                                                                    }];
//
//                                                                              [alert1 addAction:defaultAction];
//                                                                              NSLog(@"competition_id=%@",_model.competition_id);
//                                                                              [self presentViewController:alert1 animated:YES completion:nil];
//                                                                              [self getCompetitionProfile];
//                                                                          } failed:^(id data, NSString *message) {
//                                                                              //                                                                          NSString *ss = [UserManager dealError:[data valueForKey:@"statusCode"] andParam2:message];
//                                                                              //                                                                          NSLog(@"datais:%@",data);
//                                                                              //                                                                          NSLog(@"messageis:%@",message);
//                                                                              [SVProgressHUD showErrorWithStatus:message];
//                                                                          }];
//                                                                      }];
//            UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault
//                                                                 handler:^(UIAlertAction * action) {
//                                                                     //响应事件
//                                                                     NSLog(@"action = %@", action);
//                                                                     //队伍
//                                                                     _owendteamPickerView = [[OwendTeamPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//                                                                     _owendteamPickerView.delegate = self;
//                                                                     UIWindow *win=[UIApplication sharedApplication].keyWindow;
//                                                                     [win addSubview:_owendteamPickerView];
//                                                                 }];
//
//            [alert addAction:defaultAction];
//            [alert addAction:cancelAction];
//            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}


//#pragma mark SchoolPickerViewDelegate
//-(void)OwendTeamPickerViewConfirmClickWith:(NSArray *)arr{
//    if (arr.count!=2) {
//
//        return;
//    }
//
//    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:1];
//    LabelLabelArrowCell *cell = [_tableView cellForRowAtIndexPath:path];
//    [cell setOnlyContent:arr[1]];
//}


//判断是否已报名
- (void)judgeApplied{
//    [[NetRequest sharedInstance] httpRequestWithGET:URL_GET_COMPETITION_PARTICIPATE_TEAMS(_model.competition_id) success:^(id data, NSString *message) {
//        //        _commentmodel = [CommentModel mj_objectWithKeyValues:data];
////        TeamModel *teamModel = [TeamModel mj_objectWithKeyValues:data];
////        UserModel *userModel = [[UserManager sharedManager] getCurrentUser];
//        NSString *currentCompetitionId = [NSString stringWithFormat:@"id = %@;", _model.competition_id];
//        NSLog(@"size:%@",[data objectForKey:@"list"]);
        [[NetRequest sharedInstance] httpRequestWithGET:URL_GET_COMPETITIONS success:^(id data, NSString *message) {
            NSString *members = [[data objectForKey:@"list"] componentsJoinedByString:@" "];
            NSString *currentCompetitionId = [NSString stringWithFormat:@"id = %@;", _model.competition_id];
            NSLog(@"members%@",members);
                //        NSLog(@"currentUserName%@",currentUserName);
            if ([members containsString:currentCompetitionId]) {
                _applied = YES;
                _status.text = @"当前排名";
                [_join_in_button setTitle:@"已报名" forState:UIControlStateNormal];
                _join_in_button.backgroundColor = [UIColor grayColor];//button的背景颜色
                    //            NSLog(@"applied%@",_applied);
            } else {
                _applied = NO;
            }
        }failed:^(id data, NSString *message) {
            [SVProgressHUD showErrorWithStatus:message];
        }];
//    } failed:^(id data, NSString *message) {
//        [SVProgressHUD showErrorWithStatus:message];
//    }];
}

//获取评论详情
- (void)getCommentDetail{
    [[NetRequest sharedInstance] httpRequestWithGET:URL_GET_COMPETITION_COMMENTS(_model.competition_id) success:^(id data, NSString *message) {
        //        _commentmodel = [CommentModel mj_objectWithKeyValues:data];
        _comment_label.text = [NSString stringWithFormat:@"评论(%@)",[data objectForKey:@"count"]];
        //        NSLog(@"datadata%@",data);
    } failed:^(id data, NSString *message) {
        [SVProgressHUD showErrorWithStatus:message];
    }];
}

//检测是否点过赞
- (void)checkIfLike: (NSString *)competition_id{
    [[NetRequest sharedInstance] httpRequestWithGET:URL_CHECK_IF_LIKE_ACTIVITY(@"competitions",competition_id) success:^(id data, NSString *message) {
        NSLog(@"已点赞");
        _isLiked = YES;
        [self setLikeImg:_isLiked];
    } failed:^(id data, NSString *message) {
        NSLog(@"未点赞");
        _isLiked = NO;
        [self setLikeImg:_isLiked];
    }];
}

- (void)setLikeImg: (BOOL)likeOrNot{
    if (likeOrNot) {
        [_likeImage setImage:[UIImage imageNamed:@"zan_on"]];
    }else{
        [_likeImage setImage:[UIImage imageNamed:@"zan_off"]];
    }
}

//点赞
- (void)like: (NSString *)competition_id{
    [[NetRequest sharedInstance] httpRequestWithPost:URL_CHECK_IF_LIKE_ACTIVITY(@"competitions",competition_id) parameters:@{} withToken:NO success:^(id data, NSString *message) {
        _isLiked = YES;
        [self setLikeImg:_isLiked];
        _likerCount = _likerCount + 1;
        NSLog(@"点赞成功 %ld", _likerCount);
        [_liker_count setText:[NSString stringWithFormat:@"%ld", _likerCount]];
    } failed:^(id data, NSString *message) {
        
    }];
}

//取消点赞
- (void)unLike: (NSString *)competition_id{
    [[NetRequest sharedInstance] httpRequestWithDELETE:URL_CHECK_IF_LIKE_ACTIVITY(@"competitions",competition_id) success:^(id data, NSString *message) {
        _isLiked = NO;
        [self setLikeImg:_isLiked];
        _likerCount = _likerCount - 1;
        NSLog(@"取消点赞成功 %ld", _likerCount);
        [_liker_count setText:[NSString stringWithFormat:@"%ld", _likerCount]];
    } failed:^(id data, NSString *message) {
    }];
}


//监测是否收藏过
- (void)checkIfCollected: (NSString *)competition_id{
    [[NetRequest sharedInstance] httpRequestWithGET:URL_CHECK_IF_FAVOR_ACTICITY(@"competitions",competition_id) success:^(id data, NSString *message) {
        NSLog(@"已关注");
        _isFocused = YES;
        [self setCollectImg:_isFocused];
    } failed:^(id data, NSString *message) {
        NSLog(@"未关注");
        _isFocused = NO;
        [self setCollectImg:_isFocused];
    }];
}

- (void)setCollectImg: (BOOL)collectOrNot{
    if (collectOrNot) {
        [_collect_image setImage:[UIImage imageNamed:@"star_icon_hover"]];
    }else{
        [_collect_image setImage:[UIImage imageNamed:@"star_icon"]];
    }
}

//收藏
- (void)focus: (NSString *)competition_id{
    [[NetRequest sharedInstance] httpRequestWithPost:URL_CHECK_IF_FAVOR_ACTICITY(@"competitions",competition_id) parameters:@{} withToken:NO success:^(id data, NSString *message) {
        _isFocused = YES;
        [self setCollectImg:_isFocused];
    } failed:^(id data, NSString *message) {
        [SVProgressHUD showErrorWithStatus:message];
    }];
}

//取消收藏
- (void)unFocus: (NSString *)competition_id{
    [[NetRequest sharedInstance] httpRequestWithDELETE:URL_CHECK_IF_FAVOR_ACTICITY(@"competitions",competition_id) success:^(id data, NSString *message) {
        _isFocused = NO;
        [self setCollectImg:_isFocused];
    } failed:^(id data, NSString *message) {
        [SVProgressHUD showErrorWithStatus:message];
    }];
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


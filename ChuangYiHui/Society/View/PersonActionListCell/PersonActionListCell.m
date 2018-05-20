//
//  PersonActionListCell.m
//  ChuangYiHui
//
//  Created by p1p1us on 2018/5/7.
//  Copyright © 2018年 litingdong. All rights reserved.
//

#import "PersonActionListCell.h"

@implementation PersonActionListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCellByPersonActionModel: (PersonActionModel *)model{
    _title.text = model.name;
    [_head_icon sd_setImageWithURL:[NSURL URLWithString:URLFrame(model.icon)] placeholderImage:[UIImage imageNamed:@"default_user_head"]];
    _like_count.text = model.liker_count;
//    _date_time.text = model.time_created;
    _date_time.text = [model.time_created stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    _number.text = model.comment_count;
//    _content.text = [[NSString alloc] initWithFormat:@"%@,%@,%@,%@", model.name, model.action,model.object_type,model.object_name];
    NSString *tmp = @"";
    if([model.action isEqual:@"join"]){
        tmp = @"加入";
    }else if ([model.action isEqual:@"create"]){
        tmp = @"创建";
    }else if ([model.action isEqual:@"leave"]){
        tmp = @"离开";
    }else{
        tmp = @"发布";
    }
    NSString * str1 = [[NSString alloc] initWithFormat:@"%@ <font color='#FF0000'><small>%@</small></font> %@", model.name, tmp ,model.object_name ];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[str1 dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    _content.attributedText = attributedString;
    _content.font = [UIFont fontWithName:@"Arial" size:18];
    [[NetRequest sharedInstance] httpRequestWithGET:URL_CHECK_IF_LIKE_ACTION(@"user", model.action_id) success:^(id data, NSString *message) {
//        NSLog(@"已点赞");
//        _isLiked = YES;
        [_like_button setImage:[UIImage imageNamed:@"zan_on"]];
    } failed:^(id data, NSString *message) {
//        NSLog(@"未点赞");
//        _isLiked = NO;
        [_like_button setImage:[UIImage imageNamed:@"zan_off"]];
    }];
    [[NetRequest sharedInstance] httpRequestWithGET:URL_CHECK_IF_FAVOR_ACTION(@"user", model.action_id) success:^(id data, NSString *message) {
//        NSLog(@"已收藏");
        //        _isLiked = YES;
        [_StarButton setImage:[UIImage imageNamed:@"star_icon_hover"]];
    } failed:^(id data, NSString *message) {
//        NSLog(@"未收藏");
        //        _isLiked = NO;
        [_StarButton setImage:[UIImage imageNamed:@"star_icon"]];
    }];
}

//- (void) combineTheWord(String subject, String verb, String object){
//    Map<String, String> map = new HashMap<String, String>();
//
//    map.put("join", "加入");
//    map.put("create", "创建");
//    map.put("leave", "离开");
//    map.put("send", "发布");
//
//    if (map.containsKey(verb))
//        return subject + " " + "<font color='#FF0000'><small>"+map.get(verb) +"</small></font>"+ " " + object;
//    else
//        return subject + " <font color='#FF0000'><small>***</small></font> " + object;
//}
//
//
////将团队动态的英文转化为中文
//public static String combineTeamWord(String subject, String verb, String object){
//    //        Map<String, String> map = new HashMap<String, String>();
//    //
//    //        map.put("join", "加入");
//    //        map.put("create", "创建");
//    //        map.put("leave", "离开");
//    //        map.put("send", "发布");
//    //
//    //        if (map.containsKey(verb))
//    //            return subject + map.get(verb) + object;
//    //        else
//    //            return subject + "***" + object;
//
//    if (verb.equals("join")){
//        return subject + " " + "<font color='#FF0000'><small>"+"同意了"+"</small></font>"+ " " + object + " " + "<font color='#FF0000'><small>"+"的加入申请"+"</small></font>";
//    }else if(verb.equals("create_team")){
//        return object  + " " + "<font color='#FF0000'><small>"+ "创建了"+"</small></font>"+ " " + subject  + "<font color='#FF0000'><small>"+ " "+"团队"+"</small></font>";
//    }else if(verb.equals("leave")){
//        return subject+ " " + "<font color='#FF0000'><small>" + "踢出了成员" +"</small></font>"+" "+ object;
//    }else if(verb.equals("send")){
//        return subject+ " " + "<font color='#FF0000'><small>"  + "发布了"+"</small></font>"+" " + object;
//    }else{
//        return subject + " " + "<font color='#FF0000'><small>"  + "***"+"</small></font>"+" " + object;
//    }
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

//
//  ActivityDetailController.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/8/13.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "ActivityDetailController.h"

@interface ActivityDetailController ()

@property (weak, nonatomic) IBOutlet UILabel *activity_title;
@property (weak, nonatomic) IBOutlet UILabel *activity_title_detail;
@property (weak, nonatomic) IBOutlet UILabel *participate_count;
@property (weak, nonatomic) IBOutlet UIImageView *collect_image;
@property (weak, nonatomic) IBOutlet UIImageView *likeImage;
@property (weak, nonatomic) IBOutlet UILabel *liker_count;
@property (weak, nonatomic) IBOutlet UIImageView *QRCode_image;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UITextView *activity_detail;
@property (weak, nonatomic) IBOutlet UIButton *join_in_button;
@property (weak, nonatomic) IBOutlet UILabel *comment_label;
@property (weak, nonatomic) IBOutlet UIView *comment_view;
@end

@implementation ActivityDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self addBottomButton];
    
    // Do any additional setup after loading the view.
}

//- (void)addBottomButton{
//    UIButton *bottomButton = [UIButton new];
//    [self.view addSubview:bottomButton];
//    [bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.view.mas_bottom);
//        make.left.right.mas_equalTo(0);
//        make.height.mas_equalTo(40);
//    }];
//    bottomButton.backgroundColor = [UIColor greenColor];
//}

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

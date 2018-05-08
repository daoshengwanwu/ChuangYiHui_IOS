//
//  ServiceProtocolController.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/22.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "ServiceProtocolController.h"

@interface ServiceProtocolController ()

@property (nonatomic, strong)UIWebView *webView;

@end

@implementation ServiceProtocolController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"服务协议";
    self.view.backgroundColor = [UIColor whiteColor];
    //加载webview
    [self initWebView];
    // Do any additional setup after loading the view.
}


- (void)initWebView{
    _webView = [UIWebView new];
    [self.view addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"protocol" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
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

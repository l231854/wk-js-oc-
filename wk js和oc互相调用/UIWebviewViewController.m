//
//  UIWebviewViewController.m
//  wk js和oc互相调用
//
//  Created by 雷王 on 2018/12/20.
//  Copyright © 2018年 WL. All rights reserved.
//

#import "UIWebviewViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface UIWebviewViewController ()<UIWebViewDelegate>
@property (nonatomic,strong) UIWebView *webview;
@property (strong, nonatomic) JSContext *context;

@end

@implementation UIWebviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}
#pragma mark - createUI
-(void)createUI{
    self.webview = [[UIWebView alloc] init];
    self.webview.frame=self.view.frame;
    self.webview.delegate=self;
    [self.view addSubview:self.webview];
    //对中文进行处理
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"index"
                                                          ofType:@"html"];
    NSString * htmlContent = [NSString stringWithContentsOfFile:htmlPath
                                                       encoding:NSUTF8StringEncoding
                                                          error:nil];
    [self.webview loadHTMLString:htmlContent baseURL:baseURL];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //初始化content
    self.context = [self.webview valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    __weak typeof(self)weakSelf = self;
    self.context[@"jsToOC"] = ^(NSString *str1, NSString *str2, NSString *str3) {
                NSArray *thisArr = [JSContext currentArguments];
        NSLog(@"1111");
        [weakSelf ocToH5];
    };
}

#pragma mark --oc回调给h5
-(void)ocToH5{
    NSString * callback= @"ocToJs('123')";
    [self.context evaluateScript:callback];

}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *URL = request.URL;
    NSString *scheme = [URL scheme];
    if ([scheme isEqualToString:@""]) {
        [self handleCustomAction:URL];
        return NO;
    }
    return YES;
}
#pragma mark - private method
- (void)handleCustomAction:(NSURL *)URL
{
}
@end

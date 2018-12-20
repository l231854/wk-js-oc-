//
//  WKWebViewController.m
//  wk js和oc互相调用
//
//  Created by 雷王 on 2018/12/19.
//  Copyright © 2018年 WL. All rights reserved.
//

#import "WKWebViewController.h"
#import <WebKit/WebKit.h>

@interface WKWebViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>
@property (nonatomic,strong) WKWebView *wkWebview;
@end

@implementation WKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}
#pragma mark --创建UI
-(void)createUI{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.preferences = [WKPreferences new];
    //The minimum font size in points default is 0;
    config.preferences.minimumFontSize = 0;
    //是否支持JavaScript
    config.preferences.javaScriptEnabled = YES;
    //不通过用户交互，是否可以打开窗口
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    //通过JS与webView内容交互
    config.userContentController = [WKUserContentController new];
    
    self.wkWebview = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    self.wkWebview.navigationDelegate = self;
    self.wkWebview.UIDelegate = self;
    [self.view addSubview:self.wkWebview];
    [self registerJsFunction];
    
    //对中文进行处理
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"index"
                                                          ofType:@"html"];
    NSString * htmlContent = [NSString stringWithContentsOfFile:htmlPath
                                                       encoding:NSUTF8StringEncoding
                                                          error:nil];
    [self.wkWebview loadHTMLString:htmlContent baseURL:baseURL];
}

#pragma mark --注册js方法
-(void)registerJsFunction{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:@"jsToOC"];
    
    for (NSString *strFunction in array) {
        [self.wkWebview.configuration.userContentController addScriptMessageHandler:self name:strFunction];
        
    }
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if([message.name isEqualToString:@"jsToOC"]) {
        [self jsToOC:message.body];
    }
}

#pragma mark --获取到对应的js然后执行对应的方法
- (void)jsToOC:(NSString *)strMessage{
    if ([strMessage isEqualToString:@"clickBtn1"]) {
        NSLog(@"clickBtn1");
    }else if  ([strMessage isEqualToString:@"clickBtn2"]) {
        NSLog(@"clickBtn2");
        [self.wkWebview evaluateJavaScript:[NSString stringWithFormat:@"ocToJs('%@')",@"123456"] completionHandler:nil];

    }
}

// 弹出alert
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    //    DLOG(@"msg = %@ frmae = %@",message,frame);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
}



@end

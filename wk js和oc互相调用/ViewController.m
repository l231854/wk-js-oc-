//
//  ViewController.m
//  wk js和oc互相调用
//
//  Created by 雷王 on 2018/12/19.
//  Copyright © 2018年 WL. All rights reserved.
//

#import "ViewController.h"
#import "WKWebViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self createUI];
}
#pragma mark --创建UI
-(void)createUI{
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(100, 100, 100, 44);
    [button setTitle:@"js和oc互相调用" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(btnOfClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
}

-(void)btnOfClick{
    WKWebViewController *vc = [[WKWebViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end

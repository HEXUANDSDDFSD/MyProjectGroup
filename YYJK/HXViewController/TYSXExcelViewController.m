//
//  TYSXExcelViewController.m
//  tysx
//
//  Created by zwc on 14/11/17.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "TYSXExcelViewController.h"

@interface TYSXExcelViewController ()

@end

@implementation TYSXExcelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:webView];
    [webView locationAtSuperView:self.view edgeInsets:UIEdgeInsetsZero];
    
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"关键指标汇总日报.xlsx"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    // Do any additional setup after loading the view.
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

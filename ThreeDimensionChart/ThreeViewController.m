//
//  HXBaseViewController.m
//  ThreeDimensionChart
//
//  Created by 客人用户 on 16/8/13.
//  Copyright © 2016年 MYSTERIOUS. All rights reserved.
//

#import "ThreeViewController.h"
#import "OpenGLESViewController.h"

@interface ThreeViewController ()

@end

@implementation ThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *tBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tBtn.frame = CGRectMake(0, 0, 200, 60);
    tBtn.tag = 1;
    tBtn.center = CGPointMake(self.view.center.x, self.view.center.y - 80);
    tBtn.backgroundColor = [UIColor cyanColor];
    [tBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tBtn];
    
    UIButton *bBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bBtn.tag = 2;
    bBtn.frame = CGRectMake(0, 0, 200, 60);
    bBtn.center = CGPointMake(self.view.center.x, self.view.center.y + 80);
    bBtn.backgroundColor = [UIColor cyanColor];
     [bBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bBtn];
    // Do any additional setup after loading the view.
}

- (void)btnAction:(UIButton *)sender {
    [self.navigationController pushViewController:[[OpenGLESViewController alloc] initWithTag:sender.tag] animated:YES];
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

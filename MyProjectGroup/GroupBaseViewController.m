//
//  GroupBaseViewController.m
//  MyProjectGroup
//
//  Created by hexuan on 2017/4/8.
//  Copyright © 2017年 hexuan. All rights reserved.
//

#import "GroupBaseViewController.h"

@interface GroupBaseViewController ()

@end

@implementation GroupBaseViewController {
    UIButton *backBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (backBtn == nil) {
        backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(self.view.width - 120, 10, 100, 44);
        backBtn.layer.cornerRadius = 5;
        [backBtn setTitle:@"返回主菜单" forState:UIControlStateNormal];
        backBtn.backgroundColor = [UIColor redColor];
        [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:backBtn];
    }
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
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

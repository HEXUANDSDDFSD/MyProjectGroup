//
//  HXSettingViewController.m
//  tysx
//
//  Created by zwc on 14-6-16.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "HXSettingViewController.h"
#import "HXMainMenuViewController.h"
#import "UIView+CornerRadius.h"

@interface HXSettingViewController ()

@end

@implementation HXSettingViewController
@synthesize rightImage;
@synthesize rightViewWidth;
@synthesize screenImage;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *rightView = [[UIImageView alloc] initWithImage:self.rightImage];
    rightView.frame = CGRectMake(kScreenWidth - rightViewWidth, 0, rightViewWidth, kScreenHeight);
    [self.view addSubview:rightView];
    
    UITapGestureRecognizer *tapGestrure = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestrue:)];
    [rightView addGestureRecognizer:tapGestrure];
    rightView.userInteractionEnabled = YES;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    label.text = @"设置";
    label.font = [UIFont systemFontOfSize:30];
    label.center = CGPointMake(self.view.center.x, 80);
    [self.view addSubview:label];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor brownColor];
    button.frame = CGRectMake(0, 400, 200, 100);
    [button setTitle:@"注销" forState:UIControlStateNormal];
    [self.view addSubview:button];
}

- (void)becomeActive {
    
}

- (void)tapGestrue:(UITapGestureRecognizer *)gesture{
    UIImageView *leftImageView = [[UIImageView alloc] initWithImage:[self.view snapshotImageWithSize:CGSizeMake(kScreenWidth - rightViewWidth, kScreenHeight)]];
    leftImageView.frame = CGRectMake(0, 0, kScreenWidth - rightViewWidth, kScreenHeight);
    
    UIImageView *rightImageView = [[UIImageView alloc] initWithImage:self.screenImage];
    rightImageView.frame = CGRectMake(kScreenWidth - rightViewWidth, 0, kScreenWidth, kScreenHeight);
    
    [self.view.window addSubview:leftImageView];
    [self.view.window addSubview:rightImageView];
    
    [UIView animateWithDuration:0.2 animations:^{
        leftImageView.frame = CGRectMake(-leftImageView.bounds.size.width, 0, leftImageView.bounds.size.width, leftImageView.bounds.size.height);
        rightImageView.frame = CGRectMake(rightImageView.frame.origin.x - kScreenWidth + rightViewWidth, 0, rightImageView.bounds.size.width, rightImageView.bounds.size.height);
    } completion:^(BOOL complete){
        if (complete) {
            [leftImageView removeFromSuperview];
            [rightImageView removeFromSuperview];
            HXMainMenuViewController *ctr = [[HXMainMenuViewController alloc] init];
            self.view.window.rootViewController = ctr;
        }

    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)logoutAction {
    NSLog(@"logout....");
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

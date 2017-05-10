//
//  PPTVActiveUsersViewController.m
//  tysx
//
//  Created by zwc on 14/10/22.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "IPTVActiveUsersViewController.h"

@interface IPTVActiveUsersViewController ()

@end

@implementation IPTVActiveUsersViewController

- (id)initWithPlotName:(NSString *)plotName {
    if (self = [super initWithPlotName:plotName]) {
        useDefaultPlot = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
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

//
//  ViewController.m
//  MyProjectGroup
//
//  Created by hexuan on 2017/4/6.
//  Copyright © 2017年 hexuan. All rights reserved.
//

#import "ViewController.h"
#import "HXMainMenuViewController.h"
#import "LLKViewController.h"
#import "ThreeViewController.h"
#import "TetrisGameViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
    NSArray *classList;
}

- (instancetype)init {
    if (self = [super init]) {
        classList = @[@"HXMainMenuViewController",@"LLKViewController",@"TetrisGameViewController",@"ThreeViewController"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *titleList = @[@"运营监控",@"连连看",@"俄罗斯方块",@"3D柱状图"];
    CGFloat offsetY = 100;
    for (int i = 0; i < [classList count]; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((self.view.width - 200) / 2, offsetY, 200, 50);
        btn.tag = i;
        btn.layer.cornerRadius = 5;
        [btn setTitle:titleList[i] forState:UIControlStateNormal];
        [self.view addSubview:btn];
        [btn addTarget:self action:@selector(pushMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor orangeColor];
        offsetY += 120;
    }
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)pushMenuViewController:(UIButton *)sender {

    UIViewController *ctr = [[NSClassFromString(classList[sender.tag]) alloc] init];
   [self.navigationController pushViewController:ctr animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

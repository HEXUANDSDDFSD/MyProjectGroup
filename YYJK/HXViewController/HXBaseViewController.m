//
//  HXBaseViewController.m
//  tysx
//
//  Created by zwc on 13-12-10.
//  Copyright (c) 2013年 huangjia. All rights reserved.
//

#import "HXBaseViewController.h"
#import "MYDrawContentView.h"
#import "HXMainMenuViewController.h"

@interface HXBaseViewController ()

@end

@implementation HXBaseViewController

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.transform=CGAffineTransformMakeRotation(-M_PI*1.5);
}

- (void)backMenuView {
    CGFloat scale = 0.27;
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:ctx];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.view.bounds.size.width * scale, self.view.bounds.size.height * scale), NO, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0, 0, self.view.bounds.size.width * scale, self.view.bounds.size.height * scale)];
    ctx = UIGraphicsGetCurrentContext();
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    NSString *imagePath = [KCachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", NSStringFromClass([self class])]];
    [imageData writeToFile:imagePath atomically:YES];
    
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (BOOL)shouldAutorotate
//{
//    return YES;
//}

// 支持的屏幕方向，此处可直接返回 UIInterfaceOrientationMask 类型
// 也可以返回多个 UIInterfaceOrientationMask 取或运算后的值
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight;
}

@end

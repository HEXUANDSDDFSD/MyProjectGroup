//
//  TYSXTempShowViewController.m
//  tysx
//
//  Created by zwc on 14/12/8.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "TYSXTempShowViewController.h"
#import "MYDrawContentView.h"

@interface TYSXTempShowViewController ()<MYDrawContentViewDrawDelegate>

@end

@implementation TYSXTempShowViewController {
    NSString *_filePath;
    NSString *_imageName;
}

- (id)initWithFilePath:(NSString *)path {
    if (path.length == 0) {
        return nil;
    }
    
    if (self = [super init]) {
        _filePath = path;
    }
    return self;
}

- (id)initWithImageName:(NSString *)imgName {
    if (imgName.length == 0) {
        return nil;
    }
    if (self = [super init]) {
        _imageName = imgName;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MYDrawContentView *drawContentView = [[MYDrawContentView alloc] initWithFrame:CGRectZero];
    drawContentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:drawContentView];
    drawContentView.drawDelegate = self;
    [drawContentView locationAtSuperView:self.view edgeInsets:UIEdgeInsetsZero];
    
    if (_filePath.length != 0) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 50, kScreenHeight, kScreenWidth - 50)];
        [self.view addSubview:webView];
    
        NSURL *url = [NSURL fileURLWithPath:_filePath];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [webView loadRequest:request];
    }
    else {
        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_imageName]];
        [self.view addSubview:bgImageView];
        [bgImageView locationAtSuperView:self.view edgeInsets:UIEdgeInsetsZero];
    }
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAciton:)];
    
    UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 80)];
    [tapView addGestureRecognizer:tapGesture];
    [self.view addSubview:tapView];
}

- (void)contentView:(MYDrawContentView*)view drawRect:(CGRect)rect {
    
    if (_filePath.length == 0) {
        return;
    }
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    
    [attr setValue:[UIFont systemFontOfSize:20] forKey:NSFontAttributeName];
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraph.alignment = NSTextAlignmentCenter;
    [attr setValue:paragraph forKey:NSParagraphStyleAttributeName];
    
//    [_plotName drawInRect:CGRectMake(0, 10, rect.size.width, rect.size.height) withAttributes:attr];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGPoint oriPoint = CGPointMake(30, 24);
    CGFloat horOffset = 14;
    CGFloat verOffset = 11;
    
    CGContextSetFillColorWithColor(ctx, [UIColor grayColor].CGColor);
    CGContextMoveToPoint(ctx, oriPoint.x, oriPoint.y);
    CGContextAddLineToPoint(ctx, oriPoint.x + horOffset, oriPoint.y - verOffset);
    CGContextAddLineToPoint(ctx, oriPoint.x + horOffset, oriPoint.y + verOffset);
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
    
    CGContextSetStrokeColorWithColor(ctx, [UIColor grayColor].CGColor);
    CGContextMoveToPoint(ctx, 0, 49);
    CGContextAddLineToPoint(ctx, rect.size.width, 49);
    CGContextStrokePath(ctx);
}

- (void)tapGestureAciton:(UITapGestureRecognizer *)tapGesture{
   // CGPoint touchPoint = [tapGesture locationInView:self.view];
   // if (touchPoint.y < 44 && touchPoint.x < 280) {
        [self.navigationController popToRootViewControllerAnimated:NO];
   // }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

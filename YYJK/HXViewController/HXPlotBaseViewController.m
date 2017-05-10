//
//  HXPlotBaseViewController.m
//  tysx
//
//  Created by zwc on 14-7-25.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "HXPlotBaseViewController.h"
#import "HXDatePickerView.h"

#define kDatePickBgViewTag 'dpbv'
#define kDatePickViewTag 'dpvt'

@interface HXPlotBaseViewController ()<MYDrawContentViewDrawDelegate>

@end

@implementation HXPlotBaseViewController {
    NSString *plotName;
}

- (id)initWithPlotName:(NSString *)name {
    if (self = [super init]) {
        plotName = name;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    drawView = [[MYDrawContentView alloc] initWithFrame:CGRectZero];
    drawView.drawDelegate = self;
    drawView.backgroundColor = [UIColor whiteColor];
    self.view = drawView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- MYDrawContentView delegate

- (void)contentView:(MYDrawContentView*)view drawRect:(CGRect)rect {
    
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    
    [attr setValue:[UIFont systemFontOfSize:20] forKey:NSFontAttributeName];
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraph.alignment = NSTextAlignmentCenter;
    [attr setValue:paragraph forKey:NSParagraphStyleAttributeName];
    
    [plotName drawInRect:CGRectMake(0, 10, rect.size.width, rect.size.height) withAttributes:attr];
    
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
    
    int offsetTop = 10;
    int offsetLeft = 29;
//    [[UIImage imageNamed:@"logo_lit.png"] drawAtPoint:CGPointMake(offsetLeft, offsetTop)];
//    
//    [[UIColor grayColor] set];
//    [plotName drawAtPoint:CGPointMake(87, 18) withFont:[UIFont systemFontOfSize:18]];
    
    offsetTop += 34;
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextMoveToPoint(context, 0, offsetTop);
//    CGContextAddLineToPoint(context, rect.size.width, offsetTop);
//    CGContextSetLineWidth(context, 0.7);
//    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
//    CGContextStrokePath(context);
    
    offsetTop += 15;
    NSString *dateStr = [self lastDateStr];
    [dateStr drawAtPoint:CGPointMake(offsetLeft, offsetTop) withFont:[UIFont systemFontOfSize:20]];
}

- (void)contentView:(MYDrawContentView*)view touchBeginAtPoint:(CGPoint)p {
    if (p.y < 44 && p.x < 280) {
        [self backMenuView];
    }
    else if (p.y > 44 && p.x < 280 && p.y < 100) {
        [self showDatePickView];
    }
}

- (void)showDatePickView {
    
    if (isGuest()) {
        return;
    }
    
    UIView *datePickerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenHeight, kScreenWidth)];
    datePickerBgView.tag = kDatePickBgViewTag;
    
    UIControl *control = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, kScreenHeight, kScreenWidth)];
    
    control.backgroundColor = [UIColor blackColor];
    control.alpha = 0.4;
    
    [datePickerBgView addSubview:control];
    
    HXDatePickerView *datePickerView = [[HXDatePickerView alloc] initWithFrame:CGRectMake(0, 0, 350, 0)];
    datePickerView.backgroundColor = [UIColor darkGrayColor];
    datePickerView.tag = kDatePickViewTag;
    
    datePickerView.center = datePickerBgView.center;
    datePickerView.layer.cornerRadius = 10;
    
    [datePickerBgView addSubview:datePickerView];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(datePickerView.frame.origin.x + 10, datePickerView.frame.origin.y + datePickerView.bounds.size.height + 10, 100, 50);
    cancelBtn.backgroundColor = kFreshBlueColor;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.layer.cornerRadius = 5;
    [cancelBtn addTarget:self action:@selector(dismissDatePickView) forControlEvents:UIControlEventTouchUpInside];
    [datePickerBgView addSubview:cancelBtn];
    
    UIButton *chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseBtn.frame = CGRectMake(datePickerView.frame.origin.x + datePickerView.bounds.size.width - 10 - 100, datePickerView.frame.origin.y + datePickerView.bounds.size.height + 10, 100, 50);
    chooseBtn.backgroundColor = kFreshBlueColor;
    [chooseBtn addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];
    [chooseBtn setTitle:@"选择" forState:UIControlStateNormal];
    chooseBtn.layer.cornerRadius = 5;
    [datePickerBgView addSubview:chooseBtn];
    
    [self.view addSubview:datePickerBgView];
}

- (void)dismissDatePickView {
    UIView *datePickerBgView = [self.view viewWithTag:kDatePickBgViewTag];
    [datePickerBgView removeFromSuperview];
}

- (void)chooseAction:(UIButton *)sender {
    UIView *view = [sender superview];
    HXDatePickerView *datePicker = (HXDatePickerView *)[view viewWithTag:kDatePickViewTag];
    if ([datePicker isKindOfClass:[HXDatePickerView class]]) {
        [self changeDateAction:datePicker.date];
    }
}

- (void)changeDateAction:(NSDate *)date {
    
}

- (NSString *)lastDateStr {
    return nil;
}

@end

//
//  OSSCachePlotViewController.m
//  tysx
//
//  Created by zwc on 14/11/24.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "OSSCachePlotViewController.h"
#import "HXDatePickerView.h"

#define kDatePickBgViewTag 'dpbv'
#define kDatePickViewTag 'dpvt'

@interface GraffitiBoardView : UIView

@property (nonatomic, assign) BOOL isDraw;

@end

@implementation GraffitiBoardView {
    UIBezierPath *path;
    UIImage *cacheImage;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        path = [UIBezierPath bezierPath];
        self.userInteractionEnabled = YES;
        _isDraw = YES;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [cacheImage drawInRect:rect];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if (_isDraw) {
        CGContextSetBlendMode(ctx, kCGBlendModeNormal);
        CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
        CGContextSetLineWidth(ctx, 2);
    }
    else {
        CGContextSetBlendMode(ctx, kCGBlendModeCopy);
        CGContextSetStrokeColorWithColor(ctx, [UIColor clearColor].CGColor);
        CGContextSetLineWidth(ctx, 20);
    }
    
    CGContextAddPath(ctx, path.CGPath);
    CGContextStrokePath(ctx);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches allObjects][0];
    CGPoint startPoint = [touch locationInView:self];
    [path moveToPoint:startPoint];
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches allObjects][0];
    CGPoint point = [touch locationInView:self];
    [path addLineToPoint:point];
    [self setNeedsDisplay];
}

- (void)makeRenderImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:ctx];
    cacheImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self makeRenderImage];
    [path removeAllPoints];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self makeRenderImage];
    [path removeAllPoints];
}

@end

@interface OSSCachePlotViewController ()<MYDrawContentViewDrawDelegate>

@end

@implementation OSSCachePlotViewController

- (id)initWithPlotName:(NSString *)_plotName {
    if (self = [super init]) {
        plotName = _plotName;
        cachePlotCtr = [[[[self class] cachePlotCtr] alloc] initWithCacheType:[[self class] cacheType]];
    }
    return self;
}

+ (CacheType)cacheType {
    return CacheType_All;
}

+ (Class)cachePlotCtr {
    return [OSSCachePlotCtr class];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([[self class] cacheType] == CacheType_All) {
        if (!kNeedVirtualData && ![cachePlotCtr hasAnyData]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"本地没有任何数据,是否更新最新数据" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
        }
    }
    else {
        if (kNeedVirtualData) {
            return;
        }
        showStatusView(YES);
        //__block [self class] *ctr = self;
        [cachePlotCtr sendRequestWith:^{
            showPrompt(cachePlotCtr.resultInfo, 1, YES);
            if (cachePlotCtr.result == NetworkBaseResult_Success) {
                [cachePlotCtr saveNetworkDataWithCompleteBlock:^{
                    [cachePlotCtr reloadData];
                    run_async_main(^{
                        dismissStatusView();
                        [self refreshAllView];
                    });
                }];
            }
            else {
                dismissStatusView();
            }
        }];

    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    bgDrawView = [[MYDrawContentView alloc] initWithFrame:CGRectZero];
    [self.view insertSubview:bgDrawView atIndex:0];
    [bgDrawView locationAtSuperView:self.view edgeInsets:UIEdgeInsetsZero];
    bgDrawView.drawDelegate = self;
    
//    UIButton *showGraffitiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    showGraffitiBtn.backgroundColor = [UIColor orangeColor];
//    [showGraffitiBtn addTarget:self action:@selector(showGraffitiAction) forControlEvents:UIControlEventTouchUpInside];
//    showGraffitiBtn.frame = CGRectMake(kScreenHeight - 100, 10, 80, 40);
//    [self.view addSubview:showGraffitiBtn];
    
    [cachePlotCtr reloadData];
}

- (void)showGraffitiAction {
    GraffitiBoardView *graffitiView = [[GraffitiBoardView alloc] initWithFrame:CGRectMake(0, 0, kScreenHeight, kScreenWidth)];
    [self.view addSubview:graffitiView];
    
    UIButton *switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    switchBtn.backgroundColor = [UIColor cyanColor];
    switchBtn.frame = CGRectMake(3, 3, 80, 40);
    [switchBtn addTarget:self action:@selector(switchAciton:) forControlEvents:UIControlEventTouchDown];
    [switchBtn setTitle:@"擦除" forState:UIControlStateSelected];
    [switchBtn setTitle:@"绘图" forState:UIControlStateNormal];
    [graffitiView addSubview:switchBtn];
}

- (void)switchAciton:(UIButton *)sender {
    sender.selected = !sender.selected;
    GraffitiBoardView *view = (GraffitiBoardView *)sender.superview;
    view.isDraw = !sender.selected;
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:NO];
}

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
    
    int offsetTop = 59;
    int offsetLeft = 29;
    
    NSString *dateStr = cachePlotCtr.lastDateStr;
    [dateStr drawAtPoint:CGPointMake(offsetLeft, offsetTop) withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20]}];
}

- (void)contentView:(MYDrawContentView*)view touchBeginAtPoint:(CGPoint)p {
    if (p.y < 44 && p.x < 280) {
        [self backAction];
    }
    else if (cachePlotCtr.cacheType == CacheType_All && p.y > 44 && p.x < 280 && p.y < 100) {
        [self showDatePickView];
    }
}

- (void)showDatePickView {
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        
        showStatusView(YES);
        //__block [self class] *ctr = self;
        [cachePlotCtr sendRequestWith:^{
            showPrompt(cachePlotCtr.resultInfo, 1, YES);
            if (cachePlotCtr.result == NetworkBaseResult_Success) {
                [cachePlotCtr saveNetworkDataWithCompleteBlock:^{
                    [cachePlotCtr reloadData];
                    run_async_main(^{
                        dismissStatusView();
                        [self refreshAllView];
                    });
                }];
            }
            else {
                dismissStatusView();
            }
        }];
    }
}

- (void)refreshAllView {
    [bgDrawView setNeedsDisplay];
}

- (void)changeDateAction:(NSDate *)date {
    if (date == nil) {
        showPrompt(@"您选择的日期不合法,请重新选择", 1, YES);
        return;
    }
    
    NeedOperateType operateType = [cachePlotCtr changeLastDate:date];
    switch (operateType) {
        case NeedOperateType_OverDate:
            showPrompt(@"您选择的日期还没有数据生成", 1, YES);
            break;
            
        case NeedOperateType_Reload:
        {
            [self dismissDatePickView];
            [cachePlotCtr reloadData];
            [self refreshAllView];
        }
            break;
        case NeedOperateType_Update: {
            [self dismissDatePickView];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"该天无本地数据，是否从网络更新？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
        }
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

//
//  HXMapButtonViewController.m
//  tysx
//
//  Created by zwc on 13-11-25.
//  Copyright (c) 2013年 huangjia. All rights reserved.
//

#import "HXMapButtonViewController.h"
#import "HXSegmentedControl.h"
#import "NSString+Draw.h"
#import "HXIrregularButton.h"
#import "MYDrawContentView.h"
#import "MyPlotView.h"
#import "GCD+EXPAND.h"
#import "TYSXProvinceDataCtr.h"
#import "HXDatePickerView.h"

#define kVerticalDrawWidth 255
#define kVerticalDrawHeight 236
#define kHorizonalDrawHeight 135
#define kHorizonalDrawWidth 180

#define kDatePickBgViewTag 2000
#define kDatePickViewTag 2005

#define kOrderColor [UIColor colorWithRed:80/255.0 green:160/255.0 blue:228 / 255.0 alpha:1]
#define kUnColor [UIColor colorWithRed:228/255.0 green:177/255.0 blue:80/255.0 alpha:1]
#define KFlowColor [UIColor colorWithRed:114/255.0 green:234/255.0 blue: 34/ 255.0 alpha:1]

@interface HXMapButtonViewController ()<MYDrawContentViewDrawDelegate, UIAlertViewDelegate, HXSegmentedControlDelegate> {
    NSMutableDictionary *buttonTagAndName;
    int currentButtonTag;
    TYSXProvinceDataCtr *provinceCtr;
    MYDrawContentView *drawView;
    HXSegmentedControl *showTypeControl;
}

@end

@implementation HXMapButtonViewController {
    NSString *plotName;
    NSString *firstTitle;
    NSString *secondTitle;
    NSString *thirdTitle;
}

- (id)initWithPlotName:(NSString *)name
{
    self = [super init];
    if (self) {
        plotName = name;
        provinceCtr = [[TYSXProvinceDataCtr alloc] init];
        
        if (isGuest()) {
            firstTitle = @"GDP";
            secondTitle = @"常住人口";
            thirdTitle = @"人均GDP";
        }
        else {
            firstTitle = @"订购用户请求数";
            secondTitle = @"退订用户请求数";
            thirdTitle = @"数据流量";
        }
        
        buttonTagAndName = [NSMutableDictionary dictionary];
        [buttonTagAndName setValue:@"yunnan" forKey:@"1001"];
        [buttonTagAndName setValue:@"neimenggu" forKey:@"1002"];
        [buttonTagAndName setValue:@"shanxi" forKey:@"1003"];
        [buttonTagAndName setValue:@"sanxi" forKey:@"1004"];
        [buttonTagAndName setValue:@"shanghai" forKey:@"1005"];
        [buttonTagAndName setValue:@"beijing" forKey:@"1006"];
        [buttonTagAndName setValue:@"jilin" forKey:@"1007"];
        [buttonTagAndName setValue:@"sichuan" forKey:@"1008"];
        [buttonTagAndName setValue:@"tianjin" forKey:@"1009"];
        [buttonTagAndName setValue:@"ningxia" forKey:@"1010"];
        [buttonTagAndName setValue:@"anhui" forKey:@"1011"];
        [buttonTagAndName setValue:@"shandong" forKey:@"1012"];
        [buttonTagAndName setValue:@"guangdong" forKey:@"1013"];
        [buttonTagAndName setValue:@"guangxi" forKey:@"1014"];
        [buttonTagAndName setValue:@"xinjiang" forKey:@"1015"];
        [buttonTagAndName setValue:@"jiangsu" forKey:@"1016"];
        [buttonTagAndName setValue:@"jiangxi" forKey:@"1017"];
        [buttonTagAndName setValue:@"hebei" forKey:@"1018"];
        [buttonTagAndName setValue:@"henan" forKey:@"1019"];
        [buttonTagAndName setValue:@"zhejiang" forKey:@"1020"];
        [buttonTagAndName setValue:@"hainan" forKey:@"1021"];
        [buttonTagAndName setValue:@"hubei" forKey:@"1022"];
        [buttonTagAndName setValue:@"hunan" forKey:@"1023"];
        [buttonTagAndName setValue:@"gansu" forKey:@"1024"];
        [buttonTagAndName setValue:@"fujian" forKey:@"1025"];
        [buttonTagAndName setValue:@"xizang" forKey:@"1026"];
        [buttonTagAndName setValue:@"guizhou" forKey:@"1027"];
        [buttonTagAndName setValue:@"liaoning" forKey:@"1028"];
        [buttonTagAndName setValue:@"chongqing" forKey:@"1029"];
        [buttonTagAndName setValue:@"qinghai" forKey:@"1030"];
        [buttonTagAndName setValue:@"heilongjiang" forKey:@"1031"];
        
        currentButtonTag = 1001;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    if (!isGuest() && ![provinceCtr hasAnyData]) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"本地没有任何数据,是否更新最新数据" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        [alertView show];
//    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        showStatusView(YES);
        
        __block UIView *view = drawView;
        __block HXMapButtonViewController *ctr = self;
        __block TYSXProvinceDataCtr *dataCtr = provinceCtr;
        provinceCtr.refreshAction = ^{
            run_async_main(^{
                
                if (dataCtr.updateDataType == UpdateDataType_Day) {
                    [view setNeedsDisplay];
                }
                else if (dataCtr.updateDataType == UpdateDataType_Date) {
                    [ctr showPlotDetailView];
                }
            });
        };
        [provinceCtr sendRequestWith:^{
            dismissStatusView();
            showPrompt(provinceCtr.resultInfo, 1, YES);
        }];
    }
    else {
        provinceCtr.updateDataType = UpdateDataType_Day;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    drawView = [[MYDrawContentView alloc] initWithFrame:CGRectMake(0, 0, kScreenHeight, kScreenWidth)];
    drawView.drawDelegate = self;
    [self.view insertSubview:drawView atIndex:0];
    
    for (HXIrregularButton *button in [self.view subviews]) {
        if ([button isKindOfClass:[HXIrregularButton class]]) {
            [button addTarget:self action:@selector(pressdown:) forControlEvents:UIControlEventTouchDown];
            
            if (button.tag == currentButtonTag) {
                NSString *bgImgName = [buttonTagAndName objectForKey:[NSString stringWithFormat:@"%ld", (long)button.tag]];
                bgImgName = [bgImgName stringByAppendingString:@"_dw.png"];
                [button setBackgroundImage:[UIImage imageNamed:bgImgName] forState:UIControlStateNormal];
            }
            NSString *bgImgName = [buttonTagAndName objectForKey:[NSString stringWithFormat:@"%ld", (long)button.tag]];
            bgImgName = [bgImgName stringByAppendingString:@"_dw.png"];
            [button setBackgroundImage:[UIImage imageNamed:bgImgName] forState:UIControlStateHighlighted];
        }
    }
    
    if (!isGuest()) {
        showTypeControl = [[HXSegmentedControl alloc] initWithItems:@[@"总量", @"自然", @"推广"]];
        showTypeControl.needBorder = YES;
        showTypeControl.itemHeight = 40;
        showTypeControl.itemWidth = 70;
        showTypeControl.delegate = self;
        showTypeControl.selectedColor = [UIColor lightBlueColor];
        showTypeControl.frame = CGRectMake(32, 520, showTypeControl.bounds.size.width, showTypeControl.bounds.size.height);
        [self.view addSubview:showTypeControl];
    }
}

#pragma datepickeview

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
    
    if (datePicker.date == nil) {
        showPrompt(@"您选择的日期不合法,请重新选择", 1, YES);
        return;
    }
    else if ([provinceCtr isOverDate:datePicker.date]) {
        showPrompt(@"您选择的日期还没有数据生成", 1, YES);
        return;
    }
    else {
        [self dismissDatePickView];
    }
    
    if ([datePicker isKindOfClass:[HXDatePickerView class]]) {
        provinceCtr.needUpdateDate = datePicker.date;
        if (provinceCtr.needNetworkData) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"该天无本地数据，是否从网络更新？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alertView show];
        }
        else {
            [provinceCtr reloadProvinceData];
            [drawView setNeedsDisplay];
        }
    }
}


- (IBAction)pressdown:(UIButton *)sender {
    UIButton *selectedButton = (UIButton *)[self.view viewWithTag:currentButtonTag];
    if ([selectedButton isKindOfClass:[HXIrregularButton class]]) {
        selectedButton.userInteractionEnabled = YES;
        NSString *bgImgName = [buttonTagAndName objectForKey:[NSString stringWithFormat:@"%ld", (long)selectedButton.tag]];
        bgImgName = [bgImgName stringByAppendingString:@"_up.png"];
        [selectedButton setBackgroundImage:[UIImage imageNamed:bgImgName] forState:UIControlStateNormal];
    }
    
    NSString *bgImgName = [buttonTagAndName objectForKey:[NSString stringWithFormat:@"%ld", (long)sender.tag]];
    bgImgName = [bgImgName stringByAppendingString:@"_dw.png"];
    currentButtonTag = (int)sender.tag;
    provinceCtr.currentProvinceId = (int)sender.tag;
    [drawView setNeedsDisplay];
    
    [sender setBackgroundImage:[UIImage imageNamed:bgImgName] forState:UIControlStateNormal];
    sender.userInteractionEnabled = NO;
}

//- (void)dismissAction {
//    [self dismissModalViewControllerAnimated:YES];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark MYDrawContentView delegate

- (void)contentView:(MYDrawContentView*)view drawRect:(CGRect)rect {
    int offsetTop = 10;
    int offsetLeft = 29;
    [[UIImage imageNamed:@"logo_lit.png"] drawAtPoint:CGPointMake(offsetLeft, offsetTop)];
    
    [[UIColor grayColor] set];
    [plotName drawAtPoint:CGPointMake(87, 18) withFont:[UIFont systemFontOfSize:18]];
    
    if (!isGuest()) {
        NSString *dateStr = provinceCtr.currentDateStr;
        [dateStr drawAtPoint:CGPointMake(offsetLeft, 50) withFont:[UIFont systemFontOfSize:20]];
    }
    
    offsetTop += 34;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, 0, offsetTop);
    CGContextAddLineToPoint(context, rect.size.width, offsetTop);
    CGContextSetLineWidth(context, 0.7);
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextStrokePath(context);
    
    offsetTop += 3;
    int paddingRight = 5;
    NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:kOrderColor,@"color", firstTitle, @"title", provinceCtr.orderRank, @"content", nil];
    [self drawVerticalInfoWithOriginPoint:CGPointMake(rect.size.width - kVerticalDrawWidth - paddingRight, offsetTop)
                               attributes:attr];
    
    offsetTop += kVerticalDrawHeight + 5;
    attr = [NSDictionary dictionaryWithObjectsAndKeys:kUnColor,@"color", secondTitle, @"title",     provinceCtr.unsubscribeRank, @"content", nil];

    [self drawVerticalInfoWithOriginPoint:CGPointMake(rect.size.width - kVerticalDrawWidth - paddingRight, offsetTop)
                               attributes:attr];
    
    offsetTop += kVerticalDrawHeight + 5;
    attr = [NSDictionary dictionaryWithObjectsAndKeys:KFlowColor,@"color", thirdTitle, @"title",     provinceCtr.flowRank, @"content", nil];

    [self drawVerticalInfoWithOriginPoint:CGPointMake(rect.size.width - kVerticalDrawWidth - paddingRight, offsetTop)
                               attributes:attr];
    
    
    offsetTop = kScreenWidth - kHorizonalDrawHeight;
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1].CGColor);
    CGContextFillRect(context, CGRectMake(0, offsetTop, kScreenHeight - kVerticalDrawWidth - 5 * 2, kHorizonalDrawHeight));
    
    offsetLeft = 5;
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1].CGColor);
    CGContextFillRect(context, CGRectMake(offsetLeft, kScreenWidth - kHorizonalDrawHeight, 195, kHorizonalDrawHeight));
    
    [[UIColor whiteColor] set];
    [provinceCtr.currentProvinceName drawCenterInRect:CGRectMake(offsetLeft, offsetTop + 48, 195, 40) withFont:[UIFont systemFontOfSize:32]];
    
    attr = [NSDictionary dictionaryWithObjectsAndKeys:kOrderColor ,@"color", firstTitle, @"title",     provinceCtr.currentOrderValue, @"number", nil];
    offsetLeft += 3 + 195;
    [self drawHorizonalInfoWithOriginPoint:CGPointMake(offsetLeft, offsetTop)
                                attributes:attr];
    
    offsetLeft += 3 + kHorizonalDrawWidth;
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1].CGColor);
    CGContextMoveToPoint(context, offsetLeft, offsetTop);
    CGContextAddLineToPoint(context, offsetLeft, offsetTop + kHorizonalDrawHeight);
    CGContextStrokePath(context);
    
    offsetLeft += 3;
    attr = [NSDictionary dictionaryWithObjectsAndKeys:kUnColor,@"color", secondTitle, @"title",    provinceCtr.currentUnsubscribeValue, @"number", nil];
    [self drawHorizonalInfoWithOriginPoint:CGPointMake(offsetLeft, offsetTop)
                                attributes:attr];
    
    offsetLeft += 3 + kHorizonalDrawWidth;
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1].CGColor);
    CGContextMoveToPoint(context, offsetLeft, offsetTop);
    CGContextAddLineToPoint(context, offsetLeft, offsetTop + kHorizonalDrawHeight);
    CGContextStrokePath(context);
    
    offsetLeft += 3;
    attr = [NSDictionary dictionaryWithObjectsAndKeys:KFlowColor,@"color", thirdTitle, @"title", provinceCtr.currentFlowValue, @"number",@"ddd", @"flow", nil];
    [self drawHorizonalInfoWithOriginPoint:CGPointMake(offsetLeft, offsetTop)
                                attributes:attr];
    
}

- (void)contentView:(MYDrawContentView*)view touchBeginAtPoint:(CGPoint)p {
    if (p.y < 44 && p.x < 280) {
        [self backMenuView];
        //[self dismissModalViewControllerAnimated:YES];
    }
    else if (!isGuest() && p.y > 44 && p.x < 280 && p.y < 100) {
        [self showDatePickView];
    }
    
    else if (!isGuest() && CGRectContainsPoint(CGRectMake(5, kScreenWidth - kHorizonalDrawHeight, 195, kHorizonalDrawHeight), p)) {
        
        provinceCtr.updateDataType = UpdateDataType_Date;
        if ([provinceCtr needNetworkData]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"该天无本地数据，是否从网络更新？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
        }
        else {
            [provinceCtr reloadProvinceData];
            [self showPlotDetailView];
        }
    }
}

- (void)drawHorizonalInfoWithOriginPoint:(CGPoint)originPoint
                              attributes:(NSDictionary *)attr {
    
    UIColor *color = [attr objectForKey:@"color"];
    NSString *title = [attr objectForKey:@"title"];
    NSNumber *number = [attr objectForKey: @"number"];
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSaveGState(contextRef);
    CGContextSetFillColorWithColor(contextRef, color.CGColor);
    CGContextFillRect(contextRef, CGRectMake(originPoint.x, originPoint.y + 2, kHorizonalDrawWidth, 54));
    CGContextRestoreGState(contextRef);
    
    [[UIColor darkGrayColor] set];
    [title drawCenterInRect:CGRectMake(originPoint.x, originPoint.y + 15, kHorizonalDrawWidth, 30) withFont:[UIFont systemFontOfSize:22]];
    
    NSString *tempStr = nil;
    if (isGuest()) {
        if ([title isEqualToString:@"GDP"]) {
            tempStr = [NSString stringWithFormat:@"%.2f亿元",[number doubleValue]];
        }
        else if ([title isEqualToString:@"常住人口"]) {
            tempStr = [NSString stringWithFormat:@"%.2f万",[number doubleValue]];
        }
        else {
            tempStr = [NSString stringWithFormat:@"%.2f元",[number doubleValue]];
        }
    }
    else {
        if ([attr objectForKey:@"flow"]) {
            tempStr = [NSString stringWithFormat:@"%.1fGB", [number longLongValue] * 1.0/ 1024 / 1024];
        }
        else {
            tempStr = [NSString stringWithFormat:@"%lld次", [number longLongValue]];
        }
    }
    [tempStr drawCenterInRect:CGRectMake(originPoint.x, originPoint.y + 75, kHorizonalDrawWidth, 30) withFont:[UIFont systemFontOfSize:22]];
}

- (void)drawVerticalInfoWithOriginPoint:(CGPoint)originPoint
                             attributes:(NSDictionary *)attr{
    UIColor *color = [attr objectForKey:@"color"];
    NSString *title = [attr objectForKey:@"title"];
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSaveGState(contextRef);
    CGContextSetFillColorWithColor(contextRef, color.CGColor);
    CGContextFillRect(contextRef, CGRectMake(originPoint.x, originPoint.y, kVerticalDrawWidth, kVerticalDrawHeight));
    
    CGContextSetFillColorWithColor(contextRef, [[UIColor whiteColor] colorWithAlphaComponent:0.2].CGColor);
    CGContextFillRect(contextRef, CGRectMake(originPoint.x, originPoint.y, 47, kVerticalDrawHeight));
    
    [[UIColor darkGrayColor] set];
    CGFloat leftStrHeight = [title sizeWithFont:[UIFont systemFontOfSize:23] constrainedToSize:CGSizeMake(25, 768)].height + 3;
    [title drawInRect:CGRectMake(originPoint.x + 11, originPoint.y + (kVerticalDrawHeight - leftStrHeight) / 2, 25, leftStrHeight) withFont:[UIFont systemFontOfSize:23]];
    
    [[UIColor whiteColor] set];
    int offsetTop = 20;
    int offsetLeft = 60;
    
    NSArray *content = [attr objectForKey:@"content"];
    //NSArray *fonts = [NSArray arrayWithObjects:[UIFont systemFontOfSize:29], [UIFont systemFontOfSize:26], [UIFont systemFontOfSize:23], [UIFont systemFontOfSize:21], [UIFont systemFontOfSize:19], nil];
    
    for (int i = 0; i < [content count]; i++) {
        [[[content objectAtIndex:i] objectForKey:@"province"] drawCenterInRect:CGRectMake(originPoint.x + offsetLeft,
                                                             originPoint.y + offsetTop, 80, 30) withFont:[UIFont systemFontOfSize:21]];
        
        if (isGuest()) {
            NSString *tempStr = nil;
            NSNumber *drawNumber = [[content objectAtIndex:i] objectForKey:@"volume"];
            if ([title isEqualToString:@"GDP"]) {
                tempStr = [NSString stringWithFormat:@"%.2f亿元",[drawNumber doubleValue]];
            }
            else if ([title isEqualToString:@"常住人口"]) {
                tempStr = [NSString stringWithFormat:@"%.2f万",[drawNumber doubleValue]];
            }
            else {
                tempStr = [NSString stringWithFormat:@"%.2f元",[drawNumber doubleValue]];
            }
            [tempStr drawCenterInRect:CGRectMake(133 + originPoint.x,
                                                                                                            originPoint.y + offsetTop, 124, 30) withFont:[UIFont systemFontOfSize:21]];
        }
        else {
            long long value = [[[content objectAtIndex:i] objectForKey:@"volume"] longLongValue];
            if (value >= 10000000) {
                [[NSString stringWithFormat:@"%.1fGB", (value * 1.0 / 1024 / 1024)] drawCenterInRect:CGRectMake(133 + originPoint.x,
                                                                                                                originPoint.y + offsetTop, 124, 30) withFont:[UIFont systemFontOfSize:21]];
            }
            else {
                [[NSString stringWithFormat:@"%lld次", value] drawCenterInRect:CGRectMake(133 + originPoint.x,
                                                                                         originPoint.y + offsetTop, 124, 30) withFont:[UIFont systemFontOfSize:21]];
            }
        }
        offsetTop += 42;
    }
    
    CGContextRestoreGState(contextRef);
}

- (void)showPlotDetailView {
    
    UIView *plotViewBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenHeight, kScreenWidth)];
    
    UIControl *control = [[UIControl alloc] initWithFrame:plotViewBgView.bounds];
    control.backgroundColor = [UIColor blackColor];
    control.alpha = 0.3;
    [plotViewBgView addSubview:control];
    [control addTarget:self action:@selector(controlAction:) forControlEvents:UIControlEventTouchUpInside];
    
    MyPlotView *plotView = [[MyPlotView alloc] initWithFrame:CGRectMake(0, 0, kScreenHeight, 700)];
    plotView.backgroundColor = [UIColor whiteColor];
    plotView.paddingLeft = 100;
    plotView.paddingRight = 70;
    plotView.paddingTop = 80;
    plotView.paddingBottom = 100;
    plotView.center = plotViewBgView.center;
    
    HXSegmentedControl *segmentedControl = [[HXSegmentedControl alloc] initWithItems:@[@"订购请求", @"退订请求", @"流量"]];
    segmentedControl.needBorder = YES;
    segmentedControl.itemWidth = 130;
    segmentedControl.itemHeight = 40;
    segmentedControl.delegate = self;
    segmentedControl.currentIndex = provinceCtr.currentTypeId;
    segmentedControl.font = [UIFont systemFontOfSize:18];
    segmentedControl.selectedColor = [UIColor lightBlueColor];
    segmentedControl.frame = CGRectMake((plotView.bounds.size.width - segmentedControl.bounds.size.width) / 2, plotView.bounds.size.height - segmentedControl.bounds.size.height - 20, segmentedControl.bounds.size.width, segmentedControl.bounds.size.height);
    [plotView addSubview:segmentedControl];
    
    [self updatePlotView:plotView];
    
    [plotViewBgView addSubview:plotView];
    
    [self.view addSubview:plotViewBgView];
}

- (void)updatePlotView:(MyPlotView *)plotView {
    plotView.horizonalTitles = provinceCtr.dateList;
    plotView.showHorizonalTitles = @[[provinceCtr.dateList firstObject], [provinceCtr.dateList lastObject]];
    
    plotView.fillColor = [UIColor blueColor];
    plotView.gradientColor = [UIColor lightBlueColor];
    plotView.minVerticalValue = provinceCtr.minValue;
    plotView.maxVerticalValue = provinceCtr.maxValue;
    
    NSArray *valueList = nil;
    
    switch (provinceCtr.currentTypeId) {
        case 0:
            valueList = provinceCtr.orderValueList;
            plotView.fillColor = [UIColor colorWithRed:0 green:60/255.0 blue:1 alpha:1];
            plotView.gradientColor = [UIColor colorWithRed:153/255.0 green:177/255.0 blue:1 alpha:1];
            plotView.needChangeBigUnit = NO;
            plotView.unitStr = @"次";
            break;
        case 1:
            valueList = provinceCtr.unsubscribeValueList;
            plotView.fillColor = [UIColor colorWithRed:1 green:98/255.0 blue:0 alpha:1];
            plotView.gradientColor = [UIColor colorWithRed:1 green:192/255.0 blue:153/255.0 alpha:1];
            plotView.needChangeBigUnit = NO;
            plotView.unitStr = @"次";
            break;
        case 2:
            valueList = provinceCtr.flowValueList;
            plotView.fillColor = [UIColor colorWithRed:144/255.0 green:1 blue:0 alpha:1];
            plotView.gradientColor = [UIColor colorWithRed:211/255.0 green:1 blue:153/255.0 alpha:1];
            plotView.needChangeBigUnit = YES;
            plotView.unitStr = @"GB";
            break;
        default:
            break;
    }
        plotView.values = valueList;
    [plotView setNeedsDisplay];
}

- (void)segmentedControlValueChanged:(HXSegmentedControl *)control {
    if ([control isEqual:showTypeControl]) {
        provinceCtr.showDataType = showTypeControl.currentIndex;
        [provinceCtr reloadProvinceData];
        [drawView setNeedsDisplay];
    }
    else {
        MyPlotView *plotView = (MyPlotView *)control.superview;
        if ([plotView isKindOfClass:[MyPlotView class]]) {
            provinceCtr.currentTypeId = control.currentIndex;
            [self updatePlotView:plotView];
        }
    }
}

- (void)controlAction:(UIControl *)control {
    provinceCtr.updateDataType = UpdateDataType_Day;
    [control.superview removeFromSuperview];
}

@end

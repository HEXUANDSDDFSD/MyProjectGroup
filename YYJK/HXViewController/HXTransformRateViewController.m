//
//  HXTransformRateViewController.m
//  tysx
//
//  Created by zwc on 14-7-6.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "HXTransformRateViewController.h"
#import "NSArray+Category.h"
#import "MYDrawContentView.h"
#import "HXTurntableControl.h"
#import "HXCorePlotControl.h"
#import "TYSXTransformRateCtr.h"
#import "HXHeapBarPlot.h"
#import "HXLinePlot.h"
#import "MyPlotView.h"
#import <AudioToolbox/AudioToolbox.h>

#define kDatePickBgViewTag 2000
#define kDatePickViewTag 2005

#define kAllColor [UIColor cyanColor]
#define kNaturalColor [UIColor colorWithRed:15/255.0 green:98/255.0 blue:146/255.0 alpha:1.0]
#define kExtendColor [UIColor colorWithRed:208/255.0 green:100/255.0 blue:21/255.0 alpha:1.0]

@interface HXTransformRateViewController ()<UIPickerViewDataSource, UIPickerViewDelegate, HXTurntableControlDelegate, HXCorePlotYAxisDataSource,HXHeapBarPlotDataSource, HXBaseDataSource, HXPlotCursorDataSource, HXCoreplotXAxisDataSource, UIPickerViewDataSource, UIPickerViewDelegate>

@end

@implementation HXTransformRateViewController {
    TYSXTransformRateCtr *transformCtr;
    MyPlotView *plotView;
    HXTurntableControl *turntableControl;
    HXCorePlotControl *plotControl;
    UIPickerView *platPickView;
}

- (id)initWithPlotName:(NSString *)name
{
    self = [super initWithPlotName:name];
    if (self) {
        transformCtr = [[TYSXTransformRateCtr alloc] init];
        [transformCtr reloadData];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    plotControl = [[HXCorePlotControl alloc] initWithFrame:CGRectMake(0, 80, kScreenHeight - 90, kScreenWidth - 80)];
    plotControl.yAxis.dataSource = self;
    plotControl.xAxis.dataSource = self;
    plotControl.xAxis.offsetLeft = 20;
    plotControl.xAxis.offsetRight = 20;
    plotControl.layerManager.paddingLeft = 100;
    plotControl.layerManager.paddingTop = 100;
    plotControl.layerManager.paddingRight = 100;
    plotControl.layerManager.paddingBottom = 80;
    plotControl.layerManager.insetLeft = 20;
   plotControl.layerManager.insetRight = 20;
    plotControl.layerManager.maxValue = [[transformCtr.allData maxValue] floatValue] * 1.2;
    
    
    plotControl.yAxis.needLegend = YES;
    plotControl.yAxis.legendColor = @[kAllColor, kNaturalColor, kExtendColor];
    plotControl.yAxis.legendTitles = @[@"总量",@"自然", @"推广"];
    
    [self.view addSubview:plotControl];
    
//    HXHeapBarPlot *heapBarPlot = [HXHeapBarPlot layer];
//    heapBarPlot.dataSource = self;
//    [plotControl addPlot:heapBarPlot];
    
    HXLinePlot *allPlot = [HXLinePlot layer];
    allPlot.lineColor = [UIColor cyanColor];
    allPlot.plotName = @"all";
    allPlot.dataSource = self;
    allPlot.lineWidth = 2;
    [plotControl addPlot:allPlot];
    
    HXLinePlot *naturePlot = [HXLinePlot layer];
    naturePlot.lineColor = [UIColor colorWithRed:15/255.0 green:98/255.0 blue:146/255.0 alpha:1.0];
    naturePlot.dataSource = self;
    naturePlot.plotName = @"natural";
    naturePlot.lineWidth = 2;
    [plotControl addPlot:naturePlot];
    
    HXLinePlot *extendPlot = [HXLinePlot layer];
    extendPlot.lineColor = [UIColor colorWithRed:208/255.0 green:100/255.0 blue:21/255.0 alpha:1.0];
    extendPlot.plotName = @"extend";
    extendPlot.lineWidth = 2;
    extendPlot.dataSource = self;
    [plotControl addPlot:extendPlot];
//
//    HXLinePlot *linePlot = [HXLinePlot layer];
//    linePlot.dataSource = self;
//    linePlot.lineWidth = 3;
//    linePlot.lineColor = [UIColor greenColor];
//    [plotControl addPlot:linePlot];
    
    plotControl.needCursor = YES;
    plotControl.cursor.dataSource = self;
    plotControl.cursor.textFont = [UIFont systemFontOfSize:16];
    
    platPickView = [[UIPickerView alloc] initWithFrame:CGRectMake(plotControl.frame.origin.x + plotControl.bounds.size.width - 60, 200, kScreenHeight - plotControl.bounds.size.width + 20, 100)];
    platPickView.layer.cornerRadius = 10;
    platPickView.layer.shadowOffset = CGSizeMake(2, 2);
    platPickView.layer.shadowColor = [UIColor grayColor].CGColor;
    platPickView.layer.shadowOpacity = 1;
    platPickView.delegate = self;
    platPickView.backgroundColor = [UIColor grayColor];
    platPickView.dataSource = self;
    [self.view addSubview:platPickView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (![transformCtr hasAnyData]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"本地没有任何数据,是否更新最新数据" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

- (void)refreshView {
    plotControl.layerManager.maxValue = [[transformCtr.allData maxValue] floatValue] * 1.2;
    [drawView setNeedsDisplay];
    [plotControl reloadData];
}

- (void)contentView:(MYDrawContentView *)view drawRect:(CGRect)rect {
    [super contentView:view drawRect:rect];
    
    UIFont *font = [UIFont systemFontOfSize:18];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    UIColor *fontColor = [UIColor grayColor];
    
    NSDictionary *attributes = @{NSParagraphStyleAttributeName : paragraphStyle,
                                 NSFontAttributeName : font,
                                 NSForegroundColorAttributeName : fontColor
                                 };
    
    [@"客户端选择" drawInRect:CGRectMake(platPickView.frame.origin.x, platPickView.frame.origin.y - font.pointSize - 8, platPickView.bounds.size.width, font.pointSize + 2) withAttributes:attributes];
}

- (NSString *)lastDateStr {
    NSLog(@"%@", transformCtr.lastDateStr);
    return transformCtr.lastDateStr;
}

- (void)changeDateAction:(NSDate *)date {
    if (date == nil) {
        showPrompt(@"您选择的日期不合法,请重新选择", 1, YES);
        return;
    }
    
    NeedOperateType operateType = [transformCtr updateLastDate:date];
    switch (operateType) {
        case NeedOperateType_OverDate:
            showPrompt(@"您选择的日期还没有数据生成", 1, YES);
            break;
            
        case NeedOperateType_Reload:
        {
            [self dismissDatePickView];
            [transformCtr reloadData];
            [self refreshView];
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

#pragma mark core plot dataSource

- (NSInteger)numberOfTitleInXAxis:(HXCoreplotXAxisLayer *)xAxis {
    return 6;
}

- (NSString *)xAxis:(HXCoreplotXAxisLayer *)xAxis titleAtIndex:(NSInteger)index {
    return transformCtr.allDateStrs[6 * index];
}

- (NSInteger)numberOfTitleInYAxis:(HXCorePlotYAxisLayer *)yAxis {
    return 5;
}


- (NSString *)yAxis:(HXCorePlotYAxisLayer *)yAxis titleAtIndex:(NSInteger)index isUseRightYAxis:(BOOL)isUseRight {
    CGFloat maxValue = [[transformCtr.allData maxValue] floatValue] * 1.2;
    CGFloat everyInterval = maxValue / (5 - 1);
    CGFloat currentValue = maxValue - everyInterval * index;
    NSString *ret = nil;
    if (currentValue == 0) {
        ret = @"0";
    }
    else {
        ret = [NSString stringWithFormat:@"%.3f%%", currentValue * 100];
    }
    
    return ret;
}

- (NSInteger)numberOfXValuesInHeapBarPlot:(HXHeapBarPlot *)heapBarPlot {
    return [transformCtr.allData count];
}

- (NSInteger)numberOfPlot:(HXBasePlot *)plot {
    return 31;
}

- (NSNumber *)plot:(HXBasePlot *)plot index:(NSInteger)index {
    NSArray *data = nil;
    if ([plot.plotName isEqualToString:@"all"]) {
        data = transformCtr.allData;
    }else if ([plot.plotName isEqualToString:@"natural"]) {
        data = transformCtr.natureData;
    }
    else if ([plot.plotName isEqualToString:@"extend"]) {
        data = transformCtr.extendData;
    }
    return data[index];
}

- (NSInteger)numberOfHeapBarInHeapBarPlot:(HXHeapBarPlot *)heapBarPlot {
    return 2;
}

- (NSNumber *)heapBarPlot:(HXHeapBarPlot *)heapBarPlot valueOfXIndex:(NSInteger)xIndex heapIndex:(NSInteger)heapIndex {
    NSNumber  *ret = nil;
    switch (heapIndex) {
        case 0:
            ret = transformCtr.natureData[xIndex];
            break;
        case 1:
            ret = transformCtr.extendData[xIndex];
            break;
        default:
            break;
    }
    return ret;
}

- (UIColor *)heapBarPlot:(HXHeapBarPlot *)heapBarPlot colorOfHeapIndex:(NSInteger)heapIndex {
    UIColor  *ret = nil;
    switch (heapIndex) {
        case 0:
            ret = kAllColor;
            break;
        case 1:
            ret = kNaturalColor;
            break;
        case 2:
            ret = kExtendColor;
            break;
        default:
            break;
    }
    return ret;
}

- (NSInteger)numberOfComponentInCursor:(HXPlotCursor *)plotCursor {
    return 3;
}

- (NSInteger)numberOfDegreeInCursor:(HXPlotCursor *)plotCursor {
    return 31;
}

- (NSString *)plotCursor:(HXPlotCursor *)plotCursor degreeNameOfIndex:(NSInteger)index {
    NSString *oriDateStr = transformCtr.allDateStrs[index];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    NSString *monthStr = [NSString stringWithFormat:@"%ld", (long)[[oriDateStr substringWithRange:range] integerValue]];
    
    range.location = 3;
    range.length = 2;
    
    NSString *dayStr = [NSString stringWithFormat:@"%ld", (long)[[oriDateStr substringWithRange:range] integerValue]];
    
    return [NSString stringWithFormat:@"%@月%@日", monthStr, dayStr];
}

- (NSString *)plotCursor:(HXPlotCursor *)plotCursor textOfIndex:(NSInteger)index component:(NSInteger)component {
    NSString *ret = nil;
    switch (component) {
        case 0:
            ret = [NSString stringWithFormat:@"总量：%.2f%%", [transformCtr.allData[index] floatValue] * 100];
            break;
        case 1:
            ret = [NSString stringWithFormat:@"自然：%.2f%%", [transformCtr.natureData[index] floatValue] * 100];
            break;
        case 2:
            ret = [NSString stringWithFormat:@"推广：%.2f%%", [transformCtr.extendData[index] floatValue] * 100];
            break;
            
        default:
            break;
    }
    return ret;
}

- (UIColor *)plotCursor:(HXPlotCursor *)plotCursor textColorOfComponent:(NSInteger)component {
    UIColor *ret = nil;
    switch (component) {
        case 0:
            ret = kAllColor;
            break;
        case 1:
            ret = kNaturalColor;
            break;
        case 2:
            ret = kExtendColor;
            break;
        default:
            break;
    }
    return ret;
}

#pragma mark 

- (void)turntableControlDidChangeIndex:(HXTurntableControl *)control {
    [drawView setNeedsDisplay];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = (UILabel *)view;
    if (label == nil) {
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
    }
    
    label.text = transformCtr.platNameList[row];
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    transformCtr.currentPlatIndex = row;
    [self refreshView];
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [transformCtr.platNameList count];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        
        showStatusView(YES);
        
        __block HXTransformRateViewController *ctr = self;
        [transformCtr sendRequestWith:^{
            showPrompt(transformCtr.resultInfo, 1, YES);
            if (transformCtr.result == NetworkBaseResult_Success) {
                [transformCtr saveNetworkDataWithCompleteBlock:^{
                    [transformCtr reloadData];
                    run_async_main(^{
                        dismissStatusView();
                        [ctr refreshView];
                    });
                }];
            }
            else {
                dismissStatusView();
            }
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

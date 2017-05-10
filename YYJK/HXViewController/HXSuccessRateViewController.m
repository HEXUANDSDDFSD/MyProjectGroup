//
//  HXSuccessRateViewController.m
//  tysx
//
//  Created by zwc on 14-8-6.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "HXSuccessRateViewController.h"
#import "NSArray+Category.h"
#import "TYSXSuccessRateCtr.h"
#import "HXCorePlot.h"

@interface HXSuccessRateViewController()<HXCorePlotYAxisDataSource, HXHeapBarPlotDataSource, HXBaseDataSource, HXCoreplotXAxisDataSource, HXPlotCursorDataSource>

@end

@implementation HXSuccessRateViewController {
    TYSXSuccessRateCtr *successRateCtr;
    HXCorePlotControl *corePlot;
}

- (id)initWithPlotName:(NSString *)name {
    if (self = [super initWithPlotName:name]) {
        successRateCtr = [[TYSXSuccessRateCtr alloc] init];
        [successRateCtr reloadData];
    }
    return self;
}

- (NSString *)lastDateStr {
    return successRateCtr.lastDateStr;
}

- (void)changeDateAction:(NSDate *)date {
    if (date == nil) {
        showPrompt(@"您选择的日期不合法,请重新选择", 1, YES);
        return;
    }
    
    NeedOperateType operateType = [successRateCtr updateLastDate:date];
    switch (operateType) {
        case NeedOperateType_OverDate:
            showPrompt(@"您选择的日期还没有数据生成", 1, YES);
            break;
            
        case NeedOperateType_Reload:
        {
            [self dismissDatePickView];
            [successRateCtr reloadData];
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

- (void)refreshView {
    corePlot.layerManager.maxValue = [[successRateCtr.allData maxValue] longLongValue] * 1.2;
    corePlot.layerManager.rightMaxValue = 1.0;
    [corePlot reloadData];
    [drawView setNeedsDisplay];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat offsetTop = 100;
    CGFloat offsetX = 30;
    
    corePlot = [[HXCorePlotControl alloc] initWithFrame:CGRectMake(offsetX, offsetTop, kScreenHeight - 2 * offsetX, kScreenWidth - offsetTop)];
    corePlot.layerManager.paddingTop = 100;
    corePlot.layerManager.paddingLeft = 40;
    corePlot.layerManager.paddingRight = 60;
    corePlot.layerManager.paddingBottom = 100;
    corePlot.layerManager.insetLeft = 20;
    corePlot.layerManager.insetRight = 20;
    
    corePlot.yAxis.dataSource = self;
    corePlot.yAxis.needRightYAxis = YES;
    corePlot.xAxis.dataSource = self;
   // corePlot.xAxis.contentWidthScale = 2;
    
    corePlot.yAxis.needLegend = YES;
    corePlot.yAxis.legendColor = @[[UIColor blueColor], [UIColor orangeColor], [UIColor greenColor]];
    corePlot.yAxis.legendTitles = @[@"成功", @"失败", @"成功率"];
    
    HXHeapBarPlot *heapBar = [HXHeapBarPlot layer];
    //heapBar.endPosition = 0.9;
    heapBar.dataSource = self;
    [corePlot addPlot:heapBar];
    
    HXLinePlot *linePlot = [HXLinePlot layer];
    linePlot.lineWidth = 2;
    linePlot.isUseRightAxisY = YES;
    linePlot.dataSource = self;
    linePlot.lineColor = [UIColor greenColor];
    [corePlot addPlot:linePlot];
    
    corePlot.needCursor = YES;
    corePlot.cursor.textFont = [UIFont systemFontOfSize:16];
    corePlot.cursor.dataSource = self;
    
    [self.view addSubview:corePlot];
    [self refreshView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (![successRateCtr hasAnyData]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"本地没有任何数据,是否更新最新数据" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

- (NSInteger)numberOfTitleInXAxis:(HXCoreplotXAxisLayer *)xAxis {
    return 6;
}

- (NSString *)xAxis:(HXCoreplotXAxisLayer *)xAxis titleAtIndex:(NSInteger)index {
    return successRateCtr.dateList[index * 6];
}

- (NSInteger)numberOfTitleInYAxis:(HXCorePlotYAxisLayer *)yAxis {
    return 5;
}

- (NSString *)yAxis:(HXCorePlotYAxisLayer *)yAxis titleAtIndex:(NSInteger)index isUseRightYAxis:(BOOL)isUseRight {
    if (isUseRight) {
        return [NSString stringWithFormat:@"%.2f%%", 1.0 * 100 * (4 - index) / 4];
    }
    else {
        return [NSString stringWithFormat:@"%.0f", corePlot.layerManager.maxValue * (4 - index) / 4];
    }
}

- (NSInteger)numberOfXValuesInHeapBarPlot:(HXHeapBarPlot *)heapBarPlot {
    return 31;
}

- (NSInteger)numberOfHeapBarInHeapBarPlot:(HXHeapBarPlot *)heapBarPlot {
    return 2;
}

- (NSNumber *)heapBarPlot:(HXHeapBarPlot *)heapBarPlot valueOfXIndex:(NSInteger)xIndex heapIndex:(NSInteger)heapIndex {
    NSArray *ret = nil;
    switch (heapIndex) {
        case 0:
            ret = successRateCtr.successData;
            break;
        case 1:
            ret = successRateCtr.failureData;
            break;
        default:
            break;
    }
    return ret[xIndex];
}

- (UIColor *)heapBarPlot:(HXHeapBarPlot *)heapBarPlot colorOfHeapIndex:(NSInteger)heapIndex {
    switch (heapIndex) {
        case 0:
            return [UIColor blueColor];
            break;
        case 1:
            return [UIColor orangeColor];
            break;
        default:
            break;
    }
    return nil;
}

- (NSInteger)numberOfPlot:(HXBasePlot *)plot {
    return 31;
}

- (NSNumber *)plot:(HXBasePlot *)plot index:(NSInteger)index {
    return successRateCtr.successRateData[index];
}

- (NSString *)plotCursor:(HXPlotCursor *)plotCursor degreeNameOfIndex:(NSInteger)index {
    return successRateCtr.dateList[index];
}

- (NSInteger)numberOfDegreeInCursor:(HXPlotCursor *)plotCursor {
    return [successRateCtr.dateList count];
}

// only use when cursorType is CursorType_Single

- (NSInteger)numberOfComponentInCursor:(HXPlotCursor *)plotCursor {
    return 3;
}

- (NSString *)plotCursor:(HXPlotCursor *)plotCursor textOfIndex:(NSInteger)index component:(NSInteger)component {
    NSString *ret = nil;
    switch (component) {
        case 0:
            ret = [NSString stringWithFormat:@"成功数：%lld", [successRateCtr.successData[index] longLongValue]];
            break;
        case 1:
            ret = [NSString stringWithFormat:@"失败数：%lld", [successRateCtr.failureData[index] longLongValue]];
            break;
        case 2:
            ret = [NSString stringWithFormat:@"成功数：%.2f%%", [successRateCtr.successRateData[index] floatValue] * 100];
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
            ret = [UIColor blueColor];
            break;
        case 1:
            ret = [UIColor orangeColor];
            break;
        case 2:
            ret = [UIColor greenColor];
            break;
            
        default:
            break;
    }
    return ret;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        
        showStatusView(YES);
        
        __block HXSuccessRateViewController *ctr = self;
        [successRateCtr sendRequestWith:^{
            showPrompt(successRateCtr.resultInfo, 1, YES);
            if (successRateCtr.result == NetworkBaseResult_Success) {
                [successRateCtr saveNetworkDataWithCompleteBlock:^{
                    [successRateCtr reloadData];
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

@end

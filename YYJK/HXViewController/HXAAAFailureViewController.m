//
//  HXAAAFailureViewController.m
//  tysx
//
//  Created by zwc on 14-9-5.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "HXAAAFailureViewController.h"
#import "NSArray+Category.h"
#import "TYSXSuccessRateCtr.h"
#import "HXCorePlot.h"

@interface HXAAAFailureViewController ()<HXCoreplotXAxisDataSource, HXCorePlotYAxisDataSource, HXBaseDataSource, HXHeapBarPlotDataSource, HXPlotCursorDataSource>

@end

@implementation HXAAAFailureViewController {
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
    corePlot.layerManager.maxValue = [[successRateCtr.aaaFailureData maxValue] longLongValue] * 1.2;
    [corePlot reloadData];
    [drawView setNeedsDisplay];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat offsetTop = 100;
    CGFloat offsetX = 30;
    
    corePlot = [[HXCorePlotControl alloc] initWithFrame:CGRectMake(offsetX, offsetTop, kScreenHeight - 2 * offsetX, kScreenWidth - offsetTop)];
    corePlot.layerManager.paddingTop = 80;
    corePlot.layerManager.paddingLeft = 60;
    corePlot.layerManager.paddingRight = 60;
    corePlot.layerManager.paddingBottom = 100;
   corePlot.layerManager.insetLeft = 20;
    corePlot.layerManager.insetRight = 20;
    corePlot.needCursor = YES;
    corePlot.cursor.dataSource = self;
    corePlot.cursor.textFont = [UIFont systemFontOfSize:20];
    corePlot.yAxis.dataSource = self;
    corePlot.xAxis.dataSource = self;
    
    corePlot.yAxis.needLegend = YES;
    corePlot.yAxis.legendColor = @[[UIColor greenColor]];
    corePlot.yAxis.legendTitles = @[@"三A鉴权失败数"];
    
    HXHeapBarPlot *heapBarPlot = [HXHeapBarPlot layer];
    heapBarPlot.dataSource = self;
    [corePlot addPlot:heapBarPlot];
    
    HXLinePlot *linePlot = [HXLinePlot layer];
    linePlot.lineWidth = 2;
    linePlot.dataSource = self;
    linePlot.lineColor = [UIColor greenColor];
   // [corePlot addPlot:linePlot];
    
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
    return 1;
}

- (NSNumber *)heapBarPlot:(HXHeapBarPlot *)heapBarPlot valueOfXIndex:(NSInteger)xIndex heapIndex:(NSInteger)heapIndex {
    NSArray *ret = nil;
    switch (heapIndex) {
        case 0:
            ret = successRateCtr.aaaFailureData;
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
            return [UIColor greenColor];
            break;
        case 1:
            return [UIColor yellowColor];
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
    return successRateCtr.aaaFailureData[index];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        
        showStatusView(YES);
        
        __block HXAAAFailureViewController *ctr = self;
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

- (NSString *)plotCursor:(HXPlotCursor *)plotCursor degreeNameOfIndex:(NSInteger)index {
    return successRateCtr.dateList[index];
}

- (NSInteger)numberOfDegreeInCursor:(HXPlotCursor *)plotCursor {
    return [successRateCtr.dateList count];
}

- (NSInteger)numberOfComponentInCursor:(HXPlotCursor *)plotCursor {
    return 1;
}

- (NSString *)plotCursor:(HXPlotCursor *)plotCursor textOfIndex:(NSInteger)index component:(NSInteger)component {
    return [NSString stringWithFormat:@"%lld", [successRateCtr.aaaFailureData[index] longLongValue]];
}

- (UIColor *)plotCursor:(HXPlotCursor *)plotCursor textColorOfComponent:(NSInteger)component {
    return [UIColor greenColor];
}

@end

//
//  HXPlatformDataViewController.m
//  tysx
//
//  Created by zwc on 14-7-28.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "HXPlatformDataViewController.h"
#import "NSArray+Category.h"
#import "HXCorePlotControl.h"
#import "TYSXPlatformCtr.h"
#import "HXLinePlot.h"
#import "HXHeapBarPlot.h"

#define kAccessColor [UIColor colorWithRed:141/255.0 green:165/255.0 blue:59/255.0 alpha:1.0]
#define kLoginColor [UIColor colorWithRed:176/255.0 green:118/255.0 blue:35/255.0 alpha:1.0]
#define kPlayBackColor [UIColor colorWithRed:30/255.0 green:148/255.0 blue:155/255.0 alpha:1.0]

@interface HXPlatformDataViewController ()<HXCorePlotYAxisDataSource, UIPickerViewDataSource, UIPickerViewDelegate, HXBaseDataSource, HXPlotCursorDataSource, HXHeapBarPlotDataSource, HXCoreplotXAxisDataSource>

@end

@implementation HXPlatformDataViewController {
    UIPickerView *platPickView;
    UIPickerView *typePickView;
    HXCorePlotControl *plotView;
    TYSXPlatformCtr *platCtr;
}

- (id)initWithPlotName:(NSString *)name {
    if (self = [super initWithPlotName:name]) {
        platCtr = [[TYSXPlatformCtr alloc] init];
        [platCtr reloadData];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    plotView = [[HXCorePlotControl alloc] initWithFrame:CGRectMake(0, 100, kScreenHeight - 150, kScreenWidth - 100)];
    plotView.layerManager.paddingLeft = 50;
    plotView.layerManager.paddingRight = 100;
    plotView.layerManager.paddingTop = 100;
    plotView.layerManager.paddingBottom = 80;
    plotView.layerManager.maxValue = 20;
    plotView.layerManager.minValue = 0;
    plotView.layerManager.rightMaxValue = 0.05;
    plotView.layerManager.rightMinValue = 0;
    plotView.layerManager.insetLeft = 20;
    plotView.layerManager.insetRight = 20;
    plotView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:plotView];
    
    HXHeapBarPlot *heapBarPlot = [HXHeapBarPlot layer];
    heapBarPlot.dataSource = self;
    [plotView addPlot:heapBarPlot];
    
    //[self addLinePlot];
    
    plotView.yAxis.dataSource = self;
    plotView.xAxis.dataSource = self;
    //plotView.xAxis.contentWidthScale = 2;
    //plotView.YAxis.needRightYAxis = YES;
    
    //[self addLinePlot];
    
    plotView.needCursor = YES;
    plotView.cursor.textFont = [UIFont systemFontOfSize:20];
    plotView.cursor.nodeRadius = 5;
    plotView.cursor.dataSource = self;
    
    [self refreshPlotView];
    
    typePickView = [[UIPickerView alloc] initWithFrame:CGRectMake(plotView.frame.origin.x + plotView.bounds.size.width, 200, 100, 100)];
    typePickView.showsSelectionIndicator = YES;
    typePickView.layer.cornerRadius = 10;
    typePickView.delegate = self;
    typePickView.backgroundColor = [UIColor grayColor];
    typePickView.layer.shadowOffset = CGSizeMake(2, 2);
    typePickView.layer.shadowColor = [UIColor grayColor].CGColor;
    typePickView.layer.shadowOpacity = 1;
    typePickView.dataSource = self;
    [self.view addSubview:typePickView];
    
    platPickView = [[UIPickerView alloc] initWithFrame:CGRectMake(typePickView.frame.origin.x, typePickView.frame.origin.y + typePickView.bounds.size.height + 50, typePickView.bounds.size.width, 100)];
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
    if (![platCtr hasAnyData]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"本地没有任何数据,是否更新最新数据" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

- (NSString *)lastDateStr {
   return platCtr.lastDateStr;
}

- (void)changeDateAction:(NSDate *)date {
    if (date == nil) {
        showPrompt(@"您选择的日期不合法,请重新选择", 1, YES);
        return;
    }
    
    NeedOperateType operateType = [platCtr updateLastDate:date];
    switch (operateType) {
        case NeedOperateType_OverDate:
            showPrompt(@"您选择的日期还没有数据生成", 1, YES);
            break;
            
        case NeedOperateType_Reload:
        {
            [self dismissDatePickView];
            [platCtr reloadData];
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


- (void)refreshPlotView {
    switch (platCtr.currentDimensionIndex) {
        case 0:
            plotView.layerManager.maxValue = [[platCtr.accessData maxValue] longValue] * 1.2;
            break;
        case 1:
            plotView.layerManager.maxValue = [[platCtr.loginData maxValue] longValue] * 1.2;
            plotView.layerManager.rightMaxValue = [[platCtr.loginTransData maxValue] floatValue] * 1.2;
            break;
        case 2:
            plotView.layerManager.maxValue = [[platCtr.playbackData maxValue] longValue] * 1.2;
            plotView.layerManager.rightMaxValue = [[platCtr.playbackTransData maxValue] floatValue] * 1.2;
            break;
            
        default:
            break;
    }
    [plotView reloadData];
}

- (void)refreshAllView {
    [self refreshPlotView];
    [drawView setNeedsDisplay];
}

//- (void)refreshAllView {
//    
//}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger ret = 0;
    if ([pickerView isEqual:platPickView]) {
        ret = [platCtr.platIdList count];
    }
    else {
        ret = 3;
    }
    return ret;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = (UILabel *)view;
    if (label == nil) {
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:15];
    }
    
    NSArray *title2 = @[@"访问", @"登录", @"播放"];
    
    if ([pickerView isEqual:platPickView]) {
        label.text = [platCtr platNameWithPlatId:platCtr.platIdList[row]];
    }
    else {
        label.text = title2[row];
    }
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if ([pickerView isEqual:typePickView]) {
        platCtr.currentDimensionIndex = row;
        [self refreshPlotView];
        switch (row) {
            case 0:
                [self removeLinePlot];
                plotView.yAxis.needRightYAxis = NO;
                break;
            case 1:
                plotView.yAxis.needRightYAxis = YES;
                [self addLinePlot];
                break;
            case 2:
                plotView.yAxis.needRightYAxis = YES;
                [self addLinePlot];
                break;
                
            default:
                break;
        }
    }
    else {
        platCtr.currentPlatIndex = row;
        [self refreshPlotView];
    }
}

- (void)addLinePlot {
    if ([plotView.plotLayers count] < 2) {
        HXLinePlot *linePlot = [HXLinePlot layer];
        linePlot.plotName = @"line";
        linePlot.lineColor = [UIColor cyanColor];
        linePlot.lineWidth = 3;
        linePlot.isUseRightAxisY = YES;
        linePlot.topGradientColor = [UIColor orangeColor];
        linePlot.bottomGradientColor = [UIColor greenColor];
        linePlot.dataSource = self;
        [plotView addPlot:linePlot];
    }
}

- (void)removeLinePlot {
    [plotView removePlotWithName:@"line"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma core plot datasource

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
    
    [@"数据维度" drawInRect:CGRectMake(typePickView.frame.origin.x, typePickView.frame.origin.y - font.pointSize - 8, typePickView.bounds.size.width, font.pointSize + 2) withAttributes:attributes];
    [@"客户端选择" drawInRect:CGRectMake(platPickView.frame.origin.x, platPickView.frame.origin.y - font.pointSize - 8, platPickView.bounds.size.width, font.pointSize + 2) withAttributes:attributes];
}

- (NSInteger)numberOfTitleInXAxis:(HXCoreplotXAxisLayer *)xAxis {
    return 6;
}

- (NSString *)xAxis:(HXCoreplotXAxisLayer *)xAxis titleAtIndex:(NSInteger)index {
    return platCtr.dateList[index * 6];
}

- (NSInteger)numberOfTitleInYAxis:(HXCorePlotYAxisLayer *)yAxis {
    return 3;
}
- (NSString *)yAxis:(HXCorePlotYAxisLayer *)yAxis titleAtIndex:(NSInteger)index isUseRightYAxis:(BOOL)isUseRight {
    NSString *ret = nil;
    if (isUseRight) {
        switch (platCtr.currentDimensionIndex) {
            case 1:
                ret = [NSString stringWithFormat:@"%.2f", plotView.layerManager.rightMaxValue * 1.2 - plotView.layerManager.rightMaxValue * 1.2 / 2 * index];
                break;
            case 2:
               ret =  [NSString stringWithFormat:@"%.2f", plotView.layerManager.rightMaxValue * 1.2 - plotView.layerManager.rightMaxValue * 1.2 / 2 * index];
                break;
                
            default:
                break;
        }
    }
    else {
        ret = [NSString stringWithFormat:@"%.0f", plotView.layerManager.maxValue * 1.2 - plotView.layerManager.maxValue * 1.2 / 2 * index];
    }
    return ret;
}

- (NSInteger)numberOfPlot:(HXBasePlot *)plot {
    return 31;
}


- (NSNumber *)plot:(HXBasePlot *)plot index:(NSInteger)index{
    
    NSArray *ret = nil;
    
    switch (platCtr.currentDimensionIndex) {
        case 1:
            ret = platCtr.loginTransData;
            break;
        case 2:
            ret = platCtr.playbackTransData;
            break;
            
        default:
            break;
    }
    return ret[index];
}

- (NSInteger)numberOfXValuesInHeapBarPlot:(HXHeapBarPlot *)heapBarPlot {
    return 31;
}


- (NSInteger)numberOfHeapBarInHeapBarPlot:(HXHeapBarPlot *)heapBarPlot {
    return 1;
}
- (NSNumber *)heapBarPlot:(HXHeapBarPlot *)heapBarPlot valueOfXIndex:(NSInteger)xIndex heapIndex:(NSInteger)heapIndex {
    NSArray *ret = nil;
    
    switch (platCtr.currentDimensionIndex) {
        case 0:
            ret = platCtr.accessData;
            break;
        case 1:
            ret = platCtr.loginData;
            break;
        case 2:
            ret = platCtr.playbackData;
            break;
            
        default:
            break;
    }
    
    return ret[xIndex];
}

- (UIColor *)heapBarPlot:(HXHeapBarPlot *)heapBarPlot colorOfHeapIndex:(NSInteger)heapIndex {
    UIColor *ret = nil;
    switch ([typePickView selectedRowInComponent:0]) {
        case 0:
            ret = kAccessColor;
            break;
        case 1:
            ret = kLoginColor;
            break;
        case 2:
            ret = kPlayBackColor;
            break;
            
        default:
            break;
    }
    return ret;
}

- (NSString *)plotCursor:(HXPlotCursor *)plotCursor degreeNameOfIndex:(NSInteger)index {
    return platCtr.dateList[index];
}
- (NSInteger)numberOfDegreeInCursor:(HXPlotCursor *)plotCursor {
    return [platCtr.dateList count];
}

- (NSInteger)numberOfComponentInCursor:(HXPlotCursor *)plotCursor {
    NSInteger ret = 0;
    switch (platCtr.currentDimensionIndex) {
        case 0:
            ret = 1;
            break;
        case 1:
            ret = 2;
            break;
        case 2:
            ret = 2;
            break;
            
        default:
            break;
    }
    return ret;
}

- (NSString *)plotCursor:(HXPlotCursor *)plotCursor textOfIndex:(NSInteger)index component:(NSInteger)component {
    
    NSString *ret = nil;
    switch (component) {
        case 0:
            if (platCtr.currentDimensionIndex == 0) {
                ret = [NSString stringWithFormat:@"访问数：%lld", [platCtr.accessData[index] longLongValue]];
            }
            else if (platCtr.currentDimensionIndex == 1) {
                ret = [NSString stringWithFormat:@"登录数：%lld", [platCtr.loginData[index] longLongValue]];
            }
            else {
                ret = [NSString stringWithFormat:@"播放数：%lld", [platCtr.playbackData[index] longLongValue]];
            }
            break;
        case 1:
            if (platCtr.currentDimensionIndex == 1) {
                ret = [NSString stringWithFormat:@"登录转换率：%.2f%%", [platCtr.loginTransData[index] floatValue] * 100];
            }
            else if (platCtr.currentDimensionIndex == 2) {
                ret = [NSString stringWithFormat:@"播放转换率：%.2f%%", [platCtr.playbackTransData[index] floatValue] * 100];
            }
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
            if (platCtr.currentDimensionIndex == 0) {
                ret = kAccessColor;
            }
            else if (platCtr.currentDimensionIndex == 1) {
                ret = kLoginColor;
            }
            else {
                ret = kPlayBackColor;
            }
            break;
        case 1:
            ret = [UIColor cyanColor];
            break;
            
        default:
            break;
    }
    return ret;
}

#define alertview delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        
        showStatusView(YES);
        
        __block HXPlatformDataViewController *ctr = self;
        [platCtr sendRequestWith:^{
            showPrompt(platCtr.resultInfo, 1, YES);
            if (platCtr.result == NetworkBaseResult_Success) {
                [platCtr saveNetworkDataWithCompleteBlock:^{
                    [platCtr reloadData];
                    run_async_main(^{
                        [platPickView reloadAllComponents];
                        dismissStatusView();
                        [ctr refreshAllView];
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

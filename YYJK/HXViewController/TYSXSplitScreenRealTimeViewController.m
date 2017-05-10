//
//  TYSXSplitScreenRealTimeViewController.m
//  tysx
//
//  Created by zwc on 14/12/18.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "TYSXSplitScreenRealTimeViewController.h"
#import "HXCorePlot.h"
#import "MEDragSegmentedControl.h"
#import "TYSXSplitScreenRealTimeCtr.h"

@interface TYSXSplitScreenRealTimeViewController()<HXBaseDataSource, HXCoreplotXAxisDataSource, HXCorePlotYAxisDataSource>

@end

@implementation TYSXSplitScreenRealTimeViewController {
    HXCorePlotControl *monitorControl;
    TYSXSplitScreenRealTimeCtr *realCtr;
    MEDragSegmentedControl *horizonalSeg;
}

+ (Class)cachePlotCtr {
    return [TYSXSplitScreenRealTimeCtr class];
}

+ (CacheType)cacheType {
    return CacheType_Once;
}

- (id)initWithPlotName:(NSString *)_plotName {
    if (self = [super initWithPlotName:_plotName]) {
        realCtr = (TYSXSplitScreenRealTimeCtr *)cachePlotCtr;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MEDragSegmentedControl *dragSegmentedControl = [[MEDragSegmentedControl alloc] initWithFrame:CGRectMake(kScreenHeight - 150, 100, 150, kScreenWidth - 100)];
    [dragSegmentedControl addTarget:self action:@selector(changeValueAction:) forControlEvents:UIControlEventValueChanged];
    dragSegmentedControl.itemTitles = @[@"客户端5",@"客户端4", @"客户端3", @"WAP", @"iPhone", @"爱看4G", @"PC"];
    if (kNeedVirtualData) {
        dragSegmentedControl.itemTitles = @[@"项目一", @"项目二", @"项目三", @"项目四", @"项目五", @"项目六", @"项目七"];
    }
    
    [self.view addSubview:dragSegmentedControl];

    monitorControl = [[HXCorePlotControl alloc] initWithFrame:CGRectMake(0, 200, kScreenHeight - 150, kScreenWidth - 200)];
    monitorControl.xAxis.dataSource = self;
    monitorControl.yAxis.dataSource = self;
    monitorControl.xAxis.numberOfSubline = 24;
    monitorControl.yAxis.numberOfSubline = 4;
    monitorControl.yAxis.sublineColor = monitorControl.xAxis.sublineColor = [UIColor colorWithHexString:@"e5e5e5"];
    monitorControl.layerManager.paddingLeft = 80;
    monitorControl.layerManager.insetLeft = monitorControl.layerManager.insetRight = monitorControl.xAxis.offsetLeft = monitorControl.xAxis.offsetRight = 20;
    monitorControl.layerManager.maxValue = 100;
    [self.view addSubview:monitorControl];
    
    HXLinePlot *pv = [HXLinePlot layer];
    pv.lineWidth = 2;
    pv.lineColor = [UIColor colorWithRed:40/255.0 green:96/255.0 blue:205/255.0 alpha:1.0];
    pv.dataSource = self;
    pv.plotName = @"pv";
    pv.showLimitNum = realCtr.maxHour;
    [monitorControl addPlot:pv];
    
    HXLinePlot *uv = [HXLinePlot layer];
    uv.lineWidth = 2;
    uv.lineColor = [UIColor colorWithRed:247/255.0 green:38/255.0 blue:49/255.0 alpha:1.0];
    uv.dataSource = self;
    uv.plotName = @"uv";
    uv.showLimitNum = realCtr.maxHour;
    [monitorControl addPlot:uv];
    
    HXLinePlot *yesterday_pv = [HXLinePlot layer];
    yesterday_pv.lineWidth = 2;
    yesterday_pv.lineColor = [UIColor colorWithRed:88/255.0 green:177/255.0 blue:241/255.0 alpha:1.0];
    yesterday_pv.dataSource = self;
    yesterday_pv.plotName = @"yesterday_pv";
    [monitorControl addPlot:yesterday_pv];
    
    HXLinePlot *yesterday_uv = [HXLinePlot layer];
    yesterday_uv.lineWidth = 2;
    yesterday_uv.lineColor = [UIColor colorWithRed:248/255.0 green:144/255.0 blue:147/255.0 alpha:1.0];
    yesterday_uv.dataSource = self;
    yesterday_uv.plotName = @"yesterday_uv";
    [monitorControl addPlot:yesterday_uv];
    
    [self changeValueAction:dragSegmentedControl];
}

- (void)refreshAllView {
    [bgDrawView setNeedsDisplay];
    [monitorControl reloadData];
    monitorControl.layerManager.maxValue = [self showMaxValue];
    for (HXLinePlot *plot in monitorControl.plotLayers) {
        HXLinePlot *linePlot = (HXLinePlot *)plot;
        if ([plot isKindOfClass:[HXLinePlot class]]) {
            if ([plot.plotName isEqualToString:@"pv"] || [plot.plotName isEqualToString:@"uv"]) {
                linePlot.showLimitNum = realCtr.maxHour;
            }
        }
    }
}

- (void)changeLeftValue:(MEDragSegmentedControl *)sender{
    realCtr.selectedSubPlatType = (int)sender.selectedIndex;
    monitorControl.layerManager.maxValue = [self showMaxValue];
    [monitorControl reloadData];
}

- (void)changeValueAction:(MEDragSegmentedControl *)sender {
    realCtr.selectedPlatType = (int)sender.selectedIndex;
    
    monitorControl.layerManager.maxValue = [self showMaxValue];
    
    for (HXLinePlot *plot in monitorControl.plotLayers) {
        HXLinePlot *linePlot = (HXLinePlot *)plot;
        if ([plot isKindOfClass:[HXLinePlot class]]) {
            if ([plot.plotName isEqualToString:@"pv"] || [plot.plotName isEqualToString:@"uv"]) {
                linePlot.showLimitNum = realCtr.maxHour;
            }
        }
    }
    
    [horizonalSeg removeFromSuperview];
    horizonalSeg = [[MEDragSegmentedControl alloc] initWithFrame:CGRectMake(100, 140, 400, 60)];
    horizonalSeg.orientation = ShowOrientation_Horizonal;
    [horizonalSeg addTarget:self action:@selector(changeLeftValue:) forControlEvents:UIControlEventValueChanged];
    horizonalSeg.selectedFont = [UIFont systemFontOfSize:15];
    horizonalSeg.normalFont = [UIFont systemFontOfSize:13];
    // horizonalSeg.everyWidth = 60;
    horizonalSeg.itemTitles = realCtr.platSubTypeList;
    [self.view addSubview:horizonalSeg];
    [monitorControl reloadData];
}

- (NSInteger)numberOfTitleInYAxis:(HXCorePlotYAxisLayer *)yAxis {
    return 5;
}

- (CGFloat)showMaxValue {
    NSMutableArray *tempArray = [NSMutableArray array];
    [tempArray addObject:[NSNumber numberWithFloat:realCtr.pvData.maxFloatValue]];
    [tempArray addObject:[NSNumber numberWithFloat:realCtr.uvData.maxFloatValue]];
    [tempArray addObject:[NSNumber numberWithFloat:realCtr.yesterdayPvData.maxFloatValue]];
    [tempArray addObject:[NSNumber numberWithFloat:realCtr.yesterdayUvData.maxFloatValue]];
    return tempArray.maxFloatValue;
}

- (NSString *)yAxis:(HXCorePlotYAxisLayer *)yAxis titleAtIndex:(NSInteger)index isUseRightYAxis:(BOOL)isUseRight {
    CGFloat maxValue = [self showMaxValue];
    return [NSString stringWithFormat:@"%.0f", maxValue - maxValue / 4 * index];
}

- (NSInteger)numberOfTitleInXAxis:(HXCoreplotXAxisLayer *)xAxis {
    return 24;
}

- (NSString *)xAxis:(HXCoreplotXAxisLayer *)xAxis titleAtIndex:(NSInteger)index {
    return  [NSString stringWithFormat:@"%ld", (long)index];
}

- (NSInteger)numberOfPlot:(HXBasePlot *)plot {
    return 24;
}
- (NSNumber *)plot:(HXBasePlot *)plot index:(NSInteger)index {
    if ([plot.plotName isEqualToString:@"pv"]) {
        return realCtr.pvData[index];
    }
    else if ([plot.plotName isEqualToString:@"uv"]) {
        return realCtr.uvData[index];
    }
    else if ([plot.plotName isEqualToString:@"yesterday_pv"]) {
        return realCtr.yesterdayPvData[index];
    }
    else {
        return realCtr.yesterdayUvData[index];
    }
}

- (void)contentView:(MYDrawContentView *)view drawRect:(CGRect)rect {
    [super contentView:view drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithHexString:@"f5f5f5"].CGColor);
    CGContextFillRect(ctx, CGRectMake(kScreenHeight - 150, 50, 150, kScreenWidth - 50));
    if (kNeedVirtualData) {
        [self drawLineLegendWithColor:[UIColor colorWithRed:40/255.0 green:96/255.0 blue:205/255.0 alpha:1.0] title:@"条目一" orgin:    CGPointMake(630, 88)];
        [self drawLineLegendWithColor:[UIColor colorWithRed:247/255.0 green:38/255.0 blue:49/255.0 alpha:1.0] title:@"条目二" orgin:    CGPointMake(750, 88)];
        [self drawLineLegendWithColor:[UIColor colorWithRed:88/255.0 green:177/255.0 blue:241/255.0 alpha:1.0] title:@"条目三" orgin:    CGPointMake(630, 110)];
        [self drawLineLegendWithColor:[UIColor colorWithRed:248/255.0 green:144/255.0 blue:147/255.0 alpha:1.0] title:@"条目四" orgin:    CGPointMake(750, 110)];
    }
    else {
        [self drawLineLegendWithColor:[UIColor colorWithRed:40/255.0 green:96/255.0 blue:205/255.0 alpha:1.0] title:@"PV" orgin:    CGPointMake(630, 88)];
        [self drawLineLegendWithColor:[UIColor colorWithRed:247/255.0 green:38/255.0 blue:49/255.0 alpha:1.0] title:@"UV" orgin:    CGPointMake(750, 88)];
        [self drawLineLegendWithColor:[UIColor colorWithRed:88/255.0 green:177/255.0 blue:241/255.0 alpha:1.0] title:@"昨日PV" orgin:    CGPointMake(630, 110)];
        [self drawLineLegendWithColor:[UIColor colorWithRed:248/255.0 green:144/255.0 blue:147/255.0 alpha:1.0] title:@"昨日UV" orgin:    CGPointMake(750, 110)];
    }
}

- (void)drawLineLegendWithColor:(UIColor *)color title:(NSString *)title orgin:(CGPoint)origin {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    CGContextSetStrokeColorWithColor(ctx, color.CGColor);
    CGContextSetLineWidth(ctx, 2);
    
    CGFloat drawWidth = 32;
    CGFloat ellipseRadius = 4;
    
    CGContextMoveToPoint(ctx, origin.x, origin.y);
    CGContextAddLineToPoint(ctx, origin.x + drawWidth, origin.y);
    CGContextStrokePath(ctx);
    
    CGContextFillEllipseInRect(ctx, CGRectMake(origin.x + drawWidth / 2 - ellipseRadius, origin.y - ellipseRadius, ellipseRadius * 2, ellipseRadius * 2));
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    [attr setValue:[UIFont systemFontOfSize:15] forKey:NSFontAttributeName];
    [attr setValue:[UIColor grayColor] forKey:NSForegroundColorAttributeName];
    [title drawAtPoint:CGPointMake(origin.x + drawWidth + 5, origin.y - 9) withAttributes:attr];
}

@end

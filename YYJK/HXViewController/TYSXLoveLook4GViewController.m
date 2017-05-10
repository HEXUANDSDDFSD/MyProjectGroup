//
//  TYSXLoveLook4GViewController.m
//  tysx
//
//  Created by zwc on 14/12/16.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "TYSXLoveLook4GViewController.h"
#import "MEDragSegmentedControl.h"
#import "HXCorePlot.h"
#import "TYSXLoveLook4gCtr.h"
#import "MESegmentedControl.h"

#define kMyYellowColor [UIColor colorWithRed:255/255.0 green:188/255.0 blue:42/255.0 alpha:1.0]

@interface TYSXLoveLook4GViewController ()<HXCoreplotXAxisDataSource, HXCorePlotYAxisDataSource, HXBaseDataSource, HXHeapBarPlotDataSource, HXCorePlotControlDelegate>

@end

@implementation TYSXLoveLook4GViewController {
    HXCorePlotControl *topPlot;
    HXCorePlotControl *bottomRightPlot;
    MESegmentedControl *segmentedControl;
    MEDragSegmentedControl *horizonalSeg;
    TYSXLoveLook4gCtr *loveLookCtr;
}

- (id)initWithPlotName:(NSString *)_plotName {
    if (self = [super initWithPlotName:_plotName]) {
        loveLookCtr = (TYSXLoveLook4gCtr *)cachePlotCtr;
    }
    return self;
}

+ (Class)cachePlotCtr {
    return [TYSXLoveLook4gCtr class];
}

+ (CacheType)cacheType {
    return CacheType_Once;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    segmentedControl = [[MESegmentedControl alloc] initWithTitle:@[@"登录播放", @"订购"]];
    if (kNeedVirtualData) {
        segmentedControl = [[MESegmentedControl alloc] initWithTitle:@[@"项目一", @"项目二"]];
    }
    segmentedControl.font = [UIFont systemFontOfSize:18];
    segmentedControl.everyWidth = 128;
    segmentedControl.itemHeight = 40;
    segmentedControl.x = 390;
    segmentedControl.y = 66;
    [segmentedControl addTarget:self action:@selector(changeValueAction:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.selectedTitleColor = [UIColor colorWithHexString:@"333333"];
    segmentedControl.seletedBgColor = [UIColor colorWithHexString:@"F5F5F5"];
    segmentedControl.normalBgColor = [UIColor colorWithHexString:@"CCCCCC"];
    segmentedControl.borderColor = [UIColor colorWithHexString:@"F0F0F0"];
    segmentedControl.layer.cornerRadius = 10;
    [self.view addSubview:segmentedControl];
    
//    MEDragSegmentedControl *dragSegmentedControl = [[MEDragSegmentedControl alloc] initWithFrame:CGRectMake(kScreenHeight - 150, 327, 150, 304)];
//    [dragSegmentedControl addTarget:self action:@selector(changeValueAction:) forControlEvents:UIControlEventValueChanged];
//    dragSegmentedControl.itemTitles = @[@"汇总",@"客户端5", @"客户端4", @"爱看4G"];
//    [self.view addSubview:dragSegmentedControl];
    
    topPlot = [[HXCorePlotControl alloc] initWithFrame:CGRectMake(0, 116, kScreenHeight, 280)];
    topPlot.titleLocation = TitleLocation_Top;
    topPlot.titleOffset = -20;
    topPlot.xAxis.dataSource = self;
    topPlot.yAxis.dataSource = self;
    topPlot.delegate = self;
    topPlot.layerManager.paddingTop = 50;
    topPlot.layerManager.paddingLeft = 50;
    topPlot.layerManager.maxValue = 20;
    topPlot.layerManager.insetLeft = 50;
    topPlot.layerManager.insetRight = 50;
    topPlot.titleOffset = -45;
    topPlot.legendOriginPoint = CGPointMake(50, 20);
    [self.view addSubview:topPlot];
    
    [self changeValueAction:segmentedControl];
    
    {
        bottomRightPlot = [[HXCorePlotControl alloc] initWithFrame:CGRectMake(0, topPlot.y + topPlot.height, kScreenHeight / 2, kScreenWidth - topPlot.y - topPlot.height)];
        bottomRightPlot.xAxis.dataSource = self;
        bottomRightPlot.yAxis.dataSource = self;
        bottomRightPlot.xAxis.sublineColor = bottomRightPlot.yAxis.sublineColor = [UIColor colorWithHexString:@"e5e5e5"];
        bottomRightPlot.layerManager.paddingLeft = 50;
        bottomRightPlot.xAxis.numberOfSubline = 24;
        bottomRightPlot.yAxis.numberOfSubline = 3;
        bottomRightPlot.layerManager.paddingTop = 70;
        bottomRightPlot.layerManager.maxValue = 20;
        bottomRightPlot.layerManager.insetLeft = 30;
        bottomRightPlot.layerManager.insetRight = 30;
        bottomRightPlot.layerManager.paddingTop = 80;
        [self.view addSubview:bottomRightPlot];
        
        CGFloat maxValue = loveLookCtr.realTimeYesterdayData.maxFloatValue;
        if (maxValue < loveLookCtr.realTimeTodayData.maxFloatValue) {
            maxValue = loveLookCtr.realTimeTodayData.maxFloatValue;
        }
        bottomRightPlot.layerManager.maxValue = maxValue;
        
        HXLinePlot *leftLinePlot = [HXLinePlot layer];
        leftLinePlot.dataSource = self;
        leftLinePlot.plotName = @"yesterday";
        leftLinePlot.lineWidth = 1;
        leftLinePlot.lineColor = [UIColor colorWithHexString:@"c3bbf8"];
        [bottomRightPlot addPlot:leftLinePlot];
        
        HXLinePlot *rightLinePlot = [HXLinePlot layer];
        rightLinePlot.dataSource = self;
        rightLinePlot.plotName = @"today";
        rightLinePlot.lineWidth = 2;
        rightLinePlot.lineColor = [UIColor colorWithHexString:@"9f93f1"];
        [bottomRightPlot addPlot:rightLinePlot];
    }
    
    [self changeValueAction:segmentedControl];
    
    // Do any additional setup after loading the view.
}

- (void)refreshAllView {
    [bgDrawView setNeedsDisplay];
    [topPlot reloadData];
    CGFloat maxValue = 0;
    
    if (segmentedControl.selectedIndex == 0) {
        maxValue = loveLookCtr.loginData.maxFloatValue;
        if (maxValue < loveLookCtr.playData.maxFloatValue) {
            maxValue = loveLookCtr.playData.maxFloatValue;
        }
        topPlot.layerManager.maxValue = maxValue;
        topPlot.layerManager.rightMaxValue = loveLookCtr.conversionRateData.maxFloatValue;
    }
    else {
        topPlot.layerManager.maxValue = loveLookCtr.orderData.maxFloatValue;
    }
    maxValue = loveLookCtr.realTimeTodayData.maxFloatValue;
    if (maxValue < loveLookCtr.realTimeYesterdayData.maxFloatValue) {
        maxValue = loveLookCtr.realTimeYesterdayData.maxFloatValue;
    }
    bottomRightPlot.layerManager.maxValue = maxValue;
    [bottomRightPlot reloadData];
    
    for (HXLinePlot *plot in bottomRightPlot.plotLayers) {
        if ([plot isKindOfClass:[HXLinePlot class]] && [plot.plotName isEqualToString:@"today"]) {
            plot.showLimitNum = loveLookCtr.maxHour;
        }
    }
}

- (void)changeLeftValue:(MEDragSegmentedControl *)seg {
    loveLookCtr.selectedTopTenType = (int)seg.selectedIndex;
    [bgDrawView setNeedsDisplay];
}

- (NSInteger)numberOfNeedTouchDegreeCorePlotControl:(HXCorePlotControl *)corePlotControl {
    return 9;
}

- (void)corePlotControl:(HXCorePlotControl *)corePlotControl touchIndex:(NSInteger)index {
    loveLookCtr.selecteTopTenIndex = index;
    [bgDrawView setNeedsDisplay];
}

- (NSInteger)numberOfTitleInXAxis:(HXCoreplotXAxisLayer *)xAxis {
    if  ([bottomRightPlot.xAxis isEqual:xAxis]) {
        return 24;
    }
    else {
        return 9;
    }
}
- (NSString *)xAxis:(HXCoreplotXAxisLayer *)xAxis titleAtIndex:(NSInteger)index {
    if ([topPlot.xAxis isEqual:xAxis]) {
        return [cachePlotCtr dataStrListWithDayNumber:9][index];
    }
    else if ([bottomRightPlot.xAxis isEqual:xAxis]) {
        return  [NSString stringWithFormat:@"%ld", (long)index];
    }
    else {
        return [[cachePlotCtr dataStrListWithDayNumber:9][index] substringFromIndex:5];
    }
}

- (NSInteger)numberOfTitleInYAxis:(HXCorePlotYAxisLayer *)yAxis {
    return 4;
}
- (NSString *)yAxis:(HXCorePlotYAxisLayer *)yAxis titleAtIndex:(NSInteger)index isUseRightYAxis:(BOOL)isUseRight {
    CGFloat maxValue = 0;
    if ([topPlot.yAxis isEqual:yAxis]) {
        if (segmentedControl.selectedIndex == 0) {
            if (isUseRight) {
                maxValue = loveLookCtr.conversionRateData.maxFloatValue;
            }
            else {
                maxValue = loveLookCtr.loginData.maxFloatValue;
                if (maxValue < loveLookCtr.playData.maxFloatValue) {
                    maxValue = loveLookCtr.playData.maxFloatValue;
                }
            }
        }
        else {
            maxValue = loveLookCtr.orderData.maxFloatValue;
        }
    }
    else {
        maxValue = loveLookCtr.realTimeYesterdayData.maxFloatValue;
        if (maxValue < loveLookCtr.realTimeTodayData.maxFloatValue) {
            maxValue = loveLookCtr.realTimeTodayData.maxFloatValue;
        }
    }
    if (isUseRight) {
        return [NSString stringWithFormat:@"%.1f", maxValue - maxValue / 3 * index];
    }
    return [NSString stringWithFormat:@"%.0f", maxValue - maxValue / 3 * index];
}

- (NSInteger)numberOfPlot:(HXBasePlot *)plot {
    if ([plot.plotName isEqualToString:@"top"]) {
        return 9;
    }
    else if ([plot.plotName isEqualToString:@"yesterday"] ||
             [plot.plotName isEqualToString:@"today"]) {
        return 24;
    }
    return 9;
}

- (NSNumber *)plot:(HXBasePlot *)plot index:(NSInteger)index {
    if ([plot.plotName isEqualToString:@"top"]) {
         return loveLookCtr.conversionRateData[index];
    }
    else if([plot.plotName isEqualToString:@"today"]) {
        return loveLookCtr.realTimeTodayData[index];
    }
    else {
        return loveLookCtr.realTimeYesterdayData[index];
    }
    return @18;
}

- (NSInteger)numberOfXValuesInHeapBarPlot:(HXHeapBarPlot *)heapBarPlot {
    return 9;
}

- (NSInteger)numberOfHeapBarInHeapBarPlot:(HXHeapBarPlot *)heapBarPlot {
    return 1;
}

- (NSNumber *)heapBarPlot:(HXHeapBarPlot *)heapBarPlot valueOfXIndex:(NSInteger)xIndex heapIndex:(NSInteger)heapIndex {
    if ([heapBarPlot.plotName isEqualToString:@"login"]) {
        return loveLookCtr.loginData[xIndex];
    }
    else if ([heapBarPlot.plotName isEqualToString:@"play"]) {
        return loveLookCtr.playData[xIndex];
    }
    else if ([heapBarPlot.plotName isEqualToString:@"order"]) {
        return loveLookCtr.orderData[xIndex];
    }
    return @(arc4random()%19);
}

- (UIColor *)heapBarPlot:(HXHeapBarPlot *)heapBarPlot colorOfHeapIndex:(NSInteger)heapIndex {
    UIColor *ret = nil;
    if ([heapBarPlot.plotName isEqualToString:@"login"] || [heapBarPlot.plotName isEqualToString:@"order"]) {
        ret = [UIColor colorWithHexString:@"aba2f0"];
    }
    else if ([heapBarPlot.plotName isEqualToString:@"play"]) {
        ret = [UIColor colorWithHexString:@"7ee4ed"];            }
    return ret;
}

- (void)changeValueAction:(MESegmentedControl *)sender {
    loveLookCtr.selectedMainType = (int)sender.selectedIndex;
    [topPlot removeAllPlot];
    [bgDrawView setNeedsDisplay];
    [horizonalSeg removeFromSuperview];
    if (sender.selectedIndex == 0) {
        topPlot.title = @"登录及播放转化率趋势图";
        if (kNeedVirtualData) {
            topPlot.title = @"图表名称";
        }
        topPlot.yAxis.needRightYAxis = YES;
        
        CGFloat maxValue = loveLookCtr.loginData.maxFloatValue;
        if (maxValue < loveLookCtr.playData.maxFloatValue) {
            maxValue = loveLookCtr.playData.maxFloatValue;
        }
        topPlot.layerManager.maxValue = maxValue;
        
        topPlot.layerManager.rightMaxValue = loveLookCtr.conversionRateData.maxFloatValue;
        
        horizonalSeg = [[MEDragSegmentedControl alloc] initWithFrame:CGRectMake(kScreenHeight / 2 + 100, topPlot.y + topPlot.height + 30, 350, 60)];
        horizonalSeg.orientation = ShowOrientation_Horizonal;
        [horizonalSeg addTarget:self action:@selector(changeLeftValue:) forControlEvents:UIControlEventValueChanged];
        horizonalSeg.everyWidth = 100;
        horizonalSeg.itemTitles = @[@"直播次数", @"点播次数", @"回看次数", @"下载次数"];
        if (kNeedVirtualData) {
            horizonalSeg.itemTitles = @[@"项目一", @"项目二", @"项目三", @"项目四"];
        }
        [self.view addSubview:horizonalSeg];
        
        HXHeapBarPlot *topLoginHeap = [HXHeapBarPlot layer];
        topLoginHeap.dataSource = self;
        topLoginHeap.plotName = @"login";
        topLoginHeap.needShowValue = YES;
        topLoginHeap.beginPosition = 0.2;
        topLoginHeap.endPosition = 0.5;
        [topPlot addPlot:topLoginHeap];
        
        HXHeapBarPlot *topPlayHeap = [HXHeapBarPlot layer];
        topPlayHeap.dataSource = self;
        topPlayHeap.needShowValue = YES;
        topPlayHeap.plotName = @"play";
        topPlayHeap.beginPosition = 0.5;
        topPlayHeap.endPosition = 0.8;
        [topPlot addPlot:topPlayHeap];
        
        HXLinePlot *linePlot = [HXLinePlot layer];
        linePlot.dataSource = self;
        linePlot.isUseRightAxisY = YES;
        linePlot.plotName = @"top";
        linePlot.showLimitNum = 8;
        linePlot.lineWidth = 1;
        linePlot.lineColor = [UIColor colorWithHexString:@"a89d97"];
        [topPlot addPlot:linePlot];
        
        HXLegendInfo *one = [[HXLegendInfo alloc] init];
        one.legendTitle = @"登录";
        if (kNeedVirtualData) {
            one.legendTitle = @"条目一";
        }
        one.color = [UIColor colorWithHexString:@"aba2f0"];
        HXLegendInfo *two = [[HXLegendInfo alloc] init];
        two.legendTitle = @"播放";
        if (kNeedVirtualData) {
            two.legendTitle = @"条目二";
        }
        two.color = [UIColor colorWithHexString:@"7ee4ed"];
        HXLegendInfo *three = [[HXLegendInfo alloc] init];
        three.legendTitle = @"转化率";
        if (kNeedVirtualData) {
            three.legendTitle = @"条目三";
        }
        three.fillHeight = 1;
        three.fillWidth = 30;
        three.color = [UIColor colorWithHexString:@"a89d97"];
        topPlot.legendList = @[one, two, three];
    }
    else {
        topPlot.title = @"订购统计图";
        if (kNeedVirtualData) {
            topPlot.title = @"图表名称";
        }
        topPlot.yAxis.needRightYAxis = NO;
        topPlot.layerManager.maxValue = loveLookCtr.orderData.maxFloatValue;
        
        horizonalSeg = [[MEDragSegmentedControl alloc] initWithFrame:CGRectMake(kScreenHeight / 2 + 100, topPlot.y + topPlot.height + 30, 350, 60)];
        horizonalSeg.orientation = ShowOrientation_Horizonal;
        [horizonalSeg addTarget:self action:@selector(changeLeftValue:) forControlEvents:UIControlEventValueChanged];
        horizonalSeg.itemTitles = @[@"渠道", @"节目", @"CP"];
        if (kNeedVirtualData) {
            horizonalSeg.itemTitles = @[@"项目一", @"项目二", @"项目三"];

        }
        [self.view addSubview:horizonalSeg];
        
        HXHeapBarPlot *topLoginHeap = [HXHeapBarPlot layer];
        topLoginHeap.dataSource = self;
        topLoginHeap.needShowValue = YES;
        topLoginHeap.plotName = @"order";
        topLoginHeap.beginPosition = 0.2;
        topLoginHeap.endPosition = 0.5;
        [topPlot addPlot:topLoginHeap];
        
        HXLegendInfo *one = [[HXLegendInfo alloc] init];
        one.legendTitle = @"新增订购数量";
        if (kNeedVirtualData) {
            one.legendTitle = @"条目一";
        }
        one.color = [UIColor colorWithHexString:@"aba2f0"];
        topPlot.legendList = @[one];
    }
    [topPlot reloadData];
    
   CGFloat maxValue = loveLookCtr.realTimeTodayData.maxFloatValue;
    if (maxValue < loveLookCtr.realTimeYesterdayData.maxFloatValue) {
        maxValue = loveLookCtr.realTimeYesterdayData.maxFloatValue;
    }
    bottomRightPlot.layerManager.maxValue = maxValue;
    [bottomRightPlot reloadData];
    
    for (HXLinePlot *plot in bottomRightPlot.plotLayers) {
        if ([plot isKindOfClass:[HXLinePlot class]] && [plot.plotName isEqualToString:@"today"]) {
            plot.showLimitNum = loveLookCtr.maxHour;
        }
    }
}

- (void)contentView:(MYDrawContentView *)view drawRect:(CGRect)rect {
    [super contentView:view drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithHexString:@"fafafa"].CGColor);
    CGContextFillRect(ctx, CGRectMake(0, topPlot.y + topPlot.height, kScreenHeight, kScreenWidth - topPlot.y - topPlot.height));
    
    CGFloat offsetTop = topPlot.y + topPlot.height + 5;
    CGFloat offsetLeft = kScreenHeight / 2;
    CGFloat itemWidth = 140;
    
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    [attr setValue:[UIColor grayColor] forKey:NSForegroundColorAttributeName];
    [attr setValue:[UIFont systemFontOfSize:15] forKey:NSFontAttributeName];
    
    if (kNeedVirtualData) {
        [@"图表名称" drawAtPoint:CGPointMake(offsetLeft, offsetTop) withAttributes:attr];
    }
    else {
        [@"触发订购量TOP10" drawAtPoint:CGPointMake(offsetLeft, offsetTop) withAttributes:attr];
    }
    [attr setValue:[UIFont systemFontOfSize:12] forKey:NSFontAttributeName];
    offsetTop += 30;
    [[loveLookCtr dataStrListWithDayNumber:9][loveLookCtr.selecteTopTenIndex] drawAtPoint:CGPointMake(offsetLeft, offsetTop) withAttributes:attr];
    
    [attr setValue:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName];
    
    NSMutableParagraphStyle *para = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    para.lineBreakMode = NSLineBreakByTruncatingTail;
    para.alignment = NSTextAlignmentRight;
    [attr setValue:para forKey:NSParagraphStyleAttributeName];
    
    offsetTop += 60;
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithHexString:@"ACDBFE"].CGColor);
    CGContextFillRect(ctx, CGRectMake(offsetLeft + itemWidth + 3, offsetTop - 5, 7, 25 * 10));
    
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithHexString:@"8EBCE0"].CGColor);
    
    CGFloat maxDrawWidth = 300;
    CGFloat maxValue = [loveLookCtr.topTenData[0] intValue];
    for (int i = 0; i < 10; i++) {
        CGFloat drawWidth = 0;
        if (maxValue != 0) {
            drawWidth = [loveLookCtr.topTenData[i] intValue] / maxValue * maxDrawWidth;
            [loveLookCtr.topTenNameList[i] drawInRect:CGRectMake(offsetLeft, offsetTop, itemWidth, 16) withAttributes:attr];
            CGContextFillRect(ctx, CGRectMake(offsetLeft + itemWidth + 10, offsetTop, drawWidth, 17));
        }
        offsetTop += 25;
    }
    
    offsetLeft = 20;
    offsetTop = topPlot.y + topPlot.height + 10;
    
    attr = [NSMutableDictionary dictionary];
    [attr setValue:[UIFont systemFontOfSize:16] forKey:NSFontAttributeName];
    [attr setValue:[UIColor grayColor] forKey:NSForegroundColorAttributeName];
    NSString *title = nil;
    if (segmentedControl.selectedIndex == 0) {
        title = @"实时访问";
    }
    else {
        title = @"实时订购";
    }
    
    [title drawAtPoint:CGPointMake(offsetLeft, offsetTop) withAttributes:attr];
    
    offsetTop += 15;
    offsetLeft += 90;
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithHexString:@"9f93f1"].CGColor);
    CGContextSetLineWidth(ctx, 2);
    CGContextMoveToPoint(ctx, offsetLeft, offsetTop);
    offsetLeft += 22;
    CGContextAddLineToPoint(ctx, offsetLeft, offsetTop);
    CGContextStrokePath(ctx);
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithHexString:@"9f93f1"].CGColor);
    CGContextFillEllipseInRect(ctx, CGRectMake(offsetLeft - 11 - 2, offsetTop - 2, 4, 4));
    
    [attr setValue:[UIFont systemFontOfSize:13] forKey:NSFontAttributeName];
    offsetLeft += 4;
    [@"今日" drawAtPoint:CGPointMake(offsetLeft, offsetTop - 8) withAttributes:attr];
    
    offsetLeft += 40;
    CGContextSetLineWidth(ctx, 1);
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithHexString:@"c3bbf8"].CGColor);
    CGContextMoveToPoint(ctx, offsetLeft, offsetTop);
    offsetLeft += 22;
    CGContextAddLineToPoint(ctx, offsetLeft, offsetTop);
    CGContextStrokePath(ctx);
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithHexString:@"c3bbf8"].CGColor);
    CGContextFillEllipseInRect(ctx, CGRectMake(offsetLeft - 11 - 2, offsetTop - 2, 4, 4));
    
    [attr setValue:[UIFont systemFontOfSize:13] forKey:NSFontAttributeName];
    offsetLeft += 4;
    [@"昨日" drawAtPoint:CGPointMake(offsetLeft, offsetTop - 8) withAttributes:attr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

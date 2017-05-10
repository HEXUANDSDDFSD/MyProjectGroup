//
//  TYSXClientViewController.m
//  tysx
//
//  Created by zwc on 14/12/10.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "TYSXClientViewController.h"
#import "MEDragSegmentedControl.h"
#import "HXCorePlot.h"
#import "MESegmentedControl.h"
#import "TYSXClientCtr.h"

#define kMyYellowColor [UIColor colorWithRed:255/255.0 green:188/255.0 blue:42/255.0 alpha:1.0]

@interface TYSXClientViewController ()<HXCoreplotXAxisDataSource, HXCorePlotYAxisDataSource, HXBaseDataSource, HXHeapBarPlotDataSource, HXCorePlotControlDelegate>

@end

@implementation TYSXClientViewController {
    HXCorePlotControl *topPlot;
    HXCorePlotControl *bottomLeftPlot;
    HXCorePlotControl *bottomRightPlot;
    MESegmentedControl *segmentedControl;
    MEDragSegmentedControl *horizonalSeg;
    UIScrollView *scrollView;
    UIButton *chooseButton;
    TYSXClientCtr *clientCtr;
}

+ (CacheType)cacheType {
    return CacheType_Once;
}

+ (Class)cachePlotCtr {
    return [TYSXClientCtr class];
}

- (id)initWithPlotName:(NSString *)_plotName {
    if (self = [super initWithPlotName:_plotName]) {
        clientCtr = (TYSXClientCtr *)cachePlotCtr;
    }
    return self;
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
    topPlot.xAxis.dataSource = self;
    topPlot.yAxis.dataSource = self;
    topPlot.delegate = self;
    topPlot.titleLocation = TitleLocation_Top;
    topPlot.titleOffset = -45;
    topPlot.layerManager.paddingTop = 50;
    topPlot.layerManager.paddingLeft = 50;
    topPlot.layerManager.maxValue = 20;
    topPlot.layerManager.insetLeft = 50;
    topPlot.layerManager.insetRight = 50;
    topPlot.legendOriginPoint = CGPointMake(50, 20);
    [self.view addSubview:topPlot];
    
    HXHeapBarPlot *topLoginHeap = [HXHeapBarPlot layer];
    topLoginHeap.dataSource = self;
    topLoginHeap.needShowValue = YES;
    topLoginHeap.plotName = @"login";
    topLoginHeap.beginPosition = 0.2;
    topLoginHeap.endPosition = 0.5;
    [topPlot addPlot:topLoginHeap];
    
    HXHeapBarPlot *topPlayHeap = [HXHeapBarPlot layer];
    topPlayHeap.plotName = @"play";
    topPlayHeap.needShowValue = YES;
    topPlayHeap.dataSource = self;
    topPlayHeap.beginPosition = 0.5;
    topPlayHeap.endPosition = 0.8;
    [topPlot addPlot:topPlayHeap];
    
    HXLinePlot *topLinePlot = [HXLinePlot layer];
    topLinePlot.dataSource = self;
    topLinePlot.plotName = @"top";
    topLinePlot.lineWidth = 1;
    topLinePlot.lineColor = [UIColor colorWithHexString:@"a89d97"];
    [topPlot addPlot:topLinePlot];
    
    HXLegendInfo *one = [[HXLegendInfo alloc] init];
    one.legendTitle = @"登录";
    one.color = [UIColor colorWithHexString:@"aba2f0"];
    HXLegendInfo *two = [[HXLegendInfo alloc] init];
    two.legendTitle = @"播放";
    two.color = [UIColor colorWithHexString:@"7ee4ed"];
    HXLegendInfo *three = [[HXLegendInfo alloc] init];
    three.legendTitle = @"转化率";
    three.fillHeight = 1;
    three.fillWidth = 30;
    three.color = [UIColor colorWithHexString:@"a89d97"];
    topPlot.legendList = @[one, two, three];
    
    {
        bottomRightPlot = [[HXCorePlotControl alloc] initWithFrame:CGRectMake(0, topPlot.y + topPlot.height, kScreenHeight / 2, kScreenWidth - topPlot.y - topPlot.height)];
        bottomRightPlot.xAxis.dataSource = self;
        bottomRightPlot.yAxis.dataSource = self;
        bottomRightPlot.layerManager.paddingLeft = 50;
        bottomRightPlot.xAxis.numberOfSubline = 24;
        bottomRightPlot.yAxis.numberOfSubline = 3;
            bottomRightPlot.yAxis.sublineColor = bottomRightPlot.xAxis.sublineColor = [UIColor colorWithHexString:@"e5e5e5"];
        bottomRightPlot.layerManager.paddingTop = 70;
        bottomRightPlot.layerManager.insetLeft = 30;
        bottomRightPlot.layerManager.insetRight = 30;
        [self.view addSubview:bottomRightPlot];
        
        CGFloat maxValue = clientCtr.realYesterdayData.maxFloatValue;
        if (maxValue < clientCtr.realTodayData.maxFloatValue) {
            maxValue = clientCtr.realTodayData.maxFloatValue;
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
    

    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self changeValueAction:segmentedControl];
}

- (void)refreshAllView {
    [bgDrawView setNeedsDisplay];
    [topPlot reloadData];
    CGFloat maxValue = 0;
    
    if (segmentedControl.selectedIndex == 0) {
        maxValue = clientCtr.loginData.maxFloatValue;
        if (maxValue < clientCtr.playData.maxFloatValue) {
            maxValue = clientCtr.playData.maxFloatValue;
        }
        topPlot.layerManager.maxValue = maxValue;
        topPlot.layerManager.rightMaxValue = clientCtr.conversionRateData.maxFloatValue;
        
        if ([clientCtr.chooseTitleList count] > 0) {
            [chooseButton setTitle:clientCtr.chooseTitleList[0] forState:UIControlStateNormal];
        }
    }
    else {
        topPlot.layerManager.maxValue = clientCtr.orderData.maxFloatValue;
    }
    maxValue = clientCtr.realTodayData.maxFloatValue;
    if (maxValue < clientCtr.realYesterdayData.maxFloatValue) {
        maxValue = clientCtr.realYesterdayData.maxFloatValue;
    }
    
    bottomRightPlot.layerManager.maxValue = maxValue;
    [bottomRightPlot reloadData];
    
    for (HXLinePlot *plot in bottomRightPlot.plotLayers) {
        if ([plot isKindOfClass:[HXLinePlot class]] && [plot.plotName isEqualToString:@"today"]) {
            plot.showLimitNum = clientCtr.maxHour;
        }
    }
}

- (NSInteger)numberOfNeedTouchDegreeCorePlotControl:(HXCorePlotControl *)corePlotControl {
    return 9;
}
- (void)corePlotControl:(HXCorePlotControl *)corePlotControl touchIndex:(NSInteger)index {
    clientCtr.selecteTopTenIndex = index;
    [bgDrawView setNeedsDisplay];
}

- (NSInteger)numberOfTitleInXAxis:(HXCoreplotXAxisLayer *)xAxis {
    if ([bottomRightPlot.xAxis isEqual:xAxis]) {
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
                maxValue = clientCtr.conversionRateData.maxFloatValue;
            }
            else {
                maxValue = clientCtr.loginData.maxFloatValue;
                if (maxValue < clientCtr.playData.maxFloatValue) {
                    maxValue = clientCtr.playData.maxFloatValue;
                }
            }
        }
        else {
            maxValue = clientCtr.orderData.maxFloatValue;
        }
    }
    else if ([bottomRightPlot.yAxis isEqual:yAxis]) {
        maxValue = clientCtr.realYesterdayData.maxFloatValue;
        if (maxValue < clientCtr.realTodayData.maxFloatValue) {
            maxValue = clientCtr.realTodayData.maxFloatValue;
        }
    }
    else {
        maxValue = clientCtr.playNumData.maxFloatValue;
        if (maxValue < clientCtr.playUserData.maxFloatValue) {
            maxValue = clientCtr.playUserData.maxFloatValue;
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
        return clientCtr.conversionRateData[index];
    }
    else if([plot.plotName isEqualToString:@"today"]) {
        return clientCtr.realTodayData[index];
    }
    else {
        return clientCtr.realYesterdayData[index];
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
        return clientCtr.loginData[xIndex];
    }
    else if ([heapBarPlot.plotName isEqualToString:@"play"]) {
            return clientCtr.playData[xIndex];
    }
    else if ([heapBarPlot.plotName isEqualToString:@"order"]) {
       return clientCtr.orderData[xIndex];
    }
    else if ([heapBarPlot.plotName isEqualToString:@"play_num"]) {
        return clientCtr.playNumData[xIndex];
    }
    else {
        return clientCtr.playUserData[xIndex];
    }
    return @14;
}

- (UIColor *)heapBarPlot:(HXHeapBarPlot *)heapBarPlot colorOfHeapIndex:(NSInteger)heapIndex {
    UIColor *ret = nil;
    if ([heapBarPlot.plotName isEqualToString:@"login"] || [heapBarPlot.plotName isEqualToString:@"order"]) {
        ret = [UIColor colorWithHexString:@"aba2f0"];
    }
    else if ([heapBarPlot.plotName isEqualToString:@"play"]) {
        ret = [UIColor colorWithHexString:@"7ee4ed"];
    }
    else if ([heapBarPlot.plotName isEqualToString:@"play_num"]) {
        ret = [UIColor colorWithHexString:@"87BCEB"];
    }
    else {
        ret = [UIColor colorWithHexString:@"A8D6FF"];
    }
    return ret;
}

- (void)contentView:(MYDrawContentView *)view drawRect:(CGRect)rect {
    [super contentView:view drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithHexString:@"fafafa"].CGColor);
    CGContextFillRect(ctx, CGRectMake(0, topPlot.y + topPlot.height, kScreenHeight, kScreenWidth - topPlot.y - topPlot.height));
    
    if (segmentedControl.selectedIndex == 1) {
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
        [[clientCtr dataStrListWithDayNumber:9][clientCtr.selecteTopTenIndex] drawAtPoint:CGPointMake(offsetLeft, offsetTop) withAttributes:attr];
        
        [attr setValue:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName];
        
        NSMutableParagraphStyle *para = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        para.alignment = NSTextAlignmentRight;
        para.lineBreakMode = NSLineBreakByTruncatingTail;
        [attr setValue:para forKey:NSParagraphStyleAttributeName];
        
        offsetTop += 60;
        CGContextSetFillColorWithColor(ctx, [UIColor colorWithHexString:@"ACDBFE"].CGColor);
        CGContextFillRect(ctx, CGRectMake(offsetLeft + itemWidth + 3, offsetTop - 5, 7, 25 * 10));
        
        CGContextSetFillColorWithColor(ctx, [UIColor colorWithHexString:@"8EBCE0"].CGColor);
        
        CGFloat maxDrawWidth = 300;
        CGFloat maxValue = [clientCtr.topTenData[0] intValue];
        for (int i = 0; i < 10; i++) {
            CGFloat drawWidth = 0;
            if (maxValue != 0) {
                drawWidth = [clientCtr.topTenData[i] intValue] / maxValue * maxDrawWidth;
                [clientCtr.topTenNameList[i] drawInRect:CGRectMake(offsetLeft, offsetTop, itemWidth, 16) withAttributes:attr];
                CGContextFillRect(ctx, CGRectMake(offsetLeft + itemWidth + 10, offsetTop, drawWidth, 17));
            }
            offsetTop += 25;
        }
    }
    
    CGFloat offsetLeft = 20;
    CGFloat offsetTop = topPlot.y + topPlot.height + 10;
    
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
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

- (void)changeDragValue:(MEDragSegmentedControl *)sender {
    [bgDrawView setNeedsDisplay];
}

- (void)changeValueAction:(MESegmentedControl *)sender {
    clientCtr.selectedMainType = (int)sender.selectedIndex;
        [topPlot removeAllPlot];
    if (sender.selectedIndex == 0) {
        [horizonalSeg removeFromSuperview];
        topPlot.title = @"登录及播放转化率趋势图";
        if (kNeedVirtualData) {
            topPlot.title = @"图标名称";
        }
            topPlot.yAxis.needRightYAxis = YES;
        
        CGFloat maxValue = clientCtr.loginData.maxFloatValue;
        if (maxValue < clientCtr.playData.maxFloatValue) {
            maxValue = clientCtr.playData.maxFloatValue;
        }
        topPlot.layerManager.maxValue = maxValue;
        
        topPlot.layerManager.rightMaxValue = clientCtr.conversionRateData.maxFloatValue;
        
        HXHeapBarPlot *topLoginHeap = [HXHeapBarPlot layer];
        topLoginHeap.dataSource = self;
        topLoginHeap.needShowValue = YES;
        topLoginHeap.plotName = @"login";
        topLoginHeap.beginPosition = 0.2;
        topLoginHeap.endPosition = 0.5;
        [topPlot addPlot:topLoginHeap];
        
        HXHeapBarPlot *topPlayHeap = [HXHeapBarPlot layer];
        topPlayHeap.plotName = @"play";
        topPlayHeap.needShowValue = YES;
        topPlayHeap.dataSource = self;
        topPlayHeap.beginPosition = 0.5;
        topPlayHeap.endPosition = 0.8;
        [topPlot addPlot:topPlayHeap];
        
        HXLinePlot *topLinePlot = [HXLinePlot layer];
        topLinePlot.dataSource = self;
        topLinePlot.plotName = @"top";
        topLinePlot.showLimitNum = 8;
        topLinePlot.isUseRightAxisY = YES;
        topLinePlot.lineWidth = 1;
        topLinePlot.lineColor = [UIColor colorWithHexString:@"a89d97"];
        [topPlot addPlot:topLinePlot];
        
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
            two.legendTitle = @"条目三";
        }
        three.fillHeight = 1;
        three.fillWidth = 30;
        three.color = [UIColor colorWithHexString:@"a89d97"];
        topPlot.legendList = @[one, two, three];
        
        {
        bottomLeftPlot = [[HXCorePlotControl alloc] initWithFrame:CGRectMake(kScreenHeight / 2, topPlot.y + topPlot.height, kScreenHeight / 2, kScreenWidth - topPlot.y - topPlot.height)];
            
            CGFloat maxValue = clientCtr.playNumData.maxFloatValue;
            if (maxValue < clientCtr.playUserData.maxFloatValue) {
                maxValue = clientCtr.playUserData.maxFloatValue;
            }
            
            bottomLeftPlot.layerManager.maxValue = maxValue;
            bottomLeftPlot.xAxis.dataSource = self;
            bottomLeftPlot.yAxis.dataSource = self;
            bottomLeftPlot.layerManager.insetLeft = 30;
            bottomLeftPlot.layerManager.insetRight = 30;
            bottomLeftPlot.layerManager.paddingTop = 80;

            
            HXLegendInfo *one = [[HXLegendInfo alloc] init];
            one.color = [UIColor colorWithHexString:@"87BCEB"];
            one.legendTitle = @"播放量";
            if (kNeedVirtualData) {
                one.legendTitle = @"条目一";
            }
            
            HXLegendInfo *two = [[HXLegendInfo alloc] init];
            two.color = [UIColor colorWithHexString:@"A8D6FF"];
            two.legendTitle = @"播放用户数";
            if (kNeedVirtualData) {
                two.legendTitle = @"条目二";
            }
            
            bottomLeftPlot.legendList = @[one,two];
            bottomLeftPlot.legendOriginPoint = CGPointMake(30, 70);

            chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
            chooseButton.frame = CGRectMake(30, 10, 300, 32);
            chooseButton.titleLabel.font = [UIFont systemFontOfSize:15];
            chooseButton.layer.cornerRadius = 3;
            chooseButton.layer.borderColor = [UIColor colorWithHexString:@"333333"].CGColor;
            [chooseButton setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
            [chooseButton addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];
            chooseButton.titleLabel.textAlignment = NSTextAlignmentLeft;
            
            HXHeapBarPlot *topLoginHeap = [HXHeapBarPlot layer];
            topLoginHeap.dataSource = self;
            topLoginHeap.plotName = @"play_num";
            topLoginHeap.beginPosition = 0.2;
            topLoginHeap.endPosition = 0.5;
            [bottomLeftPlot addPlot:topLoginHeap];
            
            HXHeapBarPlot *topPlayHeap = [HXHeapBarPlot layer];
            topPlayHeap.plotName = @"play_user";
            topPlayHeap.dataSource = self;
            topPlayHeap.beginPosition = 0.5;
            topPlayHeap.endPosition = 0.8;
            [bottomLeftPlot addPlot:topPlayHeap];
            
            if ([clientCtr.chooseTitleList count] > 0) {
                [chooseButton setTitle:clientCtr.chooseTitleList[0] forState:UIControlStateNormal];
            }
            chooseButton.layer.borderWidth = 1;
            [bottomLeftPlot addSubview:chooseButton];
            
            [self.view addSubview:bottomLeftPlot];
        }
    }
    else {
        topPlot.title = @"订购统计图";
        if (kNeedVirtualData) {
            topPlot.title = @"图标名称";
        }
        topPlot.yAxis.needRightYAxis = NO;
                topPlot.layerManager.maxValue = clientCtr.orderData.maxFloatValue;
        
        HXHeapBarPlot *topLoginHeap = [HXHeapBarPlot layer];
        topLoginHeap.needShowValue = YES;
        topLoginHeap.dataSource = self;
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
        
        [bottomLeftPlot removeFromSuperview];
        bottomLeftPlot = nil;
        
        horizonalSeg = [[MEDragSegmentedControl alloc] initWithFrame:CGRectMake(kScreenHeight / 2 + 100, topPlot.y + topPlot.height + 30, 340, 60)];
        horizonalSeg.orientation = ShowOrientation_Horizonal;
        [horizonalSeg addTarget:self action:@selector(changeLeftValue:) forControlEvents:UIControlEventValueChanged];
        horizonalSeg.itemTitles = @[@"产品", @"渠道", @"节目", @"CP"];
        if (kNeedVirtualData) {
            horizonalSeg.itemTitles = @[@"项目一", @"项目二", @"项目三", @"项目四"];
        }
        [self.view addSubview:horizonalSeg];
    }
    [topPlot reloadData];
    [bgDrawView setNeedsDisplay];
    
    CGFloat maxValue = clientCtr.realTodayData.maxFloatValue;
    if (maxValue < clientCtr.realYesterdayData.maxFloatValue) {
        maxValue = clientCtr.realYesterdayData.maxFloatValue;
    }
    
    bottomRightPlot.layerManager.maxValue = maxValue;
    [bottomRightPlot reloadData];
    
    for (HXLinePlot *plot in bottomRightPlot.plotLayers) {
        if ([plot isKindOfClass:[HXLinePlot class]] && [plot.plotName isEqualToString:@"today"]) {
            plot.showLimitNum = clientCtr.maxHour;
        }
    }
}

- (void)chooseAction:(UIButton *)sender {
    if (sender.selected) {
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(sender.frame.origin.x, sender.y + sender.height, sender.width, 100)];
        scrollView.layer.borderWidth = 1;
        scrollView.layer.borderColor = [UIColor grayColor].CGColor;
        scrollView.backgroundColor = [UIColor whiteColor];
        [bottomLeftPlot addSubview:scrollView];
        
        CGFloat everyHeight = 38;
        CGFloat offsetTop = 0;
        for (int i = 0; i < [clientCtr.chooseTitleList count]; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, offsetTop, scrollView.width, everyHeight);
            offsetTop += everyHeight;
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            button.tag = i;
            [button addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:clientCtr.chooseTitleList[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
            [scrollView addSubview:button];
            scrollView.contentSize = CGSizeMake(scrollView.width, offsetTop);
        }
    }
    else {
        [scrollView removeFromSuperview];
        scrollView = nil;
    }
    sender.selected = !sender.selected;
}

- (void)selectAction:(UIButton *)sender {
    clientCtr.selectedPlayType = (int)sender.tag;
    
    CGFloat maxValue = clientCtr.playNumData.maxFloatValue;
    if (maxValue < clientCtr.playUserData.maxFloatValue) {
        maxValue = clientCtr.playUserData.maxFloatValue;
    }
    
    bottomLeftPlot.layerManager.maxValue = maxValue;
    
    [scrollView removeFromSuperview];
    scrollView = nil;
    chooseButton.selected = NO;
    [chooseButton setTitle:sender.titleLabel.text forState:UIControlStateNormal];
    [bottomLeftPlot reloadData];
}

- (void)changeLeftValue:(MEDragSegmentedControl *)sender {
    clientCtr.selectedTopTenType = (int)sender.selectedIndex;
    [bgDrawView setNeedsDisplay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

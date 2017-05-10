//
//  TYSXKeyProductPackageViewController.m
//  tysx
//
//  Created by zwc on 14/12/16.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "TYSXKeyProductPackageViewController.h"
#import "MEDragSegmentedControl.h"
#import "HXCorePlot.h"
#import "NSDate+Normal.h"
#import "TYSXKeyPackageCtr.h"

@interface TYSXKeyProductPackageViewController ()<HXHeapBarPlotDataSource, HXBaseDataSource, HXCoreplotXAxisDataSource, HXCorePlotYAxisDataSource>

@end

@implementation TYSXKeyProductPackageViewController {
    HXCorePlotControl *sumPlot;
    HXCorePlotControl *naturalPlot;
    HXCorePlotControl *extendPlot;
    MEDragSegmentedControl *dragSegmentedControl;
    TYSXKeyPackageCtr *keyCtr;
}

- (id)initWithPlotName:(NSString *)_plotName {
    if (self = [super initWithPlotName:_plotName]) {
        keyCtr = (TYSXKeyPackageCtr *)cachePlotCtr;
    }
    return self;
}

+ (Class)cachePlotCtr {
    return [TYSXKeyPackageCtr class];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    {
        sumPlot = [[HXCorePlotControl alloc] initWithFrame:CGRectMake(0, 70, kScreenHeight - 150, 230)];
        sumPlot.legendOriginPoint = CGPointMake(400, 20);
        sumPlot.titleOffset = 24;
        sumPlot.layerManager.paddingBottom = 50;
        sumPlot.layerManager.paddingTop = 50;
        sumPlot.layerManager.paddingLeft = 50;
        sumPlot.xAxis.dataSource = self;
        sumPlot.yAxis.dataSource = self;
        sumPlot.layerManager.insetLeft = 50;
        sumPlot.layerManager.insetRight = 50;
        sumPlot.layerManager.maxValue = 20;
        [self.view addSubview:sumPlot];
        
        HXHeapBarPlot *heapPlot = [HXHeapBarPlot layer];
        heapPlot.dataSource = self;
        heapPlot.plotName = @"left";
        heapPlot.beginPosition = 0.25;
        heapPlot.endPosition = 0.5;
        [sumPlot addPlot:heapPlot];
        
        HXHeapBarPlot *rightHeapPlot = [HXHeapBarPlot layer];
        rightHeapPlot.dataSource = self;
        rightHeapPlot.beginPosition = 0.5;
        rightHeapPlot.endPosition = 0.75;
        [sumPlot addPlot:rightHeapPlot];
        
        
//        HXLinePlot *linePlot = [HXLinePlot layer];
//        linePlot.lineColor = [UIColor colorWithRed:40/255.0 green:254/255.0 blue:99/255.0 alpha:1.0];
//        linePlot.lineWidth = 2;
//        linePlot.dataSource = self;
//        [sumPlot addPlot:linePlot];
        
        HXLegendInfo *one = [[HXLegendInfo alloc] init];
        one.color = [UIColor colorWithHexString:@"FF705F"];
        one.legendTitle = @"订购门户自然";
        if (kNeedVirtualData) {
            one.legendTitle = @"条目一";
        }
        
        HXLegendInfo *two = [[HXLegendInfo alloc] init];
        two.color = [UIColor colorWithHexString:@"fca89e"];
        two.legendTitle = @"订购合作推广";
        if (kNeedVirtualData) {
            two.legendTitle = @"条目二";
        }
        
        HXLegendInfo *three = [[HXLegendInfo alloc] init];
        three.color = [UIColor colorWithHexString:@"73c3ff"];
        three.legendTitle = @"退订门户自然";
        if (kNeedVirtualData) {
            three.legendTitle = @"条目三";
        }
        
        HXLegendInfo *four = [[HXLegendInfo alloc] init];
        four.color = [UIColor colorWithHexString:@"b2deff"];
        four.legendTitle = @"退订合作推广";
        if (kNeedVirtualData) {
            four.legendTitle = @"条目四";
        }
        
        sumPlot.legendList = @[one, two, three, four];
    }
    
    {
        naturalPlot = [[HXCorePlotControl alloc] initWithFrame:CGRectMake(0, sumPlot.y + sumPlot.height, sumPlot.width / 2, 200)];
        naturalPlot.xAxis.dataSource = self;
        naturalPlot.yAxis.dataSource = self;
        naturalPlot.titleOffset = 24;
        naturalPlot.xAxis.offsetLeft = 20;
        naturalPlot.xAxis.offsetRight = 20;
        naturalPlot.layerManager.insetRight = 20;
        naturalPlot.layerManager.insetLeft = 20;
        naturalPlot.layerManager.paddingBottom = 50;
        naturalPlot.layerManager.paddingLeft = 50;
        naturalPlot.layerManager.maxValue = 20;
        naturalPlot.legendOriginPoint = CGPointMake(30, 10);
        naturalPlot.title = @"门户自然";
        if (kNeedVirtualData) {
            naturalPlot.title = @"图标名称";
        }
        [self.view addSubview:naturalPlot];
        
        HXLinePlot *linePlot = [HXLinePlot layer];
        linePlot.plotName = @"left_n";
        linePlot.lineColor = [UIColor colorWithHexString:@"FF705F"];
        linePlot.lineWidth = 2;
        linePlot.dataSource = self;
        [naturalPlot addPlot:linePlot];
        
        HXLinePlot *elinePlot = [HXLinePlot layer];
        elinePlot.plotName = @"left_e";
        elinePlot.lineColor = [UIColor colorWithHexString:@"73c3ff"];
        elinePlot.lineWidth = 2;
        elinePlot.dataSource = self;
        [naturalPlot addPlot:elinePlot];
        
        HXLegendInfo *one = [[HXLegendInfo alloc] init];
        one.legendTitle = @"订购";
        if (kNeedVirtualData) {
            one.legendTitle = @"条目一";
        }
        one.color = [UIColor colorWithHexString:@"FF705F"];
        one.fillWidth = 15;
        one.fillHeight = 2;
        
        HXLegendInfo *two = [[HXLegendInfo alloc] init];
        two.legendTitle = @"退订";
        if (kNeedVirtualData) {
            two.legendTitle = @"条目二";
        }
        two.fillWidth = 15;
        two.color = [UIColor colorWithHexString:@"73c3ff"];
        two.fillHeight = 2;
        naturalPlot.legendList = @[one, two];
    }
    
    
    {
        extendPlot = [[HXCorePlotControl alloc] initWithFrame:CGRectMake(naturalPlot.x + naturalPlot.width, naturalPlot.y, naturalPlot.width, naturalPlot.height)];
        extendPlot.xAxis.dataSource = self;
        extendPlot.yAxis.dataSource = self;
        extendPlot.xAxis.offsetLeft = 20;
        extendPlot.xAxis.offsetRight = 20;
        extendPlot.layerManager.insetRight = 20;
        extendPlot.layerManager.insetLeft = 20;
        extendPlot.titleOffset = 24;
        extendPlot.layerManager.paddingBottom = 50;
        extendPlot.layerManager.maxValue = 20;
        extendPlot.title = @"合作推广";
        if (kNeedVirtualData) {
            extendPlot.title = @"图标名称";
        }
        extendPlot.legendOriginPoint = CGPointMake(30, 10);
        [self.view addSubview:extendPlot];
        
        HXLinePlot *linePlot = [HXLinePlot layer];
        linePlot.lineColor = [UIColor colorWithHexString:@"fca89e"];
        linePlot.plotName = @"right_n";
        linePlot.lineWidth = 2;
        linePlot.dataSource = self;
        [extendPlot addPlot:linePlot];
        
        HXLinePlot *elinePlot = [HXLinePlot layer];
        elinePlot.plotName = @"right_e";
        elinePlot.lineColor = [UIColor colorWithHexString:@"b2deff"];
        elinePlot.lineWidth = 2;
        elinePlot.dataSource = self;
        [extendPlot addPlot:elinePlot];
        
        HXLegendInfo *one = [[HXLegendInfo alloc] init];
        one.legendTitle = @"订购";
        if (kNeedVirtualData) {
            one.legendTitle = @"条目一";
        }
        one.color = [UIColor colorWithHexString:@"fca89e"];
        one.fillWidth = 15;
        one.fillHeight = 2;
        
        HXLegendInfo *two = [[HXLegendInfo alloc] init];
        two.legendTitle = @"退订";
        if (kNeedVirtualData) {
            two.legendTitle = @"条目二";
        }
        two.fillWidth = 15;
        two.color = [UIColor colorWithHexString:@"b2deff"];
        two.fillHeight = 2;
        extendPlot.legendList = @[one, two];
    }
    
    dragSegmentedControl = [[MEDragSegmentedControl alloc] initWithFrame:CGRectMake(kScreenHeight - 150, 327, 150, 304)];
    [dragSegmentedControl addTarget:self action:@selector(changeValueAction:) forControlEvents:UIControlEventValueChanged];
    dragSegmentedControl.itemTitles = @[@"VIP会员",@"随心看", @"数字影院", @"股票老左精简版"];
    if (kNeedVirtualData) {
        dragSegmentedControl.itemTitles = @[@"项目一",@"项目二", @"项目三", @"项目四"];
    }
    [self.view addSubview:dragSegmentedControl];
    
    [self changeValueAction:dragSegmentedControl];
    
    sumPlot.title = dragSegmentedControl.selectedTitle;
    // Do any additional setup after loading the view.
}

- (void)refreshAllView {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0; i < 8; i++) {
        CGFloat sumValue = 0;
        sumValue += [keyCtr.naturalOrderData[i] intValue];
        sumValue += [keyCtr.extendOrderData[i] intValue];
        [tempArray addObject:[NSNumber numberWithInt:sumValue]];
    }
    CGFloat maxValue = tempArray.maxFloatValue;
    [tempArray removeAllObjects];
    for (int i = 0; i < 8; i++) {
        CGFloat sumValue = 0;
        sumValue += [keyCtr.naturalUnData[i] intValue];
        sumValue += [keyCtr.extendUnData[i] intValue];
        [tempArray addObject:[NSNumber numberWithInt:sumValue]];
    }
    if (tempArray.maxFloatValue > maxValue) {
        maxValue = tempArray.maxFloatValue;
    }
    
    sumPlot.layerManager.maxValue = maxValue;
    
    maxValue = keyCtr.naturalOrderData.maxFloatValue;
    if (maxValue < keyCtr.naturalUnData.maxFloatValue) {
        maxValue = keyCtr.naturalUnData.maxFloatValue;
    }
    naturalPlot.layerManager.maxValue = maxValue;
    
    maxValue = keyCtr.extendOrderData.maxFloatValue;
    if (maxValue < keyCtr.extendUnData.maxFloatValue) {
        maxValue = keyCtr.extendUnData.maxFloatValue;
    }
    extendPlot.layerManager.maxValue = maxValue;
    
    [bgDrawView setNeedsDisplay];
    [sumPlot reloadData];
    [naturalPlot reloadData];
    [extendPlot reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfTitleInYAxis:(HXCorePlotYAxisLayer *)yAxis {
    return 4;
}
- (NSString *)yAxis:(HXCorePlotYAxisLayer *)yAxis titleAtIndex:(NSInteger)index isUseRightYAxis:(BOOL)isUseRight {
    if ([sumPlot.yAxis isEqual:yAxis]) {
        
        NSMutableArray *tempArray = [NSMutableArray array];
        for (int i = 0; i < 8; i++) {
            CGFloat sumValue = 0;
            sumValue += [keyCtr.naturalOrderData[i] intValue];
            sumValue += [keyCtr.extendOrderData[i] intValue];
            [tempArray addObject:[NSNumber numberWithInt:sumValue]];
        }
        CGFloat maxValue = tempArray.maxFloatValue;
        [tempArray removeAllObjects];
        for (int i = 0; i < 8; i++) {
            CGFloat sumValue = 0;
            sumValue += [keyCtr.naturalUnData[i] intValue];
            sumValue += [keyCtr.extendUnData[i] intValue];
            [tempArray addObject:[NSNumber numberWithInt:sumValue]];
        }
        if (tempArray.maxFloatValue > maxValue) {
            maxValue = tempArray.maxFloatValue;
        }
        
        return [NSString stringWithFormat:@"%.0f", maxValue - maxValue / 3 * index];
    }
    else if ([naturalPlot.yAxis isEqual:yAxis]) {
        CGFloat maxValue = keyCtr.naturalOrderData.maxFloatValue;
        if (maxValue < keyCtr.naturalUnData.maxFloatValue) {
            maxValue = keyCtr.naturalUnData.maxFloatValue;
        }
        return [NSString stringWithFormat:@"%.0f", maxValue - maxValue / 3 * index];
    }
    else {
        CGFloat maxValue = keyCtr.extendOrderData.maxFloatValue;
        if (maxValue < keyCtr.extendUnData.maxFloatValue) {
            maxValue = keyCtr.extendUnData.maxFloatValue;
        }
        return [NSString stringWithFormat:@"%.0f", maxValue - maxValue / 3 * index];
    }
    return @"";
}

- (NSInteger)numberOfTitleInXAxis:(HXCoreplotXAxisLayer *)xAxis {
    return 8;
}
- (NSString *)xAxis:(HXCoreplotXAxisLayer *)xAxis titleAtIndex:(NSInteger)index {
    if ([sumPlot.xAxis isEqual:xAxis]) {
        return [cachePlotCtr dataStrListWithDayNumber:8][index];
    }
    return [[cachePlotCtr dataStrListWithDayNumber:8][index] substringFromIndex:5];
}

- (NSInteger)numberOfPlot:(HXBasePlot *)plot {
    return 8;
}

- (NSNumber *)plot:(HXBasePlot *)plot index:(NSInteger)index {
    if ([plot.plotName isEqualToString:@"left_n"]) {
        return keyCtr.naturalOrderData[index];
    }
    else if ([plot.plotName isEqualToString:@"left_e"]) {
        return keyCtr.naturalUnData[index];
    }
    else if ([plot.plotName isEqualToString:@"right_n"]) {
        return keyCtr.extendOrderData[index];
    }
    else {
        return keyCtr.extendUnData[index];
    }
}

- (NSInteger)numberOfXValuesInHeapBarPlot:(HXHeapBarPlot *)heapBarPlot {
    return 8;
}

- (NSInteger)numberOfHeapBarInHeapBarPlot:(HXHeapBarPlot *)heapBarPlot {
    return 2;
}

- (NSNumber *)heapBarPlot:(HXHeapBarPlot *)heapBarPlot valueOfXIndex:(NSInteger)xIndex heapIndex:(NSInteger)heapIndex {
    if ([heapBarPlot.plotName isEqualToString:@"left"]) {
        if (heapIndex == 0) {
            return keyCtr.naturalOrderData[xIndex];
        }
        else {
            return keyCtr.extendOrderData[xIndex];
        }
    }
    else {
        if (heapIndex == 0) {
            return keyCtr.naturalUnData[xIndex];
        }
        else {
            return keyCtr.extendUnData[xIndex];
        }
    }
}

- (UIColor *)heapBarPlot:(HXHeapBarPlot *)heapBarPlot colorOfHeapIndex:(NSInteger)heapIndex {
    UIColor *ret = nil;
    if ([heapBarPlot.plotName isEqualToString:@"left"]) {
        switch (heapIndex) {
            case 0:
                ret = [UIColor colorWithHexString:@"FF705F"];
                break;
            case 1:
                ret = [UIColor colorWithHexString:@"fca89e"];
                break;
            default:
                break;
        }
    }
    else {
        switch (heapIndex) {
            case 0:
                ret = [UIColor colorWithHexString:@"73c3ff"];
                break;
            case 1:
                ret = [UIColor colorWithHexString:@"b2deff"];
                break;
            default:
                break;
        }
    }
    return ret;
}

- (void)changeValueAction:(MEDragSegmentedControl *)sender {
    keyCtr.selectedType = sender.selectedIndex;
    
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0; i < 8; i++) {
        CGFloat sumValue = 0;
        sumValue += [keyCtr.naturalOrderData[i] intValue];
        sumValue += [keyCtr.extendOrderData[i] intValue];
        [tempArray addObject:[NSNumber numberWithInt:sumValue]];
    }
    CGFloat maxValue = tempArray.maxFloatValue;
    [tempArray removeAllObjects];
    for (int i = 0; i < 8; i++) {
        CGFloat sumValue = 0;
        sumValue += [keyCtr.naturalUnData[i] intValue];
        sumValue += [keyCtr.extendUnData[i] intValue];
        [tempArray addObject:[NSNumber numberWithInt:sumValue]];
    }
    if (tempArray.maxFloatValue > maxValue) {
        maxValue = tempArray.maxFloatValue;
    }

    sumPlot.layerManager.maxValue = maxValue;
    
    maxValue = keyCtr.naturalOrderData.maxFloatValue;
    if (maxValue < keyCtr.naturalUnData.maxFloatValue) {
        maxValue = keyCtr.naturalUnData.maxFloatValue;
    }
    naturalPlot.layerManager.maxValue = maxValue;
    
    maxValue = keyCtr.extendOrderData.maxFloatValue;
    if (maxValue < keyCtr.extendUnData.maxFloatValue) {
        maxValue = keyCtr.extendUnData.maxFloatValue;
    }
    extendPlot.layerManager.maxValue = maxValue;
    
    [bgDrawView setNeedsDisplay];
        sumPlot.title = dragSegmentedControl.selectedTitle;
    [sumPlot reloadData];
    [naturalPlot reloadData];
    [extendPlot reloadData];
}

- (void)contentView:(MYDrawContentView *)view drawRect:(CGRect)rect {
    [super contentView:view drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithHexString:@"f5f5f5"].CGColor);
    CGContextFillRect(ctx, CGRectMake(kScreenHeight - 150, 50, 150, kScreenWidth - 50));
    
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithHexString:@"fafafa"].CGColor);
    CGContextFillRect(ctx, CGRectMake(0, rect.size.height - 237, rect.size.width - 150, 237));
    
    CGFloat offsetTop = rect.size.height - 237;
    CGFloat offsetLeft = 212;
    
    CGContextMoveToPoint(ctx, 0, offsetTop);
    CGContextAddLineToPoint(ctx, rect.size.width - 150, offsetTop);
    
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    [attr setValue:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName];
    [attr setValue:[UIColor colorWithHexString:@"a0a0a0"] forKey:NSForegroundColorAttributeName];
    NSMutableParagraphStyle *para = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    para.alignment = NSTextAlignmentCenter;
    [attr setObject:para forKey:NSParagraphStyleAttributeName];
    
    NSDate *lastDate = [NSDate dateWithDateString:cachePlotCtr.lastDateStr format:@"yyyy-MM-dd"];
    for (int j = 0; j < 8; j++) {
        NSDate *date = [lastDate dateWithNumberOfDayBefore:8 - j - 1];
        NSString *dateStr = [date stringWithFormat:@"MM/dd"];
        [dateStr drawInRect:CGRectMake(offsetLeft + 65 * j, offsetTop + 5, 65, 20) withAttributes:attr];
        [date.weekStr drawInRect:CGRectMake(offsetLeft + 65 * j, offsetTop + 25, 65, 20) withAttributes:attr];
    }
    
    
    offsetTop += 50;
    CGContextMoveToPoint(ctx, 0, offsetTop);
    CGContextAddLineToPoint(ctx, rect.size.width - 150, offsetTop);
    
    NSMutableArray *titleArr = [@[@"门户自然", @"合作推广"] mutableCopy];
    if (kNeedVirtualData) {
        titleArr = [@[@"项目一", @"项目二"] mutableCopy];
    }
    [titleArr insertObject:dragSegmentedControl.selectedTitle atIndex:0];
    for (int i = 0; i < 6; i++) {
        [attr setValue:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName];
        
        NSArray *valueArray = nil;
        switch (i) {
            case 0:
                valueArray = keyCtr.sumOrderData;
                break;
            case 1:
                valueArray = keyCtr.sumUnData;
                break;
            case 2:
                valueArray = keyCtr.naturalOrderData;
                break;
            case 3:
                valueArray = keyCtr.naturalUnData;
                break;
            case 4:
                valueArray = keyCtr.extendOrderData;
                break;
            case 5:
                valueArray = keyCtr.extendUnData;
                break;
                
            default:
                break;
        }
        
        if (i % 2 == 0) {
            [attr setValue:[UIColor colorWithHexString:@"FF705F"] forKey:NSForegroundColorAttributeName];
        }
        else {
            [attr setValue:[UIColor colorWithHexString:@"73C3FF"] forKey:NSForegroundColorAttributeName];
        }
        for (int j = 0; j < 8; j++) {
            [[NSString stringWithFormat:@"%d", [valueArray[j] intValue]] drawInRect:CGRectMake(offsetLeft + 65 * j, offsetTop + 8, 65, 20) withAttributes:attr];
        }
        [attr setValue:[UIFont systemFontOfSize:16] forKey:NSFontAttributeName];
        offsetTop += 28;
        [attr setValue:[UIColor grayColor] forKey:NSForegroundColorAttributeName];
        if (i % 2 == 1) {
            [titleArr[i / 2] drawInRect:CGRectMake(0, offsetTop - 40, offsetLeft, 20) withAttributes:attr];
            CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithHexString:@"e0e0e0"].CGColor);
            CGContextMoveToPoint(ctx, 0, offsetTop);
            CGContextAddLineToPoint(ctx, rect.size.width - 150, offsetTop);
            
            CGContextMoveToPoint(ctx, offsetLeft, offsetTop - 28);
            CGContextAddLineToPoint(ctx, kScreenHeight  - 150, offsetTop - 28);
        }
    }
    
    for (int i = 0; i < 9; i++) {
        CGContextMoveToPoint(ctx, offsetLeft, offsetTop);
        CGContextAddLineToPoint(ctx, offsetLeft, rect.size.height - 237);
        offsetLeft += 65;
    }
    
    CGContextStrokePath(ctx);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

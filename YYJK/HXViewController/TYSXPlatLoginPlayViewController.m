//
//  TYSXPlatLoginPlayViewController.m
//  tysx
//
//  Created by zwc on 14/12/8.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "TYSXPlatLoginPlayViewController.h"
#import "MEDragSegmentedControl.h"
#import "HXCorePlot.h"
#import "TYSXPlatLoginPlayCtr.h"
#import "UIImage+Blend.h"

@interface TYSXPlatLoginPlayViewController ()<HXCoreplotXAxisDataSource, HXCorePlotYAxisDataSource, HXHeapBarPlotDataSource, HXBaseDataSource, HXCorePlotControlDelegate>

@end

@implementation TYSXPlatLoginPlayViewController {
    HXCorePlotControl *bottomCorePlotControl;
    HXCorePlotControl *topCorePlotControl;
    MEDragSegmentedControl *leftBottomSegControl;
    MEDragSegmentedControl *rightBottomSegControl;
    NSMutableArray *virtualData;
    UIView *floatView;
    NSInteger _selectIndex;
    TYSXPlatLoginPlayCtr *platCtr;
}

+ (Class)cachePlotCtr {
    return [TYSXPlatLoginPlayCtr class];
}

- (id)initWithPlotName:(NSString *)_plotName {
    if (self = [super initWithPlotName:_plotName]) {
        virtualData = [NSMutableArray array];
        platCtr = (TYSXPlatLoginPlayCtr *)cachePlotCtr;
    }
    return self;
}

- (NSDictionary *)provinceNameDic {
    NSDictionary *ret = [NSMutableDictionary dictionary];
    [ret setValue:@"云南" forKey:@"1001"];
    [ret setValue:@"内蒙古" forKey:@"1002"];
    [ret setValue:@"山西" forKey:@"1003"];
    [ret setValue:@"陕西" forKey:@"1004"];
    [ret setValue:@"上海" forKey:@"1005"];
    [ret setValue:@"北京" forKey:@"1006"];
    [ret setValue:@"吉林" forKey:@"1007"];
    [ret setValue:@"四川" forKey:@"1008"];
    [ret setValue:@"天津" forKey:@"1009"];
    [ret setValue:@"宁夏" forKey:@"1010"];
    [ret setValue:@"安徽" forKey:@"1011"];
    [ret setValue:@"山东" forKey:@"1012"];
    [ret setValue:@"广东" forKey:@"1013"];
    [ret setValue:@"广西" forKey:@"1014"];
    [ret setValue:@"新疆" forKey:@"1015"];
    [ret setValue:@"江苏" forKey:@"1016"];
    [ret setValue:@"江西" forKey:@"1017"];
    [ret setValue:@"河北" forKey:@"1018"];
    [ret setValue:@"河南" forKey:@"1019"];
    [ret setValue:@"浙江" forKey:@"1020"];
    [ret setValue:@"海南" forKey:@"1021"];
    [ret setValue:@"湖北" forKey:@"1022"];
    [ret setValue:@"湖南" forKey:@"1023"];
    [ret setValue:@"甘肃" forKey:@"1024"];
    [ret setValue:@"福建" forKey:@"1025"];
    [ret setValue:@"西藏" forKey:@"1026"];
    [ret setValue:@"贵州" forKey:@"1027"];
    [ret setValue:@"辽宁" forKey:@"1028"];
    [ret setValue:@"重庆" forKey:@"1029"];
    [ret setValue:@"青海" forKey:@"1030"];
    [ret setValue:@"黑龙江" forKey:@"1031"];
    return ret;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self refreshChinaMap];
    
    topCorePlotControl = [self heapControlWidthPlotName:@"top"];
    topCorePlotControl.yAxis.needRightYAxis = YES;
    topCorePlotControl.delegate = self;
    topCorePlotControl.frame = CGRectMake(0, 100, kScreenHeight, 286);
    topCorePlotControl.layerManager.paddingTop = 50;
    topCorePlotControl.layerManager.paddingRight = 80;
    topCorePlotControl.layerManager.insetLeft = 40;
    topCorePlotControl.layerManager.paddingLeft = 80;
    topCorePlotControl.xAxis.contentWidthScale = 2;
    topCorePlotControl.titleLocation = TitleLocation_Top;
    topCorePlotControl.legendOriginPoint = CGPointMake(80, 10);
    topCorePlotControl.unitString = @"万户";
    if (kNeedVirtualData) {
        topCorePlotControl.title = @"图表名称";
    }
    else {
        topCorePlotControl.title = @"登录及播放转化率趋势图";
    }
    topCorePlotControl.titleOffset = -50;
    [self.view addSubview:topCorePlotControl];
    
    HXLegendInfo *one = [[HXLegendInfo alloc] init];
    if (kNeedVirtualData) {
        one.legendTitle = @"条目一";
    }
    else {
        one.legendTitle = @"登录";
    }
    one.color = [UIColor colorWithHexString:@"aba2f0"];
    HXLegendInfo *two = [[HXLegendInfo alloc] init];
    if (kNeedVirtualData) {
        two.legendTitle = @"条目二";
    }
    else {
        two.legendTitle = @"播放";
    }
    two.color = [UIColor colorWithHexString:@"7ee4ed"];
    
    HXLegendInfo *three = [[HXLegendInfo alloc] init];
    if (kNeedVirtualData) {
        three.legendTitle = @"条目三";
    }
    else {
        three.legendTitle = @"转化率";
    }
    three.fillHeight = 1;
    three.fillWidth = 30;
    three.color = [UIColor colorWithHexString:@"a89d97"];
    topCorePlotControl.legendList = @[one, two, three];
    
    HXHeapBarPlot *topLeftHeapBarPlot = [HXHeapBarPlot layer];
    topLeftHeapBarPlot.dataSource = self;
    topLeftHeapBarPlot.plotName = @"top_left";
    topLeftHeapBarPlot.needShowValue = YES;
    topLeftHeapBarPlot.beginPosition = 0.25;
    topLeftHeapBarPlot.endPosition = 0.5;
    [topCorePlotControl addPlot:topLeftHeapBarPlot];
    HXHeapBarPlot *topRightHeapBarPlot = [HXHeapBarPlot layer];
    topRightHeapBarPlot.dataSource = self;
    topRightHeapBarPlot.needShowValue = YES;
    topRightHeapBarPlot.plotName = @"top_right";
    topRightHeapBarPlot.beginPosition = 0.5;
    topRightHeapBarPlot.endPosition = 0.75;
    [topCorePlotControl addPlot:topRightHeapBarPlot];
    HXLinePlot *linePlot = [HXLinePlot layer];
    linePlot.lineWidth = 1;
    linePlot.plotName = @"top";
    linePlot.isUseRightAxisY = YES;
    linePlot.lineColor = [UIColor colorWithHexString:@"a89d97"];
    linePlot.dataSource = self;
    [topCorePlotControl addPlot:linePlot];
    
    bottomCorePlotControl = [self heapControlWidthPlotName:@"bottom"];
    bottomCorePlotControl.layerManager.paddingTop = 120;
    bottomCorePlotControl.layerManager.paddingLeft = 80;
    bottomCorePlotControl.layerManager.paddingRight = 80;
    bottomCorePlotControl.layerManager.insetLeft = bottomCorePlotControl.layerManager.insetRight = 15;
    bottomCorePlotControl.xAxis.contentWidthScale = 2;
    bottomCorePlotControl.yAxis.needRightYAxis = YES;
    bottomCorePlotControl.titleLocation = TitleLocation_Top;
    bottomCorePlotControl.titleFont = [UIFont systemFontOfSize:15];
    bottomCorePlotControl.titleOffset = -100;
    bottomCorePlotControl.frame = CGRectMake(517, topCorePlotControl.y + topCorePlotControl.height, kScreenWidth - topCorePlotControl.y - topCorePlotControl.height, 382);
    [self.view addSubview:bottomCorePlotControl];
    
    HXHeapBarPlot *bottomHeapBarPlot = [HXHeapBarPlot layer];
    bottomHeapBarPlot.dataSource = self;
    bottomHeapBarPlot.plotName = @"bottom";
    bottomHeapBarPlot.beginPosition = 0.25;
    bottomHeapBarPlot.endPosition = 0.75;
    [bottomCorePlotControl addPlot:bottomHeapBarPlot];
    
    {
        HXLinePlot *linePlot = [HXLinePlot layer];
        linePlot.lineWidth = 1;
        linePlot.isUseRightAxisY = YES;
        linePlot.lineColor = [UIColor colorWithHexString:@"a89d97"];
        linePlot.dataSource = self;
        [bottomCorePlotControl addPlot:linePlot];
    }
    
    NSArray *titles = @[@"直播", @"点播", @"回看", @"下载", @"附加"];
    if (kNeedVirtualData) {
        titles = @[@"条目一", @"条目二", @"条目三", @"条目四", @"条目五"];
    }
    NSArray *colors = @[[UIColor colorWithHexString:@"6191b9"],[UIColor colorWithHexString:@"73a8d6"],[UIColor colorWithHexString:@"87bceb"],[UIColor colorWithHexString:@"a8d6ff"],[UIColor colorWithHexString:@"afe4ff"]];
    NSMutableArray *legends = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
        HXLegendInfo *legend = [[HXLegendInfo alloc] init];
        legend.color = colors[i];
        legend.legendTitle = titles[i];
        [legends addObject:legend];
    }
    bottomCorePlotControl.legendList = legends;
    bottomCorePlotControl.legendIntervalX = 8;
    bottomCorePlotControl.legendOriginPoint = CGPointMake(30, 60);
    
    leftBottomSegControl = [[MEDragSegmentedControl alloc] initWithFrame:CGRectMake(0, 400, 125, kScreenWidth - 400)];
    [leftBottomSegControl addTarget:self action:@selector(changeValueAction:) forControlEvents:UIControlEventValueChanged];
    leftBottomSegControl.itemTitles = @[@"分省登录",@"分省播放"];
    if (kNeedVirtualData) {
        leftBottomSegControl.itemTitles = @[@"项目一", @"项目二"];
    }
    [self.view addSubview:leftBottomSegControl];
    
    rightBottomSegControl = [[MEDragSegmentedControl alloc] initWithFrame:CGRectMake(kScreenHeight - 125, 466, 125, kScreenWidth - 466)];
    [rightBottomSegControl addTarget:self action:@selector(changeValueAction:) forControlEvents:UIControlEventValueChanged];
    rightBottomSegControl.itemTitles = @[@"播放流量",@"播放次数", @"播放时长"];
    if (kNeedVirtualData) {
        rightBottomSegControl.itemTitles = @[@"项目一", @"项目二", @"项目三"];
    }
    [self.view addSubview:rightBottomSegControl];
    
    [self changeValueAction:rightBottomSegControl];
    
    [self refreshAllView];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)refreshAllView {
    [bgDrawView setNeedsDisplay];
    topCorePlotControl.layerManager.maxValue = platCtr.loginData.maxFloatValue > platCtr.playData.maxFloatValue ? platCtr.loginData.maxFloatValue : platCtr.playData.maxFloatValue;
    topCorePlotControl.layerManager.rightMaxValue = platCtr.conversionRateData.maxFloatValue;
    [topCorePlotControl reloadData];
    
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0; i < 14; i++) {
        CGFloat sumValue = 0.0;
        sumValue += [platCtr.zhiboData[i] floatValue];
        sumValue += [platCtr.dianboData[i] floatValue];
        sumValue += [platCtr.huikanData[i] floatValue];
        sumValue += [platCtr.xiazaiData[i] floatValue];
        sumValue += [platCtr.fujiaData[i] floatValue];
        [tempArray addObject:[NSNumber numberWithFloat:sumValue]];
    }
    bottomCorePlotControl.layerManager.maxValue = tempArray.maxFloatValue;
    bottomCorePlotControl.layerManager.rightMaxValue = platCtr.averageData.maxFloatValue;
    
    [bottomCorePlotControl reloadData];
}

- (HXCorePlotControl *)heapControlWidthPlotName:(NSString *)plotName_ {
    HXCorePlotControl *heapControl = [[HXCorePlotControl alloc] initWithFrame:CGRectZero];
    heapControl.legendOriginPoint = CGPointMake(30, 20);
    //heapControl.title = plotName_;
    heapControl.layerManager.paddingLeft = 20;
    heapControl.layerManager.paddingBottom = 45;
    heapControl.layerManager.paddingTop = 20;
    heapControl.layerManager.paddingRight = 20;
    heapControl.layerManager.insetLeft = 30;
    heapControl.layerManager.insetRight = 30;
    heapControl.xAxis.dataSource = self;
    heapControl.yAxis.dataSource = self;
    heapControl.layerManager.maxValue = 2.0;
    return heapControl;
}

- (UIColor *)colorWithValue:(CGFloat)value {
    UIColor *ret = nil;
    if (value >= 1.6) {
        ret = [UIColor colorWithHexString:@"91e8f2"];
    }
    else if (value >= 1.2) {
        ret = [UIColor colorWithHexString:@"91c8f2"];
    }
    else if (value >= 0.8) {
        ret = [UIColor colorWithHexString:@"91acf2"];
    }
    else if (value >= 0.4) {
        ret = [UIColor colorWithHexString:@"ada8df"];
    }
    else {
        ret = [UIColor colorWithHexString:@"c9a3d9"];
    }
    return ret;
}

- (void)refreshChinaMap {
    [virtualData removeAllObjects];
    for (int i = 0; i < 32; i++) {
        UIImageView *imageView = (UIImageView *)[self.view viewWithTag:i + 1001];
        
        NSString *provinceName =  [[self provinceNameDic] objectForKey:[NSString stringWithFormat:@"%d", i + 1001]];
        CGFloat value = [[platCtr.provinceData objectForKey:provinceName] floatValue];

        [virtualData addObject:[NSNumber numberWithFloat:value]];
        UIColor *retColor = [self colorWithValue:value];
        imageView.image = [imageView.image imageWithTintColor:retColor];
    }
}

- (NSInteger)numberOfTitleInYAxis:(HXCorePlotYAxisLayer *)yAxis {
    return 4;
}

- (NSString *)yAxis:(HXCorePlotYAxisLayer *)yAxis titleAtIndex:(NSInteger)index isUseRightYAxis:(BOOL)isUseRight {
    if ([topCorePlotControl.yAxis isEqual:yAxis]) {
        if (isUseRight) {
            CGFloat rightMaxValue = 0;
            rightMaxValue = platCtr.conversionRateData.maxFloatValue;
            return [NSString stringWithFormat:@"%.2f", rightMaxValue - rightMaxValue / 3 * index];
        }
        else {
            CGFloat leftMaxValue = 0;
            leftMaxValue = platCtr.loginData.maxFloatValue > platCtr.playData.maxFloatValue ? platCtr.loginData.maxFloatValue : platCtr.playData.maxFloatValue;
            return [NSString stringWithFormat:@"%.2f", leftMaxValue - leftMaxValue / 3 * index];
        }
    }
    else {
        CGFloat maxValue = 0;
        if (isUseRight) {
            maxValue = platCtr.averageData.maxFloatValue;
        }
        else {
            NSMutableArray *tempArray = [NSMutableArray array];
            for (int i = 0; i < 14; i++) {
                CGFloat sumValue = 0.0;
                sumValue += [platCtr.zhiboData[i] floatValue];
                sumValue += [platCtr.dianboData[i] floatValue];
                sumValue += [platCtr.huikanData[i] floatValue];
                sumValue += [platCtr.xiazaiData[i] floatValue];
                sumValue += [platCtr.fujiaData[i] floatValue];
                [tempArray addObject:[NSNumber numberWithFloat:sumValue]];
            }
            maxValue = tempArray.maxFloatValue;
        }
        return [NSString stringWithFormat:@"%.2f", maxValue - maxValue / 3 * index];
    }
    return [NSString stringWithFormat:@"%.2f", 2.0 - 2.0 / 3 * index];
}

- (NSInteger)numberOfNeedTouchDegreeCorePlotControl:(HXCorePlotControl *)corePlotControl {
    return 14;
}

- (void)corePlotControl:(HXCorePlotControl *)corePlotControl touchIndex:(NSInteger)index {
    _selectIndex = index;
    platCtr.selectedProvinceDateIndex = index;
    [bgDrawView setNeedsDisplay];
    [self refreshChinaMap];
}

- (NSInteger)numberOfTitleInXAxis:(HXCoreplotXAxisLayer *)xAxis {
    return 14;
}
- (NSString *)xAxis:(HXCoreplotXAxisLayer *)xAxis titleAtIndex:(NSInteger)index {
    if ([topCorePlotControl.xAxis isEqual:xAxis]) {
        return [cachePlotCtr dataStrListWithDayNumber:14][index];
    }
    else {
        return [[cachePlotCtr dataStrListWithDayNumber:14][index] substringFromIndex:5];
    }
}

- (NSInteger)numberOfPlot:(HXBasePlot *)plot {
    return 14;
}

- (NSNumber *)plot:(HXBasePlot *)plot index:(NSInteger)index {
    if ([plot.plotName isEqualToString:@"top"]) {
        return platCtr.conversionRateData[index];
    }
    else {
        return platCtr.averageData[index];
    }
}

- (NSInteger)numberOfXValuesInHeapBarPlot:(HXHeapBarPlot *)heapBarPlot {
    return 14;
}

- (NSInteger)numberOfHeapBarInHeapBarPlot:(HXHeapBarPlot *)heapBarPlot {
    if ([heapBarPlot.plotName isEqualToString:@"top_left"] || [heapBarPlot.plotName isEqualToString:@"top_right"]) {
        return 1;
    }
    return 5;
}

- (NSNumber *)heapBarPlot:(HXHeapBarPlot *)heapBarPlot valueOfXIndex:(NSInteger)xIndex heapIndex:(NSInteger)heapIndex {
    if ([heapBarPlot.plotName isEqualToString:@"top_left"]) {
        return platCtr.loginData[xIndex];
    }
    else if ([heapBarPlot.plotName isEqualToString:@"top_right"]) {
        return platCtr.playData[xIndex];
    }
    else {
        switch (heapIndex) {
            case 0:
                return platCtr.zhiboData[xIndex];
                break;
            case 1:
                return platCtr.dianboData[xIndex];
                break;
            case 2:
                return platCtr.huikanData[xIndex];
                break;
            case 3:
                return platCtr.xiazaiData[xIndex];
                break;
            case 4:
                return platCtr.fujiaData[xIndex];
                break;
                
            default:
                break;
        }
    }
    return [NSNumber numberWithFloat:arc4random()%21 / 10.0 / 5];
}

- (UIColor *)heapBarPlot:(HXHeapBarPlot *)heapBarPlot colorOfHeapIndex:(NSInteger)heapIndex {
    UIColor *ret = nil;
    switch (heapIndex) {
        case 0:
            if ([heapBarPlot.plotName isEqualToString:@"top_left"]) {
                ret = [UIColor colorWithHexString:@"aba2f0"];
            }
            else if ([heapBarPlot.plotName isEqualToString:@"top_right"]) {
                ret = [UIColor colorWithHexString:@"7ee4ed"];            }
            else {
                ret = [UIColor colorWithHexString:@"6191b9"];
            }
            break;
        case 1:
            ret = [UIColor colorWithHexString:@"73a8d6"];
            break;
        case 2:
            ret = [UIColor colorWithHexString:@"87bceb"];
            break;
        case 3:
            ret = [UIColor colorWithHexString:@"a8d6ff"];
            break;
            case 4:
            ret = [UIColor colorWithHexString:@"afe4ff"];
            
        default:
            break;
    }
    return ret;
}

- (void)contentView:(MYDrawContentView*)view touchEndAtPoint:(CGPoint)p {
    if (floatView != nil) {
        [UIView animateWithDuration:0.2 animations:^{
            floatView.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (finished) {
                [floatView removeFromSuperview];
                floatView = nil;
            }
        }];
    }
}

- (BOOL)isIntersectantOneFrame:(CGRect)oneFrame anotherFrame:(CGRect)anotherFrame {
    CGPoint oneCenter = CGPointMake(oneFrame.origin.x + oneFrame.size.width / 2, oneFrame.origin.y + oneFrame.size.height);
    CGPoint anotherCenter = CGPointMake(anotherFrame.origin.x + anotherFrame.size.width / 2, anotherFrame.origin.y + anotherFrame.size.height);
    return fabsf(oneCenter.x - anotherCenter.x) < (oneFrame.size.width + anotherFrame.size.width) / 2 && fabsf(oneCenter.y - anotherCenter.y) < (oneFrame.size.height + anotherFrame.size.height) / 2;
}

- (void)contentView:(MYDrawContentView*)view touchBeginAtPoint:(CGPoint)p {
    [super contentView:view touchBeginAtPoint:p];
    if (CGRectContainsPoint(CGRectMake(150, topCorePlotControl.y + topCorePlotControl.height, 360, kScreenWidth - topCorePlotControl.y - topCorePlotControl.height), p)) {
        CGFloat radius = 5;
        CGRect validFrame = CGRectMake(p.x - radius, p.y - radius, radius * 2, radius * 2);
        NSMutableArray *selectInfos = [NSMutableArray array];
        for (int i = 0; i < 31; i++) {
            UIView *view = [self.view viewWithTag:i + 1001];
            if ([self isIntersectantOneFrame:validFrame anotherFrame:view.frame]) {
                NSString *provinceName = [[self provinceNameDic] objectForKey:[NSString stringWithFormat:@"%d", i + 1001]];
                CGFloat value = [[platCtr.provinceData objectForKey:provinceName] floatValue];
                [selectInfos addObject:@{@"provinceName":provinceName, @"value":[NSNumber numberWithFloat:value]}];
            }
        }
        NSArray *retArray = [selectInfos sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [[obj1 objectForKey:@"value"] floatValue] < [[obj2 objectForKey:@"value"] floatValue];
        }];
        
        if ([retArray count] != 0) {
            CGFloat offsetTop = 5;
            CGFloat sumWidth = 200;
            CGFloat everyHeight = 25;
            UIFont *font = [UIFont systemFontOfSize:15];
            
            floatView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sumWidth, 0)];
            floatView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
            floatView.layer.cornerRadius = 3;
            
            int i = 0;
            while (i < [retArray count]) {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, offsetTop + everyHeight * i, sumWidth, everyHeight)];
                label.font = font;
                label.textColor = [UIColor whiteColor];
                label.textAlignment = NSTextAlignmentCenter;
                label.text = [NSString stringWithFormat:@"%@ : %.1f万户", [retArray[i] objectForKey:@"provinceName"], [[retArray[i] objectForKey:@"value"] floatValue]];
                [floatView addSubview:label];
                i++;
            }
            floatView.frame = CGRectMake(p.x - sumWidth / 2, p.y - 30 - everyHeight * i, sumWidth, everyHeight * i + 10);
            [self.view addSubview:floatView];
        }
    }
}

- (void)contentView:(MYDrawContentView *)view drawRect:(CGRect)rect {
    [super contentView:view drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithHexString:@"fafafa"].CGColor);
    CGContextFillRect(ctx, CGRectMake(125, 388, kScreenHeight - 125 * 2, kScreenWidth - 388));
    
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithHexString:@"f5f5f5"].CGColor);
    CGContextFillRect(ctx, CGRectMake(0, 388, 125, kScreenWidth - 388));
    CGContextFillRect(ctx, CGRectMake(kScreenHeight - 125, 388, 125, kScreenWidth - 388));
    
    NSMutableDictionary *attrDic = [NSMutableDictionary dictionary];
    [attrDic setValue:[UIFont systemFontOfSize:15] forKey:NSFontAttributeName];
    [attrDic setValue:[UIColor colorWithHexString:@"1A1A1A"] forKey:NSForegroundColorAttributeName];
    [@"分省统计" drawAtPoint:CGPointMake(320, 408) withAttributes:attrDic];
    
    NSArray *colors = @[[UIColor colorWithHexString:@"c9a3d9"], [UIColor colorWithHexString:@"ada8df"], [UIColor colorWithHexString:@"91acf2"], [UIColor colorWithHexString:@"91c8f2"], [UIColor colorWithHexString:@"91e8f2"]];
    CGFloat offsetLeft = 160;
    CGFloat offsetTop = 722;
    CGFloat cellWidth = 30;
    CGFloat cellHeight = 15;
    
    [attrDic setValue:[UIFont systemFontOfSize:18] forKey:NSFontAttributeName];
    [attrDic setValue:[UIColor colorWithHexString:@"333333"] forKey:NSForegroundColorAttributeName];
    [[platCtr dataStrListWithDayNumber:14][platCtr.selectedProvinceDateIndex] drawAtPoint:CGPointMake(170, 406) withAttributes:attrDic];
    
    [attrDic setValue:[UIFont systemFontOfSize:10] forKey:NSFontAttributeName];
    [attrDic setValue:[UIColor colorWithHexString:@"4c4c4c"] forKey:NSForegroundColorAttributeName];
    NSMutableParagraphStyle *paraStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paraStyle.alignment = NSTextAlignmentCenter;
    [attrDic setValue:paraStyle forKey:NSParagraphStyleAttributeName];
    
    NSArray *degreeLists = @[@"0.4", @"0.8", @"1.2", @"1.6"];
    
    for (int i = 0; i < [colors count]; i++) {
        CGContextSetFillColorWithColor(ctx, ((UIColor *)colors[i]).CGColor);
        CGContextFillRect(ctx, CGRectMake(offsetLeft, offsetTop, cellWidth, cellHeight));
        
        if (i != [colors count] - 1) {
            [degreeLists[i] drawInRect:CGRectMake(offsetLeft, offsetTop + cellHeight + 3, cellWidth * 2, 15) withAttributes:attrDic];
        }
        
        offsetLeft += cellWidth;
    }
    [@"万户" drawInRect:CGRectMake(offsetLeft - cellWidth, offsetTop + cellHeight + 3, cellWidth * 2, 15) withAttributes:attrDic];
}

- (void)changeValueAction:(MEDragSegmentedControl *)control {
    if ([control isEqual:rightBottomSegControl]) {
        platCtr.selectedAppendType = control.selectedIndex;
        NSMutableArray *tempArray = [NSMutableArray array];
        for (int i = 0; i < 14; i++) {
            CGFloat sumValue = 0.0;
            sumValue += [platCtr.zhiboData[i] floatValue];
            sumValue += [platCtr.dianboData[i] floatValue];
            sumValue += [platCtr.huikanData[i] floatValue];
            sumValue += [platCtr.xiazaiData[i] floatValue];
            sumValue += [platCtr.fujiaData[i] floatValue];
            [tempArray addObject:[NSNumber numberWithFloat:sumValue]];
        }
        bottomCorePlotControl.layerManager.maxValue = tempArray.maxFloatValue;
        NSArray *titles = nil;
        bottomCorePlotControl.layerManager.rightMaxValue = platCtr.averageData.maxFloatValue;
        bottomCorePlotControl.title = rightBottomSegControl.selectedTitle;
        switch (rightBottomSegControl.selectedIndex) {
            case 0:
                bottomCorePlotControl.unitString = @"TB";
                bottomCorePlotControl.rightUnitString = @"MB/户";
                titles = @[@"直播", @"点播", @"回看", @"下载", @"附加"];
                
                break;
            case 1:
                bottomCorePlotControl.unitString = @"万次";
                bottomCorePlotControl.rightUnitString = @"次/户";
                titles = @[@"直播", @"点播", @"回看", @"下载", @"附加"];
                break;
            case 2:
                bottomCorePlotControl.unitString = @"万小时";
                bottomCorePlotControl.rightUnitString = @"分/户";
                titles = @[@"直播", @"点播", @"回看", @"下载", @"附加"];
                break;
                
            default:
                break;
        }
        if (kNeedVirtualData) {
            titles = @[@"一", @"二", @"三", @"四", @"五"];
        }
        NSArray *colors = @[[UIColor colorWithHexString:@"6191b9"],[UIColor colorWithHexString:@"73a8d6"],[UIColor colorWithHexString:@"87bceb"],[UIColor colorWithHexString:@"a8d6ff"],[UIColor colorWithHexString:@"afe4ff"]];
        NSMutableArray *legends = [NSMutableArray array];
        for (int i = 0; i < [titles count]; i++) {
            HXLegendInfo *legend = [[HXLegendInfo alloc] init];
            legend.color = colors[i];
            legend.legendTitle = titles[i];
            [legends addObject:legend];
        }
        
        HXLegendInfo *three = [[HXLegendInfo alloc] init];
        three.legendTitle = @"单用户";
        if (kNeedVirtualData) {
            three.legendTitle = @"六";
        }
        three.fillHeight = 1;
        three.fillWidth = 20;
        three.color = [UIColor colorWithHexString:@"a89d97"];
        [legends addObject:three];
        bottomCorePlotControl.legendList = legends;
        [bottomCorePlotControl reloadData];
    }
    else {
        platCtr.selectedProvinceType = control.selectedIndex;
        [self refreshChinaMap];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

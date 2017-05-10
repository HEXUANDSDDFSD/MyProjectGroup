//
//  TYSXOrderAndUnViewController.m
//  tysx
//
//  Created by zwc on 14/12/3.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "TYSXOrderAndUnViewController.h"
#import "TYSXOrderAndUnCtr.h"
#import "MEDragSegmentedControl.h"
#import "HXCorePlot.h"
#import "NSArray+Category.h"
#import "UIImage+Blend.h"

@interface TYSXOrderAndUnViewController ()<HXCoreplotXAxisDataSource, HXCorePlotYAxisDataSource, HXHeapBarPlotDataSource, HXBaseDataSource, HXCorePlotControlDelegate>

@end

@implementation TYSXOrderAndUnViewController {
    HXCorePlotControl *bottomCorePlotControl;
    HXCorePlotControl *topCorePlotControl;
    MEDragSegmentedControl *rightTopSegControl;
    MEDragSegmentedControl *leftBottomSegControl;
    MEDragSegmentedControl *rightBottomSegControl;
    NSMutableArray *virtualData;
    NSInteger _selectIndex;
    UIView *floatView;
    TYSXOrderAndUnCtr *orderAndUnCtr;
}

- (id)initWithPlotName:(NSString *)_plotName {
    if (self = [super initWithPlotName:_plotName]) {
        virtualData = [NSMutableArray array];
        orderAndUnCtr = (TYSXOrderAndUnCtr *)cachePlotCtr;
    }
    return self;
}

+ (Class)cachePlotCtr {
    return [TYSXOrderAndUnCtr class];
}

- (NSDictionary *)provinceDic {
   NSDictionary *ret = [NSMutableDictionary dictionary];
    [ret setValue:@"yunnan" forKey:@"1001"];
    [ret setValue:@"neimenggu" forKey:@"1002"];
    [ret setValue:@"shanxi" forKey:@"1003"];
    [ret setValue:@"sanxi" forKey:@"1004"];
    [ret setValue:@"shanghai" forKey:@"1005"];
    [ret setValue:@"beijing" forKey:@"1006"];
    [ret setValue:@"jilin" forKey:@"1007"];
    [ret setValue:@"sichuan" forKey:@"1008"];
    [ret setValue:@"tianjin" forKey:@"1009"];
    [ret setValue:@"ningxia" forKey:@"1010"];
    [ret setValue:@"anhui" forKey:@"1011"];
    [ret setValue:@"shandong" forKey:@"1012"];
    [ret setValue:@"guangdong" forKey:@"1013"];
    [ret setValue:@"guangxi" forKey:@"1014"];
    [ret setValue:@"xinjiang" forKey:@"1015"];
    [ret setValue:@"jiangsu" forKey:@"1016"];
    [ret setValue:@"jiangxi" forKey:@"1017"];
    [ret setValue:@"hebei" forKey:@"1018"];
    [ret setValue:@"henan" forKey:@"1019"];
    [ret setValue:@"zhejiang" forKey:@"1020"];
    [ret setValue:@"hainan" forKey:@"1021"];
    [ret setValue:@"hubei" forKey:@"1022"];
    [ret setValue:@"hunan" forKey:@"1023"];
    [ret setValue:@"gansu" forKey:@"1024"];
    [ret setValue:@"fujian" forKey:@"1025"];
    [ret setValue:@"xizang" forKey:@"1026"];
    [ret setValue:@"guizhou" forKey:@"1027"];
    [ret setValue:@"liaoning" forKey:@"1028"];
    [ret setValue:@"chongqing" forKey:@"1029"];
    [ret setValue:@"qinghai" forKey:@"1030"];
    [ret setValue:@"heilongjiang" forKey:@"1031"];
    return ret;
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
    {
        topCorePlotControl = [self heapControlWidthPlotName:@"top"];
        topCorePlotControl.legendIntervalX = 8;
        topCorePlotControl.legendOriginPoint = CGPointMake(590, 40);
        topCorePlotControl.unitString = @"万个";
        topCorePlotControl.titleLocation = TitleLocation_Top;
        topCorePlotControl.layerManager.paddingTop = 70;
        topCorePlotControl.titleOffset = -70;
        topCorePlotControl.delegate = self;
        topCorePlotControl.frame = CGRectMake(0, 70, 874, 316);
        topCorePlotControl.layerManager.insetLeft = 40;
        topCorePlotControl.layerManager.paddingLeft = 80;
        topCorePlotControl.xAxis.contentWidthScale = 2;
        [self.view addSubview:topCorePlotControl];
        
    }

    [self refreshTopControl];
    
    bottomCorePlotControl = [self heapControlWidthPlotName:@"bottom"];
    bottomCorePlotControl.layerManager.paddingTop = 100;
    bottomCorePlotControl.titleLocation = TitleLocation_Top;
    bottomCorePlotControl.titleOffset = -80;
    bottomCorePlotControl.xAxis.contentWidthScale = 2;
    bottomCorePlotControl.titleFont = [UIFont systemFontOfSize:15];
    bottomCorePlotControl.layerManager.paddingLeft = 50;
    bottomCorePlotControl.frame = CGRectMake(537, topCorePlotControl.y + topCorePlotControl.height, 358, kScreenWidth - topCorePlotControl.y - topCorePlotControl.height);
    [self.view addSubview:bottomCorePlotControl];
    
    bottomCorePlotControl.legendIntervalX = 8;
    bottomCorePlotControl.legendOriginPoint = CGPointMake(40, 55);
    
    HXHeapBarPlot *bottomHeapBarPlot = [HXHeapBarPlot layer];
    bottomHeapBarPlot.dataSource = self;
    bottomHeapBarPlot.plotName = @"bottom";
    bottomHeapBarPlot.needShowValue = YES;
    bottomHeapBarPlot.beginPosition = 0.25;
    bottomHeapBarPlot.endPosition = 0.75;
    [bottomCorePlotControl addPlot:bottomHeapBarPlot];
    
    rightTopSegControl = [[MEDragSegmentedControl alloc] initWithFrame:CGRectMake(kScreenHeight - 125, 50, 125, topCorePlotControl.height)];
    if (kNeedVirtualData) {
        rightTopSegControl.itemTitles = @[@"项目一",@"项目二", @"项目三"];
    }
    else {
        rightTopSegControl.itemTitles = @[@"平台自订购",@"CRM订购", @"按次"];
    }
    [rightTopSegControl addTarget:self action:@selector(changeValueAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:rightTopSegControl];
    
    leftBottomSegControl = [[MEDragSegmentedControl alloc] initWithFrame:CGRectMake(0, 400, 125, kScreenWidth - 400)];
        [leftBottomSegControl addTarget:self action:@selector(changeValueAction:) forControlEvents:UIControlEventValueChanged];
    if (kNeedVirtualData) {
         leftBottomSegControl.itemTitles = @[@"项目一",@"项目二", @"项目三", @"项目四"];
    }
    else {
         leftBottomSegControl.itemTitles = @[@"平台自订购",@"平台订购", @"CRM订购", @"按次订购"];
    }
    [self.view addSubview:leftBottomSegControl];
    
    rightBottomSegControl = [[MEDragSegmentedControl alloc] initWithFrame:CGRectMake(rightTopSegControl.x, 466, rightTopSegControl.width, kScreenWidth - rightTopSegControl.y - rightTopSegControl.height)];
    [rightBottomSegControl addTarget:self action:@selector(changeValueAction:) forControlEvents:UIControlEventValueChanged];
    if (kNeedVirtualData) {
        rightBottomSegControl.itemTitles = @[@"项目一",@"项目二", @"项目三", @"项目四"];
    }
    else {
        rightBottomSegControl.itemTitles = @[@"归属部门",@"停复机", @"包月开账", @"按次开账"];
    }
    [self.view addSubview:rightBottomSegControl];
    
    [self changeValueAction:rightBottomSegControl];
    
    bottomCorePlotControl.title = rightBottomSegControl.selectedTitle;
    
    // Do any additional setup after loading the view from its nib.
}

- (HXCorePlotControl *)heapControlWidthPlotName:(NSString *)plotName_ {
    HXCorePlotControl *heapControl = [[HXCorePlotControl alloc] initWithFrame:CGRectZero];
    heapControl.legendOriginPoint = CGPointMake(560, 20);
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

- (UIColor *)colorWithValue:(int)value {
    UIColor *ret = nil;
    if (value >= 440) {
        ret = [UIColor colorWithHexString:@"91e8f2"];
    }
    else if (value >= 250) {
        ret = [UIColor colorWithHexString:@"91c8f2"];
    }
    else if (value >= 150) {
        ret = [UIColor colorWithHexString:@"91acf2"];
    }
    else if (value >= 90) {
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
        int value = [[orderAndUnCtr.provinceData objectForKey:provinceName] intValue];
        [virtualData addObject:[NSNumber numberWithInt:value]];
        UIColor *retColor = [self colorWithValue:value];
        imageView.image = [imageView.image imageWithTintColor:retColor];
    }
}

- (NSInteger)numberOfTitleInYAxis:(HXCorePlotYAxisLayer *)yAxis {
    return 4;
}

- (NSString *)yAxis:(HXCorePlotYAxisLayer *)yAxis titleAtIndex:(NSInteger)index isUseRightYAxis:(BOOL)isUseRight {
    if ([topCorePlotControl.yAxis isEqual:yAxis]) {
        
        switch (rightTopSegControl.selectedIndex) {
            case 0:
                if (isUseRight) {
                    return [NSString stringWithFormat:@"%.2f", orderAndUnCtr.conversionRateData.maxFloatValue - orderAndUnCtr.conversionRateData.maxFloatValue / 3 * index];
                }
                else {
                    CGFloat leftMaxValue = orderAndUnCtr.orderData.maxFloatValue > orderAndUnCtr.unsubscribeData.maxFloatValue ? orderAndUnCtr.orderData.maxFloatValue : orderAndUnCtr.unsubscribeData.maxFloatValue;
                    
                    
                    return [NSString stringWithFormat:@"%.2f", leftMaxValue - leftMaxValue / 3 * index];
                }
                break;
            case 1:
            {
                CGFloat leftMaxValue = orderAndUnCtr.orderData.maxFloatValue > orderAndUnCtr.unsubscribeData.maxFloatValue ? orderAndUnCtr.orderData.maxFloatValue : orderAndUnCtr.unsubscribeData.maxFloatValue;
                
                
                return [NSString stringWithFormat:@"%.2f", leftMaxValue - leftMaxValue / 3 * index];
            }
                break;
            case 2:
                return [NSString stringWithFormat:@"%.2f", orderAndUnCtr.timesData.maxFloatValue - orderAndUnCtr.timesData.maxFloatValue / 3 * index];
                
            default:
                break;
        }
    }
    else {
        CGFloat leftMaxValue = 0;
        switch (rightBottomSegControl.selectedIndex) {
            case 0:
            {
                NSMutableArray *tempArray = [NSMutableArray array];
                for (int i = 0; i < 14; i++) {
                    CGFloat sumValue = 0.0;
                    sumValue += [orderAndUnCtr.yunyingData[i] floatValue];
                    sumValue += [orderAndUnCtr.yingxiaoData[i] floatValue];
                    sumValue += [orderAndUnCtr.chanpinData[i] floatValue];
                    sumValue += [orderAndUnCtr.otherData[i] floatValue];
                    [tempArray addObject:[NSNumber numberWithFloat:sumValue]];
                }
                leftMaxValue = tempArray.maxFloatValue;
                return [NSString stringWithFormat:@"%.0f", leftMaxValue - leftMaxValue / 3 * index];
            }
                break;
            case 1:
            {
                NSMutableArray *tempArray = [NSMutableArray array];
                for (int i = 0; i < 14; i++) {
                    CGFloat sumValue = 0.0;
                    sumValue += [orderAndUnCtr.tingjiData[i] floatValue];
                    sumValue += [orderAndUnCtr.fujiData[i] floatValue];
                    [tempArray addObject:[NSNumber numberWithFloat:sumValue]];
                }
                leftMaxValue = tempArray.maxFloatValue;
            }
                return [NSString stringWithFormat:@"%.0f", leftMaxValue - leftMaxValue / 3 * index];
                break;
            case 2:
                leftMaxValue = orderAndUnCtr.baoyueData.maxFloatValue;
                return [NSString stringWithFormat:@"%.1f", leftMaxValue - leftMaxValue / 3 * index];
                break;
            case 3:
                leftMaxValue = orderAndUnCtr.anciData.maxFloatValue;
                return [NSString stringWithFormat:@"%.1f", leftMaxValue - leftMaxValue / 3 * index];
                break;
            default:
                break;
        }
    }
    return @"";
}

- (NSInteger)numberOfNeedTouchDegreeCorePlotControl:(HXCorePlotControl *)corePlotControl {
    return 14;
}

- (void)refreshAllView {
    [bgDrawView setNeedsDisplay];
    [topCorePlotControl reloadData];
    
    CGFloat maxValue = 0;
    switch (orderAndUnCtr.selectedMainType) {
        case 0:
            maxValue = orderAndUnCtr.orderData.maxFloatValue;
            if (maxValue < orderAndUnCtr.unsubscribeData.maxFloatValue) {
                maxValue = orderAndUnCtr.unsubscribeData.maxFloatValue;
            }
            topCorePlotControl.layerManager.maxValue = maxValue;
            topCorePlotControl.layerManager.rightMaxValue = orderAndUnCtr.conversionRateData.maxFloatValue;

            break;
        case 1:
            maxValue = orderAndUnCtr.orderData.maxFloatValue;
            if (maxValue < orderAndUnCtr.unsubscribeData.maxFloatValue) {
                maxValue = orderAndUnCtr.unsubscribeData.maxFloatValue;
            }
            topCorePlotControl.layerManager.maxValue = maxValue;
            
            break;
        case 2:
            topCorePlotControl.layerManager.maxValue = orderAndUnCtr.timesData.maxFloatValue;
            break;
            
        default:
            break;
    }
    topCorePlotControl.layerManager.maxValue = maxValue;
    topCorePlotControl.layerManager.rightMaxValue = orderAndUnCtr.conversionRateData.maxFloatValue;
    
    [self refreshChinaMap];
    
    switch (rightBottomSegControl.selectedIndex) {
        case 0:
        {
            NSMutableArray *tempArray = [NSMutableArray array];
            for (int i = 0; i < 14; i++) {
                CGFloat sumValue = 0.0;
                sumValue += [orderAndUnCtr.yunyingData[i] floatValue];
                sumValue += [orderAndUnCtr.yingxiaoData[i] floatValue];
                sumValue += [orderAndUnCtr.chanpinData[i] floatValue];
                sumValue += [orderAndUnCtr.otherData[i] floatValue];
                [tempArray addObject:[NSNumber numberWithFloat:sumValue]];
            }
            bottomCorePlotControl.layerManager.maxValue = tempArray.maxFloatValue;
        }
            break;
        case 1:
            
        {
            NSMutableArray *tempArray = [NSMutableArray array];
            for (int i = 0; i < 14; i++) {
                CGFloat sumValue = 0.0;
                sumValue += [orderAndUnCtr.tingjiData[i] floatValue];
                sumValue += [orderAndUnCtr.fujiData[i] floatValue];
                [tempArray addObject:[NSNumber numberWithFloat:sumValue]];
            }
            bottomCorePlotControl.layerManager.maxValue = tempArray.maxFloatValue;
        }
            bottomCorePlotControl.unitString = @"个";
            break;
        case 2:
            bottomCorePlotControl.layerManager.maxValue = orderAndUnCtr.baoyueData.maxFloatValue;
            break;
        case 3:
            bottomCorePlotControl.layerManager.maxValue = orderAndUnCtr.anciData.maxFloatValue;
            break;
        default:
            break;
    }
    
    [bottomCorePlotControl reloadData];
}

- (void)corePlotControl:(HXCorePlotControl *)corePlotControl touchIndex:(NSInteger)index {
    orderAndUnCtr.selectedProvinceDateIndex = index;
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
    return orderAndUnCtr.conversionRateData[index];
}

- (NSInteger)numberOfXValuesInHeapBarPlot:(HXHeapBarPlot *)heapBarPlot {
    return 14;
}

- (NSInteger)numberOfHeapBarInHeapBarPlot:(HXHeapBarPlot *)heapBarPlot {
    NSInteger ret = 0;
    if ([heapBarPlot.plotName isEqualToString:@"top_left"] || [heapBarPlot.plotName isEqualToString:@"top_right"]) {
        return 1;
    }
    else {
        switch (rightBottomSegControl.selectedIndex) {
            case 0:
                ret = 4;
                break;
            case 1:
                ret = 2;
                break;
            case 2:
                ret = 1;
                break;
            case 3:
                ret = 1;
                break;
                
                
            default:
                break;
        }
    }
    return ret;
}

- (NSNumber *)heapBarPlot:(HXHeapBarPlot *)heapBarPlot valueOfXIndex:(NSInteger)xIndex heapIndex:(NSInteger)heapIndex {
    if ([heapBarPlot.plotName isEqualToString:@"top_left"]) {
        if (rightTopSegControl.selectedIndex == 2) {
            return orderAndUnCtr.timesData[xIndex];
        }
        else {
            return orderAndUnCtr.orderData[xIndex];
        }
    }
    else if ([heapBarPlot.plotName isEqualToString:@"top_right"]) {
        return orderAndUnCtr.unsubscribeData[xIndex];
    }
    else {
        switch (rightBottomSegControl.selectedIndex) {
            case 0:
                switch (heapIndex) {
                    case 0:
                        return orderAndUnCtr.yunyingData[xIndex];
                        break;
                    case 1:
                        return orderAndUnCtr.yingxiaoData[xIndex];
                        break;
                    case 2:
                        return orderAndUnCtr.chanpinData[xIndex];
                        break;
                    case 3:
                        return orderAndUnCtr.otherData[xIndex];
                        break;
                        
                    default:
                        break;
                }
                break;
            case 1:
                switch (heapIndex) {
                    case 0:
                        return orderAndUnCtr.tingjiData[xIndex];
                        break;
                    case 1:
                        return orderAndUnCtr.fujiData[xIndex];
                        break;
                        
                    default:
                        break;
                }
                break;
            case 2:
                return orderAndUnCtr.baoyueData[xIndex];
                break;
            case 3:
                return orderAndUnCtr.anciData[xIndex];
                break;
                
            default:
                break;
        }
    }
    return [NSNumber numberWithFloat:arc4random()%21 / 10.0 / 4];
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
            
        default:
            break;
    }
    return ret;
}

- (BOOL)isIntersectantOneFrame:(CGRect)oneFrame anotherFrame:(CGRect)anotherFrame {
    CGPoint oneCenter = CGPointMake(oneFrame.origin.x + oneFrame.size.width / 2, oneFrame.origin.y + oneFrame.size.height);
    CGPoint anotherCenter = CGPointMake(anotherFrame.origin.x + anotherFrame.size.width / 2, anotherFrame.origin.y + anotherFrame.size.height);
    return fabsf(oneCenter.x - anotherCenter.x) < (oneFrame.size.width + anotherFrame.size.width) / 2 && fabsf(oneCenter.y - anotherCenter.y) < (oneFrame.size.height + anotherFrame.size.height) / 2;
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
                int value = [[orderAndUnCtr.provinceData objectForKey:provinceName] intValue];
                [selectInfos addObject:@{@"provinceName":provinceName, @"value":[NSNumber numberWithInt:value]}];
            }
        }
        NSArray *retArray = [selectInfos sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [[obj1 objectForKey:@"value"] intValue] < [[obj2 objectForKey:@"value"] intValue];
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
                label.text = [NSString stringWithFormat:@"%@ : %d个", [retArray[i] objectForKey:@"provinceName"], [[retArray[i] objectForKey:@"value"] intValue]];
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
    
    CGContextFillRect(ctx, CGRectMake(kScreenHeight - 125, 50, 125, 336));
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
    [[orderAndUnCtr dataStrListWithDayNumber:14][orderAndUnCtr.selectedProvinceDateIndex]  drawAtPoint:CGPointMake(170, 406) withAttributes:attrDic];
    
    [attrDic setValue:[UIFont systemFontOfSize:10] forKey:NSFontAttributeName];
    [attrDic setValue:[UIColor colorWithHexString:@"4c4c4c"] forKey:NSForegroundColorAttributeName];
    NSMutableParagraphStyle *paraStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paraStyle.alignment = NSTextAlignmentCenter;
    [attrDic setValue:paraStyle forKey:NSParagraphStyleAttributeName];
    
    NSArray *degreeLists = @[@"90", @"150", @"250", @"440"];
    
    for (int i = 0; i < [colors count]; i++) {
        CGContextSetFillColorWithColor(ctx, ((UIColor *)colors[i]).CGColor);
        CGContextFillRect(ctx, CGRectMake(offsetLeft, offsetTop, cellWidth, cellHeight));
        
        if (i != [colors count] - 1) {
            [degreeLists[i] drawInRect:CGRectMake(offsetLeft, offsetTop + cellHeight + 3, cellWidth * 2, 15) withAttributes:attrDic];
        }
        
        offsetLeft += cellWidth;
    }
    [@"个" drawInRect:CGRectMake(offsetLeft - cellWidth, offsetTop + cellHeight + 3, cellWidth * 2, 15) withAttributes:attrDic];
}

- (void)refreshTopControl {
    [topCorePlotControl removeAllPlot];
    HXHeapBarPlot *topLeftHeapBarPlot = [HXHeapBarPlot layer];
    topLeftHeapBarPlot.dataSource = self;
    topLeftHeapBarPlot.needShowValue = YES;
    topLeftHeapBarPlot.plotName = @"top_left";
    topLeftHeapBarPlot.beginPosition = 0.25;
    topLeftHeapBarPlot.endPosition = 0.5;
    [topCorePlotControl addPlot:topLeftHeapBarPlot];
    switch (rightTopSegControl.selectedIndex) {
        case 0:
        {
            CGFloat leftMaxValue = orderAndUnCtr.orderData.maxFloatValue > orderAndUnCtr.unsubscribeData.maxFloatValue ? orderAndUnCtr.orderData.maxFloatValue : orderAndUnCtr.unsubscribeData.maxFloatValue;
            if (kNeedVirtualData) {
                topCorePlotControl.title = @"图表名称一";
            }
            else {
                topCorePlotControl.title = @"订购转化率趋势图";
            }
            topCorePlotControl.yAxis.needRightYAxis = YES;
            topCorePlotControl.layerManager.maxValue = leftMaxValue;
            topCorePlotControl.layerManager.rightMaxValue = orderAndUnCtr.conversionRateData.maxFloatValue;
            HXHeapBarPlot *topRightHeapBarPlot = [HXHeapBarPlot layer];
            topRightHeapBarPlot.dataSource = self;
            topRightHeapBarPlot.needShowValue = YES;
            topRightHeapBarPlot.plotName = @"top_right";
            topRightHeapBarPlot.beginPosition = 0.5;
            topRightHeapBarPlot.endPosition = 0.75;
            
            [topCorePlotControl addPlot:topRightHeapBarPlot];
            HXLinePlot *linePlot = [HXLinePlot layer];
            linePlot.isUseRightAxisY = YES;
            linePlot.lineWidth = 1;
            linePlot.lineColor = [UIColor colorWithHexString:@"a89d97"];
            linePlot.dataSource = self;
            [topCorePlotControl addPlot:linePlot];
            
            
            HXLegendInfo *one = [[HXLegendInfo alloc] init];
            if (kNeedVirtualData) {
                one.legendTitle = @"条目一";
            }
            else {
                one.legendTitle = @"平台新增自订购";
            }
            one.color = [UIColor colorWithHexString:@"aba2f0"];
            HXLegendInfo *two = [[HXLegendInfo alloc] init];
            if (kNeedVirtualData) {
                two.legendTitle = @"条目二";
            }
            else {
                two.legendTitle = @"平台退订";
            }
            two.color = [UIColor colorWithHexString:@"7ee4ed"];
           // topCorePlotControl.legendList = @[one, two];
            
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
        }
            
            break;
        case 1:
        {
            CGFloat leftMaxValue = orderAndUnCtr.orderData.maxFloatValue > orderAndUnCtr.unsubscribeData.maxFloatValue ? orderAndUnCtr.orderData.maxFloatValue : orderAndUnCtr.unsubscribeData.maxFloatValue;
            topCorePlotControl.layerManager.maxValue = leftMaxValue;
            
            if (kNeedVirtualData) {
                topCorePlotControl.title = @"图表名称二";
            }
            else {
                topCorePlotControl.title = @"订购转化率趋势图";
            }
            topCorePlotControl.yAxis.needRightYAxis = NO;
            HXHeapBarPlot *topRightHeapBarPlot = [HXHeapBarPlot layer];
            topRightHeapBarPlot.dataSource = self;
            topRightHeapBarPlot.needShowValue = YES;
            topRightHeapBarPlot.plotName = @"top_right";
            topRightHeapBarPlot.beginPosition = 0.5;
            topRightHeapBarPlot.endPosition = 0.75;
            [topCorePlotControl addPlot:topRightHeapBarPlot];
//            HXLinePlot *linePlot = [HXLinePlot layer];
            //            linePlot.lineWidth = 1;
            //            linePlot.lineColor = [UIColor colorWithHexString:@"a89d97"];
            //            linePlot.dataSource = self;
            //            [topCorePlotControl addPlot:linePlot];
            
            HXLegendInfo *one = [[HXLegendInfo alloc] init];
            if (kNeedVirtualData) {
                one.legendTitle = @"条目一";
            }
            else {
                one.legendTitle = @"CRM订购";
            }
            one.color = [UIColor colorWithHexString:@"aba2f0"];
            HXLegendInfo *two = [[HXLegendInfo alloc] init];
            if (kNeedVirtualData) {
                two.legendTitle = @"条目二";
            }
            else {
                two.legendTitle = @"CRM退订";
            }
            two.color = [UIColor colorWithHexString:@"7ee4ed"];
            HXLegendInfo *three = [[HXLegendInfo alloc] init];
            three.legendTitle = @"转化率";
            three.fillHeight = 1;
            three.fillWidth = 30;
            three.color = [UIColor colorWithHexString:@"a89d97"];
            topCorePlotControl.legendList = @[one, two];
        }
            break;
        case 2:
        {
            if (kNeedVirtualData) {
                topCorePlotControl.title = @"图表名称三";
            }
            else {
                topCorePlotControl.title = @"按次订购统计图";
            }
            topCorePlotControl.yAxis.needRightYAxis = NO;
            topCorePlotControl.layerManager.maxValue = orderAndUnCtr.timesData.maxFloatValue;
            HXLegendInfo *one = [[HXLegendInfo alloc] init];
            if (kNeedVirtualData) {
                one.legendTitle = @"条目一";
            }
            else {
                one.legendTitle = @"按次";
            }
            one.color = [UIColor colorWithHexString:@"aba2f0"];
            topCorePlotControl.legendList = @[one];
        }
            break;
            
        default:
            break;
    }
    [topCorePlotControl reloadData];
}

- (void)changeValueAction:(MEDragSegmentedControl *)control {
    if ([control isEqual:rightTopSegControl]) {
        orderAndUnCtr.selectedMainType = control.selectedIndex;
        [self refreshTopControl];
    }
    else if ([control isEqual:rightBottomSegControl]) {
        bottomCorePlotControl.title = rightBottomSegControl.selectedTitle;
        NSArray *titles = nil;
        NSArray *colors = @[[UIColor colorWithHexString:@"6191b9"],[UIColor colorWithHexString:@"73a8d6"],[UIColor colorWithHexString:@"87bceb"],[UIColor colorWithHexString:@"a8d6ff"]];
        switch (rightBottomSegControl.selectedIndex) {
            case 0:
            {
                NSMutableArray *tempArray = [NSMutableArray array];
                for (int i = 0; i < 14; i++) {
                    CGFloat sumValue = 0.0;
                    sumValue += [orderAndUnCtr.yunyingData[i] floatValue];
                    sumValue += [orderAndUnCtr.yingxiaoData[i] floatValue];
                    sumValue += [orderAndUnCtr.chanpinData[i] floatValue];
                    sumValue += [orderAndUnCtr.otherData[i] floatValue];
                    [tempArray addObject:[NSNumber numberWithFloat:sumValue]];
                }
                bottomCorePlotControl.layerManager.maxValue = tempArray.maxFloatValue;
            }
                if (kNeedVirtualData) {
                    titles = @[@"条目一", @"条目二", @"条目三", @"条目四"];
                }
                else {
                    titles = @[@"运营部", @"运营商营销部", @"新产品事业部", @"其它"];
                }
                bottomCorePlotControl.unitString = @"个";
                break;
            case 1:
                
            {
                NSMutableArray *tempArray = [NSMutableArray array];
                for (int i = 0; i < 14; i++) {
                    CGFloat sumValue = 0.0;
                    sumValue += [orderAndUnCtr.tingjiData[i] floatValue];
                    sumValue += [orderAndUnCtr.fujiData[i] floatValue];
                    [tempArray addObject:[NSNumber numberWithFloat:sumValue]];
                }
                bottomCorePlotControl.layerManager.maxValue = tempArray.maxFloatValue;
            }
                if (kNeedVirtualData) {
                    titles = @[@"条目一", @"条目二"];
                }
                else {
                    titles = @[@"停机", @"复机"];
                }
                bottomCorePlotControl.unitString = @"个";
                break;
            case 2:
                if (kNeedVirtualData) {
                    titles = @[@"条目一"];
                }
                else {
                    titles = @[@"包月户均信息费"];
                }
                bottomCorePlotControl.layerManager.maxValue = orderAndUnCtr.baoyueData.maxFloatValue;
                bottomCorePlotControl.unitString = @"元/户";
                break;
            case 3:
                if (kNeedVirtualData) {
                    titles = @[@"条目一"];
                }
                else {
                    titles = @[@"按次户均信息费"];
                }
                bottomCorePlotControl.layerManager.maxValue = orderAndUnCtr.anciData.maxFloatValue;
                bottomCorePlotControl.unitString = @"元/户";
                break;
            default:
                break;
        }
        NSMutableArray *legends = [NSMutableArray array];
        for (int i = 0; i < [titles count]; i++) {
            HXLegendInfo *legend = [[HXLegendInfo alloc] init];
            legend.color = colors[i];
            legend.legendTitle = titles[i];
            [legends addObject:legend];
        }
        bottomCorePlotControl.legendList = legends;
        [bottomCorePlotControl reloadData];
    }
    else {
        orderAndUnCtr.selectedProvinceType = control.selectedIndex;
        [self refreshChinaMap];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

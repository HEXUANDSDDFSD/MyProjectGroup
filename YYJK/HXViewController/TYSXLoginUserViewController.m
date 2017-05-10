//
//  TYSXLoginUserViewController.m
//  tysx
//
//  Created by zwc on 14/11/17.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "TYSXLoginUserViewController.h"
#import "HXCorePlot.h"
#import "TYSXLoginUserCtr.h"
#import "NSArray+Category.h"
#import "OSSDrawCell.h"

#if kNeedVirtualData
    #define kLoginName @"图表2"
    #define kPlayName @"图表3"
    #define kOrderName @"图表4"
#else
    #define kLoginName @"图表：新老登录用户统计"
    #define kPlayName @"图表：新老登录用户播放统计"
    #define kOrderName @"图表：新老登录用户订购统计"
#endif

@interface TYSXLoginUserViewController ()<UITableViewDataSource, UITableViewDelegate, OSSDrawCellDelegate, HXCoreplotXAxisDataSource, HXCorePlotYAxisDataSource, HXBaseDataSource, HXHeapBarPlotDataSource>

@end

@implementation TYSXLoginUserViewController {
    TYSXLoginUserCtr *dataCtr;
    UITableView *leftTableView;
    HXCorePlotControl *sumPlot;
    HXCorePlotControl *loginPlot;
    HXCorePlotControl *playPlot;
    HXCorePlotControl *orderPlot;
}

- (id)initWithPlotName:(NSString *)_plotName {
    if (self = [super initWithPlotName:_plotName]) {
        dataCtr = (TYSXLoginUserCtr *)cachePlotCtr;
    }
    return self;
}

+ (Class)cachePlotCtr {
    return [TYSXLoginUserCtr class];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat offsetTop = 130;
    
    leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, offsetTop, 256, kScreenWidth - offsetTop)];
    leftTableView.delegate = self;
    leftTableView.dataSource = self;
    leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:leftTableView];
    
    sumPlot = [[HXCorePlotControl alloc] initWithFrame:CGRectMake(leftTableView.width, 52, kScreenHeight - leftTableView.width, 300)];
    if  (kNeedVirtualData) {
        sumPlot.title = @"图表一";
    }
    else {
        sumPlot.title = @"图表：登录用户数";
    }
    sumPlot.layerManager.paddingLeft = 20;
    sumPlot.layerManager.paddingBottom = 45;
    sumPlot.layerManager.paddingTop = 20;
    sumPlot.layerManager.paddingRight = 20;
    sumPlot.xAxis.dataSource = self;
    sumPlot.yAxis.dataSource = self;
    sumPlot.layerManager.maxValue = 20;
    [self.view addSubview:sumPlot];
    
    HXLinePlot *linePlot = [HXLinePlot layer];
    linePlot.lineColor = [UIColor colorWithHexString:@"fa6060"];
    linePlot.lineWidth = 1;
    linePlot.dataSource = self;
    [sumPlot addPlot:linePlot];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(sumPlot.x, sumPlot.y + sumPlot.height, sumPlot.width, kScreenWidth - sumPlot.height)];
    scrollView.backgroundColor = [UIColor colorWithHexString:@"fcfcfc"];
    [self.view addSubview:scrollView];
    
    offsetTop = 0;
    loginPlot = [self heapControlWidthPlotName:kLoginName];
    loginPlot.frame = CGRectMake(0, offsetTop, scrollView.width, 300);
    loginPlot.userInteractionEnabled = NO;
    
    HXLegendInfo *lFirstLegend = [[HXLegendInfo alloc] init];
    lFirstLegend.legendTitle = @"新";
    lFirstLegend.color = [UIColor colorWithHexString:@"fae660"];
    HXLegendInfo *lSecondLegend = [[HXLegendInfo alloc] init];
    lSecondLegend.color = [UIColor colorWithHexString:@"fa6060"];
    lSecondLegend.legendTitle = @"老";
    loginPlot.legendList = @[lFirstLegend, lSecondLegend];
    
    [scrollView addSubview:loginPlot];
    
    offsetTop += loginPlot.height;
    playPlot = [self heapControlWidthPlotName:kPlayName];
    playPlot.frame = CGRectMake(0, offsetTop, scrollView.width, 300);
    playPlot.userInteractionEnabled = NO;
    [scrollView addSubview:playPlot];
    HXLegendInfo *pFirstLegend = [[HXLegendInfo alloc] init];
    pFirstLegend.legendTitle = @"新";
    pFirstLegend.color = [UIColor colorWithHexString:@"73b2c4"];
    HXLegendInfo *pSecondLegend = [[HXLegendInfo alloc] init];
    pSecondLegend.color = [UIColor colorWithHexString:@"bb73c4"];
    pSecondLegend.legendTitle = @"老";
    playPlot.legendList = @[pFirstLegend, pSecondLegend];
    
    offsetTop += playPlot.height;
    orderPlot = [self heapControlWidthPlotName:kOrderName];
    orderPlot.frame = CGRectMake(0, offsetTop, scrollView.width, 300);
    orderPlot.userInteractionEnabled = NO;
    [scrollView addSubview:orderPlot];
    HXLegendInfo *oFirstLegend = [[HXLegendInfo alloc] init];
    oFirstLegend.legendTitle = @"新";
    oFirstLegend.color = [UIColor colorWithHexString:@"e06c92"];
    HXLegendInfo *oSecondLegend = [[HXLegendInfo alloc] init];
    oSecondLegend.color = [UIColor colorWithHexString:@"1aadb2"];
    oSecondLegend.legendTitle = @"老";
    orderPlot.legendList = @[oFirstLegend, oSecondLegend];
    offsetTop += orderPlot.height;
    scrollView.contentSize = CGSizeMake(scrollView.width, 1000);

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [leftTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    [self refreshAllView];
    // Do any additional setup after loading the view.
}

- (void)refreshAllView {
    [super refreshAllView];
    [leftTableView reloadData];
    [self refreshPlotView];
}

- (void)refreshPlotView {
    sumPlot.layerManager.maxValue = dataCtr.loginUserNumList.maxValue.longLongValue;
    [sumPlot reloadData];
    playPlot.layerManager.maxValue = [self maxValueWithDataArray:dataCtr.playList];
    [playPlot reloadData];
    orderPlot.layerManager.maxValue = [self maxValueWithDataArray:dataCtr.orderList];
    [orderPlot reloadData];
    loginPlot.layerManager.maxValue = [self maxValueWithDataArray:dataCtr.loginList];
    [loginPlot reloadData];
}

- (long long)maxValueWithDataArray:(NSArray *)dataArray {
    NSMutableArray *retArr = [NSMutableArray array];
    for (int i = 0; i < [dataArray count]; i++) {
        NSDictionary *dic = dataArray[i];
        long long retValue = [dic[kOldKey] longLongValue] + [dic[kNewKey] longLongValue];
        [retArr addObject:[NSNumber numberWithLongLong:retValue]];
    }
    return [[retArr maxValue] longLongValue];
}

- (HXCorePlotControl *)heapControlWidthPlotName:(NSString *)plotName_ {
   HXCorePlotControl *heapControl = [[HXCorePlotControl alloc] initWithFrame:CGRectZero];
    heapControl.legendOriginPoint = CGPointMake(30, 20);
    heapControl.title = plotName_;
    heapControl.layerManager.paddingLeft = 20;
    heapControl.layerManager.paddingBottom = 45;
    heapControl.layerManager.paddingTop = 20;
    heapControl.layerManager.paddingRight = 20;
    heapControl.layerManager.insetLeft = 30;
    heapControl.layerManager.insetRight = 30;
    heapControl.xAxis.dataSource = self;
    heapControl.yAxis.dataSource = self;
    heapControl.layerManager.maxValue = 20;
    
    HXHeapBarPlot *heapBarPlot = [HXHeapBarPlot layer];
    heapBarPlot.dataSource = self;
    heapBarPlot.plotName = plotName_;
    heapBarPlot.beginPosition = 0.25;
    heapBarPlot.endPosition = 0.75;
    [heapControl addPlot:heapBarPlot];
    return heapControl;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfPlot:(HXBasePlot *)plot {
    return [dataCtr.loginUserNumList count];
}

- (NSNumber *)plot:(HXBasePlot *)plot index:(NSInteger)index {
    return dataCtr.loginUserNumList[index];
}

- (NSInteger)numberOfTitleInXAxis:(HXCoreplotXAxisLayer *)xAxis {
    return 5;
}

- (NSString *)xAxis:(HXCoreplotXAxisLayer *)xAxis titleAtIndex:(NSInteger)index {
    return @"";
}

- (NSInteger)numberOfTitleInYAxis:(HXCorePlotYAxisLayer *)yAxis {
    return 1;
}

- (NSString *)yAxis:(HXCorePlotYAxisLayer *)yAxis titleAtIndex:(NSInteger)index isUseRightYAxis:(BOOL)isUseRight {
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataCtr.clientList count];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    dataCtr.selectedPlatIndex = indexPath.row;
    [self refreshPlotView];
    return indexPath;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *identifier = @"left_cell";
    OSSDrawCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[OSSDrawCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.drawDelegate = self;
    }
//    if (indexPath.row == dataCtr.selectedPlatIndex) {
//        cell.selected = YES;
//    }
    return cell;
}

- (void)drawCell:(OSSDrawCell *)cell rect:(CGRect)rect {
    
    //        drawView.layer.borderColor = [UIColor colorWithHexString:@"f5f5f5"].CGColor;
    //        drawView.layer.borderWidth = 2;
  //  drawView.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if (cell.selected) {
        CGContextSetFillColorWithColor(ctx, [UIColor colorWithHexString:@"f7f7f7"].CGColor);
        CGContextFillRect(ctx, UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(0, 0, 5, 0)));
    }
    
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithHexString:@"f5f5f5"].CGColor);
    CGContextSetLineWidth(ctx, 2);
    CGContextAddRect(ctx, UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(1, 1, 1, 1)));
    CGContextStrokePath(ctx);
    
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    [attr setValue:[UIFont systemFontOfSize:20] forKey:NSFontAttributeName];
    [attr setValue:[UIColor colorWithHexString:@"3a53c1"] forKey:NSForegroundColorAttributeName];
    NSMutableParagraphStyle *para = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    para.alignment = NSTextAlignmentRight;
    [attr setValue:para forKey:NSParagraphStyleAttributeName];
    
    CGFloat offsetTop = 20;
    
    NSIndexPath *indexPath = [leftTableView indexPathForCell:cell];
    NSString *clientName = dataCtr.clientList[indexPath.row][kClientNameKey];
    
    [clientName drawInRect:CGRectMake(0, offsetTop, rect.size.width - 20, 24) withAttributes:attr];
    
    offsetTop += 20 + 10;
    [attr setValue:[UIFont systemFontOfSize:36] forKey:NSFontAttributeName];
    [attr setValue:[UIColor darkGrayColor] forKey:NSForegroundColorAttributeName];
    [[NSString stringWithFormat:@"%lld次", [dataCtr.clientList[indexPath.row][kSumLoginKey] longLongValue]] drawInRect:CGRectMake(0, offsetTop, rect.size.width - 20, 40) withAttributes:attr];
    
    offsetTop += 36 + 15;
    CGFloat paddingRight = 20;
    CGFloat offsetLeft = rect.size.width - paddingRight;
    NSString *tongbiStr = [NSString stringWithFormat:@"%.2f%%", [dataCtr.clientList[indexPath.row][kTongbiKey] doubleValue] * 100];
    [attr setValue:[UIFont systemFontOfSize:24] forKey:NSFontAttributeName];
    [attr setValue:[UIColor colorWithHexString:@"3bcc49"] forKey:NSForegroundColorAttributeName];
    CGFloat fontWidth = [tongbiStr sizeWithAttributes:attr].width;
    offsetLeft -= fontWidth;
    [tongbiStr drawAtPoint:CGPointMake(offsetLeft, offsetTop) withAttributes:attr];
    
    [attr setObject:[UIFont systemFontOfSize:12] forKey:NSFontAttributeName];
    [attr setObject:[UIColor grayColor] forKey:NSForegroundColorAttributeName];
    [@"同比：" drawAtPoint:CGPointMake(offsetLeft - 35, offsetTop + 10) withAttributes:attr];
    [[UIImage imageNamed:@"increase.png"] drawAtPoint:CGPointMake(offsetLeft - 60, offsetTop + 10)];
    
    offsetTop += 23 + 15;
    paddingRight = 20;
    offsetLeft = rect.size.width - paddingRight;
    NSString *huanbiStr = [NSString stringWithFormat:@"%.2f%%", [dataCtr.clientList[indexPath.row][kHuanbiKey] doubleValue] * 100];
    [attr setValue:[UIFont systemFontOfSize:24] forKey:NSFontAttributeName];
    [attr setValue:[UIColor colorWithHexString:@"ff0000"] forKey:NSForegroundColorAttributeName];
    fontWidth = [huanbiStr sizeWithAttributes:attr].width;
    offsetLeft -= fontWidth;
    [huanbiStr drawAtPoint:CGPointMake(offsetLeft, offsetTop) withAttributes:attr];
    
    [attr setObject:[UIFont systemFontOfSize:12] forKey:NSFontAttributeName];
    [attr setObject:[UIColor grayColor] forKey:NSForegroundColorAttributeName];
    [@"环比：" drawAtPoint:CGPointMake(offsetLeft - 35, offsetTop + 10) withAttributes:attr];
    [[UIImage imageNamed:@"reduce.png"] drawAtPoint:CGPointMake(offsetLeft - 60, offsetTop + 10)];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 180;
}

- (NSInteger)numberOfXValuesInHeapBarPlot:(HXHeapBarPlot *)heapBarPlot {
    return kDateSpan;
}

- (NSInteger)numberOfHeapBarInHeapBarPlot:(HXHeapBarPlot *)heapBarPlot {
    return 2;
}

- (NSNumber *)heapBarPlot:(HXHeapBarPlot *)heapBarPlot valueOfXIndex:(NSInteger)xIndex heapIndex:(NSInteger)heapIndex {
    NSNumber *ret = nil;
    NSArray *useArray = nil;
    if ([heapBarPlot.plotName isEqualToString:kLoginName]) {
        useArray = dataCtr.loginList;
    }
    else if ([heapBarPlot.plotName isEqualToString:kPlayName]) {
        useArray = dataCtr.playList;
    }
    else {
        useArray = dataCtr.orderList;
    }
    switch (heapIndex) {
        case 0:
            ret = useArray[xIndex][kOldKey];
            break;
        case 1:
            ret = useArray[xIndex][kNewKey];
            break;
            
        default:
            break;
    }
    return ret;
}

- (UIColor *)heapBarPlot:(HXHeapBarPlot *)heapBarPlot colorOfHeapIndex:(NSInteger)heapIndex {
    UIColor *ret = nil;
    switch (heapIndex) {
        case 0:
            if ([heapBarPlot.plotName isEqualToString:kLoginName]) {
                ret = [UIColor colorWithHexString:@"fae660"];
            }
            else if ([heapBarPlot.plotName isEqualToString:kPlayName]) {
                ret = [UIColor colorWithHexString:@"73b2c4"];
            }
            else {
                ret = [UIColor colorWithHexString:@"e06c92"];
            }
            break;
        case 1:
            if ([heapBarPlot.plotName isEqualToString:kLoginName]) {
                ret = [UIColor colorWithHexString:@"fa6060"];
            }
            else if ([heapBarPlot.plotName isEqualToString:kPlayName]) {
                ret = [UIColor colorWithHexString:@"bb73c4"];
            }
            else {
                ret = [UIColor colorWithHexString:@"1aadb2"];
            }
            break;
            
        default:
            break;
    }
    return ret;
}

@end

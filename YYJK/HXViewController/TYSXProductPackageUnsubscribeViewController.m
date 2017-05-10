//
//  TYSXProductPackageUnsubscribeViewController.m
//  tysx
//
//  Created by zwc on 14/11/26.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "TYSXProductPackageUnsubscribeViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "TYSXProductPackageUnsubscribeCtr.h"
#import "NSArray+Category.h"
#import "OSSDrawCell.h"
#import "HXCorePlot.h"

@interface TYSXProductPackageUnsubscribeViewController ()<HXCoreplotXAxisDataSource, HXCorePlotYAxisDataSource, UIScrollViewDelegate, HXBaseDataSource, UITableViewDataSource, UITableViewDelegate, OSSDrawCellDelegate>

@end

@implementation TYSXProductPackageUnsubscribeViewController {
    TYSXProductPackageUnsubscribeCtr *dataCtr;
    HXCorePlotControl *sumPlotControl;
    HXCorePlotControl *productPlotControl;
    UITableView *bottomSelectTableView;
}

- (id)initWithPlotName:(NSString *)_plotName {
    if (self = [super initWithPlotName:_plotName]) {
        dataCtr = (TYSXProductPackageUnsubscribeCtr *)cachePlotCtr;
    }
    return self;
}

+ (Class)cachePlotCtr {
    return [TYSXProductPackageUnsubscribeCtr class];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat offsetTop = 3;
    CGFloat offsetLeft = 270;
    CGFloat controlHeight = 220;
    
//    MESegmentedControl *segementedControl = [[MESegmentedControl alloc] initWithTitle:@[@"流量", @"次数", @"时长", @"PPV"]];
//    segementedControl.x = 644;
//    segementedControl.y = offsetTop;
//    segementedControl.font = [UIFont systemFontOfSize:20];
//    segementedControl.everyWidth = 80;
//    segementedControl.itemHeight = 43;
//    segementedControl.borderColor = [UIColor colorWithHexString:@"f5f5f5"];
//    segementedControl.seletedBgColor = [UIColor colorWithHexString:@"f5f5f5"];
//    segementedControl.selectedTitleColor = [UIColor darkGrayColor];
//    segementedControl.normalTitleColor = [UIColor grayColor];
//    // segementedControl.selectedTitleColor = [UIColor colorWithHexString:@"f5f5f5"];
//    [segementedControl addTarget:self action:@selector(changeSegementIndex:) forControlEvents:UIControlEventValueChanged];
//    [self.view addSubview:segementedControl];
    
    offsetTop += 73;
    
    sumPlotControl = [self linePlotControlWithTtile:@"图表：退订总数" lineColor:[UIColor redColor]];
    sumPlotControl.frame = CGRectMake(offsetLeft, offsetTop, kScreenHeight - offsetLeft, controlHeight);
    [self.view addSubview:sumPlotControl];
    
    offsetTop += sumPlotControl.height;
    productPlotControl = [self linePlotControlWithTtile:@"图表：产品包退订统计" lineColor:[UIColor colorWithHexString:@"1a8291"]];
    productPlotControl.frame = CGRectMake(offsetLeft, offsetTop, kScreenHeight - offsetLeft, controlHeight);
    [self.view addSubview:productPlotControl];
    
    offsetTop = 550;
    bottomSelectTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, offsetTop, kScreenHeight, kScreenHeight - offsetTop)];
    bottomSelectTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    bottomSelectTableView.dataSource = self;
    bottomSelectTableView.delegate = self;
    [self.view addSubview:bottomSelectTableView];
    
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, bottomSelectTableView.height - 30)];
    bottomSelectTableView.tableFooterView = tableFooterView;
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, bottomSelectTableView.y - 40, kScreenHeight, 10);
    gradientLayer.colors = @[(id)[UIColor colorWithHexString:@"e5e5e5"].CGColor, (id)[[UIColor colorWithHexString:@"e5e5e5"] colorWithAlphaComponent:0.0].CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    [self.view.layer addSublayer:gradientLayer];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    CGFloat top = 7;
    CGFloat height = 18;
    shapeLayer.frame = CGRectMake(0, bottomSelectTableView.y, kScreenHeight, 30);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, &CGAffineTransformIdentity, shapeLayer.bounds);
    CGPathAddRect(path, &CGAffineTransformIdentity, CGRectMake(18, top, 140, height));
    CGPathAddRect(path, &CGAffineTransformIdentity, CGRectMake(175, top, 83, height));
    CGPathAddRect(path, &CGAffineTransformIdentity, CGRectMake(283, top, 78, height));
    CGPathAddRect(path, &CGAffineTransformIdentity, CGRectMake(371, top, 111, height));
    CGPathAddRect(path, &CGAffineTransformIdentity, CGRectMake(490, top, 111, height));
    CGPathAddRect(path, &CGAffineTransformIdentity, CGRectMake(611, top, 97, height));
    CGPathAddRect(path, &CGAffineTransformIdentity, CGRectMake(730, top, 97, height));
    CGPathAddRect(path, &CGAffineTransformIdentity, CGRectMake(850, top, 152, height));
    shapeLayer.fillRule = kCAFillRuleEvenOdd;
    shapeLayer.fillColor = [UIColor colorWithHexString:@"ebebeb"].CGColor;
    //shapeLayer.backgroundColor = [UIColor redColor].CGColor;
    shapeLayer.path = path;
    CGPathRelease(path);
    [self.view.layer addSublayer:shapeLayer];
    
    [self refreshAllView];
}

- (void)drawCell:(OSSDrawCell *)cell rect:(CGRect)rect {
    CGFloat offsetTop = 8;
    NSArray *originXList = @[@20.0, @179.0, @285.0, @391.0, @500.0, @612.0, @734.0, @852];
    NSInteger row = [bottomSelectTableView indexPathForCell:cell].row;
    
    NSDictionary *contentDic = dataCtr.productList[row];
    NSMutableArray *contentList = [NSMutableArray array];
    [contentList addObject:contentDic[kProductNameKey]];
    [contentList addObject:dataCtr.lastDateStr];
    [contentList addObject:[NSString stringWithFormat:@"%lld", [contentDic[kUnsubscribeTimesKey] longLongValue]]];
    [contentList addObject:[NSString stringWithFormat:@"%.2f%%", [contentDic[kTongbiKey] doubleValue] * 100]];
    [contentList addObject:[NSString stringWithFormat:@"%.2f%%", [contentDic[kHuanbiKey] doubleValue] * 100]];
    [contentList addObject:[NSString stringWithFormat:@"%lld", [contentDic[kTongbiGapKey] longLongValue]]];
    [contentList addObject:[NSString stringWithFormat:@"%lld", [contentDic[kHuanbiGapKey] longLongValue]]];
    [contentList addObject:contentDic[kLastUpdateTimeKey]];
    
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    [attr setValue:[UIColor grayColor] forKey:NSForegroundColorAttributeName];
    [attr setValue:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName];
    for (int i = 0; i < [contentList count]; i++) {
        NSString *title = contentList[i];
        [title drawAtPoint:CGPointMake([originXList[i] floatValue], offsetTop) withAttributes:attr];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataCtr.productList count];
}

- (UIColor *)radioColorWithLastValue:(long long)lastValue currentValue:(long long)currentValue {
    if (currentValue > lastValue) {
        return [UIColor colorWithHexString:@"3bcc49"];
    }
    else {
        return [UIColor colorWithHexString:@"ff0000"];
    }
}
- (NSString *)radioImageNameWithLastValue:(long long)lastValue currentValue:(long long)currentValue {
    if (currentValue > lastValue) {
        return @"increase.png";
    }
    else {
        return @"reduce.png";
    }
}

- (void)refreshAllView {
    [super refreshAllView];
    [bottomSelectTableView reloadData];
    sumPlotControl.layerManager.maxValue = [[dataCtr.sumTimesList maxValue] longLongValue];
    [sumPlotControl reloadData];
    [self refreshSelectedProductList];
}

- (void)refreshSelectedProductList {
    productPlotControl.layerManager.maxValue = [[dataCtr.currentTimesList maxValue] longLongValue];
    [productPlotControl reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"bottom_info_cell";
    OSSDrawCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[OSSDrawCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.drawDelegate = self;
    }
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    }
    else {
        cell.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (dataCtr.currentProductIndex != (int)scrollView.contentOffset.y / 30) {
        dataCtr.currentProductIndex = (int)scrollView.contentOffset.y / 30;
        //1057
        [self refreshSelectedProductList];
        [bgDrawView setNeedsDisplay];
        //AudioServicesPlaySystemSound(1057);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = (scrollView.contentOffset.y + 15) / 30;
    [scrollView setContentOffset:CGPointMake(0, index * 30) animated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        NSInteger index = (scrollView.contentOffset.y + 15) / 30;
        [scrollView setContentOffset:CGPointMake(0, index * 30) animated:YES];
    }
}

- (HXCorePlotControl *)linePlotControlWithTtile:(NSString *)title lineColor:(UIColor *)lineColor {
    HXCorePlotControl *linePlotControl = [[HXCorePlotControl alloc] initWithFrame:CGRectZero];
    linePlotControl.title = title;
    linePlotControl.layerManager.paddingLeft = 20;
    linePlotControl.layerManager.paddingBottom = 45;
    linePlotControl.layerManager.paddingTop = 20;
    linePlotControl.layerManager.paddingRight = 20;
    linePlotControl.xAxis.dataSource = self;
    linePlotControl.yAxis.dataSource = self;
    linePlotControl.layerManager.maxValue = 20;
    [self.view addSubview:linePlotControl];
    
    HXLinePlot *linePlot = [HXLinePlot layer];
    linePlot.lineColor = lineColor;
    linePlot.lineWidth = 1;
    linePlot.plotName = title;
    linePlot.dataSource = self;
    [linePlotControl addPlot:linePlot];
    
    return linePlotControl;
}

- (NSInteger)numberOfPlot:(HXBasePlot *)plot {
    return kDateSpan;
}

- (NSNumber *)plot:(HXBasePlot *)plot index:(NSInteger)index {
    if ([plot.plotName isEqualToString:@"图表：退订总数"]) {
        return [dataCtr.sumTimesList objectAtIndex:index];
    }
    else {
        return [dataCtr.currentTimesList objectAtIndex:index];
    }
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)contentView:(MYDrawContentView *)view drawRect:(CGRect)rect {
    [super contentView:view drawRect:rect];
    
    long long sumCurrentValue = [dataCtr.sumTimesList[kDateSpan - 1] longLongValue];
    long long sumLastWeakValue = [dataCtr.sumTimesList[kDateSpan - 7] longLongValue];
    long long sumYesterdayValue = [dataCtr.sumTimesList[kDateSpan - 2] longLongValue];
    long long selectedCurrentValue = [dataCtr.currentTimesList[kDateSpan - 1] longLongValue];
    long long selectedLastWeakValue = [dataCtr.currentTimesList[kDateSpan - 7] longLongValue];
    long long selectedYesterdayValue = [dataCtr.currentTimesList[kDateSpan - 2] longLongValue];
    
    CGFloat offsetTop = 125;
    CGFloat rightEdge = 230;
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    NSMutableParagraphStyle *para = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    para.alignment = NSTextAlignmentRight;
    [attr setValue:para forKey:NSParagraphStyleAttributeName];
    
    [attr setValue:[UIFont systemFontOfSize:20] forKey:NSFontAttributeName];
    [attr setValue:[UIColor colorWithHexString:@"3a53c1"] forKey:NSForegroundColorAttributeName];
    
    [@"退订总数" drawInRect:CGRectMake(0, offsetTop, rightEdge, 24) withAttributes:attr];
    
    offsetTop += 20 + 10;
    [attr setValue:[UIFont systemFontOfSize:24] forKey:NSFontAttributeName];
    [attr setValue:[UIColor darkGrayColor] forKey:NSForegroundColorAttributeName];
    [[NSString stringWithFormat:@"%lld次", sumCurrentValue] drawInRect:CGRectMake(0, offsetTop, rightEdge, 40) withAttributes:attr];
    
    offsetTop += 24 + 5;
    CGFloat offsetLeft = rightEdge;
    NSString *tongbiStr = percentageChange(sumYesterdayValue, sumCurrentValue);
    [attr setValue:[UIFont systemFontOfSize:24] forKey:NSFontAttributeName];
    [attr setValue:[self radioColorWithLastValue:sumYesterdayValue currentValue:sumCurrentValue] forKey:NSForegroundColorAttributeName];
    CGFloat fontWidth = [tongbiStr sizeWithAttributes:attr].width;
    offsetLeft -= fontWidth;
    [tongbiStr drawAtPoint:CGPointMake(offsetLeft, offsetTop) withAttributes:attr];
    
    [attr setObject:[UIFont systemFontOfSize:12] forKey:NSFontAttributeName];
    [attr setObject:[UIColor grayColor] forKey:NSForegroundColorAttributeName];
    [@"同比：" drawAtPoint:CGPointMake(offsetLeft - 35, offsetTop + 10) withAttributes:attr];
    [[UIImage imageNamed:[self radioImageNameWithLastValue:sumYesterdayValue currentValue:sumCurrentValue]] drawAtPoint:CGPointMake(offsetLeft - 60, offsetTop + 10)];
    
    offsetTop += 24 + 5;
    [attr setValue:[UIFont systemFontOfSize:18] forKey:NSFontAttributeName];
    [attr setValue:[UIColor grayColor] forKey:NSForegroundColorAttributeName];
    [[NSString stringWithFormat:@"%+lld次", sumCurrentValue - sumYesterdayValue] drawInRect:CGRectMake(0, offsetTop, rightEdge, 20) withAttributes:attr];
    
    offsetTop += 18 + 5;
    offsetLeft = rightEdge;
    NSString *huanbiStr = percentageChange(sumLastWeakValue, sumCurrentValue);
    [attr setValue:[UIFont systemFontOfSize:24] forKey:NSFontAttributeName];
    [attr setValue:[self radioColorWithLastValue:sumLastWeakValue currentValue:sumCurrentValue] forKey:NSForegroundColorAttributeName];
    fontWidth = [huanbiStr sizeWithAttributes:attr].width;
    offsetLeft -= fontWidth;
    [huanbiStr drawAtPoint:CGPointMake(offsetLeft, offsetTop) withAttributes:attr];
    
    [attr setObject:[UIFont systemFontOfSize:12] forKey:NSFontAttributeName];
    [attr setObject:[UIColor grayColor] forKey:NSForegroundColorAttributeName];
    [@"环比：" drawAtPoint:CGPointMake(offsetLeft - 35, offsetTop + 10) withAttributes:attr];
    [[UIImage imageNamed:[self radioImageNameWithLastValue:sumLastWeakValue currentValue:sumCurrentValue]] drawAtPoint:CGPointMake(offsetLeft - 60, offsetTop + 10)];
    
    offsetTop += 24 + 5;
    [attr setValue:[UIFont systemFontOfSize:18] forKey:NSFontAttributeName];
    [attr setValue:[UIColor grayColor] forKey:NSForegroundColorAttributeName];
    [[NSString stringWithFormat:@"%+lld次", sumCurrentValue - sumLastWeakValue] drawInRect:CGRectMake(0, offsetTop, rightEdge, 20) withAttributes:attr];
    
    ///////////////////////////////////////////////////
    offsetTop += 60;
    
    
    [attr setValue:[UIFont systemFontOfSize:20] forKey:NSFontAttributeName];
    [attr setValue:[UIColor colorWithHexString:@"3a53c1"] forKey:NSForegroundColorAttributeName];
    
    if ([dataCtr.productList count] == 0) {
        return;
    }
    
    [dataCtr.productList[dataCtr.currentProductIndex][kProductNameKey] drawInRect:CGRectMake(0, offsetTop, rightEdge, 24) withAttributes:attr];
    
    offsetTop += 20 + 10;
    [attr setValue:[UIFont systemFontOfSize:24] forKey:NSFontAttributeName];
    [attr setValue:[UIColor darkGrayColor] forKey:NSForegroundColorAttributeName];
    [[NSString stringWithFormat:@"%lld次", selectedCurrentValue] drawInRect:CGRectMake(0, offsetTop, rightEdge, 40) withAttributes:attr];
    
    offsetTop += 24 + 5;
    offsetLeft = rightEdge;
    tongbiStr = percentageChange(selectedYesterdayValue, selectedCurrentValue);
    [attr setValue:[UIFont systemFontOfSize:24] forKey:NSFontAttributeName];
    [attr setValue:[self radioColorWithLastValue:selectedYesterdayValue currentValue:selectedCurrentValue] forKey:NSForegroundColorAttributeName];
    fontWidth = [tongbiStr sizeWithAttributes:attr].width;
    offsetLeft -= fontWidth;
    [tongbiStr drawAtPoint:CGPointMake(offsetLeft, offsetTop) withAttributes:attr];
    
    [attr setObject:[UIFont systemFontOfSize:12] forKey:NSFontAttributeName];
    [attr setObject:[UIColor grayColor] forKey:NSForegroundColorAttributeName];
    [@"同比：" drawAtPoint:CGPointMake(offsetLeft - 35, offsetTop + 10) withAttributes:attr];
    [[UIImage imageNamed:[self radioImageNameWithLastValue:selectedYesterdayValue currentValue:selectedCurrentValue]] drawAtPoint:CGPointMake(offsetLeft - 60, offsetTop + 10)];
    
    offsetTop += 24 + 5;
    [attr setValue:[UIFont systemFontOfSize:18] forKey:NSFontAttributeName];
    [attr setValue:[UIColor grayColor] forKey:NSForegroundColorAttributeName];
    [[NSString stringWithFormat:@"%+lld次", selectedCurrentValue - selectedYesterdayValue] drawInRect:CGRectMake(0, offsetTop, rightEdge, 20) withAttributes:attr];
    
    offsetTop += 18 + 5;
    offsetLeft = rightEdge;
    huanbiStr = percentageChange(selectedLastWeakValue, selectedCurrentValue);
    [attr setValue:[UIFont systemFontOfSize:24] forKey:NSFontAttributeName];
    [attr setValue:[self radioColorWithLastValue:selectedLastWeakValue currentValue:selectedCurrentValue] forKey:NSForegroundColorAttributeName];
    fontWidth = [huanbiStr sizeWithAttributes:attr].width;
    offsetLeft -= fontWidth;
    [huanbiStr drawAtPoint:CGPointMake(offsetLeft, offsetTop) withAttributes:attr];
    
    [attr setObject:[UIFont systemFontOfSize:12] forKey:NSFontAttributeName];
    [attr setObject:[UIColor grayColor] forKey:NSForegroundColorAttributeName];
    [@"环比：" drawAtPoint:CGPointMake(offsetLeft - 35, offsetTop + 10) withAttributes:attr];
    [[UIImage imageNamed:[self radioImageNameWithLastValue:selectedLastWeakValue currentValue:selectedCurrentValue]] drawAtPoint:CGPointMake(offsetLeft - 60, offsetTop + 10)];
    
    offsetTop += 24 + 5;
    [attr setValue:[UIFont systemFontOfSize:18] forKey:NSFontAttributeName];
    [attr setValue:[UIColor grayColor] forKey:NSForegroundColorAttributeName];
    [[NSString stringWithFormat:@"%+lld次", selectedCurrentValue - selectedLastWeakValue] drawInRect:CGRectMake(0, offsetTop, rightEdge, 20) withAttributes:attr];
    offsetTop = 520;
    NSArray *bottomTitles = @[@"产品", @"订购日期", @"订购次数", @"同比", @"环比", @"同比差(次)", @"环比差(次)", @"最后修改时间"];
    NSArray *originXList = @[@20.0, @179.0, @285.0, @391.0, @500.0, @612.0, @734.0, @852];
    
    [attr setValue:[UIColor grayColor] forKey:NSForegroundColorAttributeName];
    [attr setValue:[UIFont systemFontOfSize:18] forKey:NSFontAttributeName];
    for (int i = 0; i < [bottomTitles count]; i++) {
        NSString *title = bottomTitles[i];
        [title drawAtPoint:CGPointMake([originXList[i] floatValue], offsetTop) withAttributes:attr];
    }
}

@end

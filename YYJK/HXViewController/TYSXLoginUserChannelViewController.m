//
//  TYSXLoginUserChannelViewController.m
//  tysx
//
//  Created by zwc on 14/11/26.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "TYSXLoginUserChannelViewController.h"
#import "TYSXLoginUserChannelCtr.h"
#import <AudioToolbox/AudioToolbox.h>
#import "OSSDrawCell.h"
#import "HXCorePlot.h"
#import "NSArray+Category.h"

@interface TYSXLoginUserChannelViewController ()<HXCoreplotXAxisDataSource, HXCorePlotYAxisDataSource, UIScrollViewDelegate, HXBaseDataSource, UITableViewDataSource, UITableViewDelegate, OSSDrawCellDelegate>

@end

@implementation TYSXLoginUserChannelViewController {
    UITableView *bottomSelectTableView;
    TYSXLoginUserChannelCtr *dataCtr;
    HXCorePlotControl *sumPlotControl;
    HXCorePlotControl *productPlotControl;
}

- (id)initWithPlotName:(NSString *)_plotName {
    if (self = [super initWithPlotName:_plotName]) {
        dataCtr = (TYSXLoginUserChannelCtr *)cachePlotCtr;
    }
    return self;
}

+ (Class)cachePlotCtr {
    return [TYSXLoginUserChannelCtr class];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSLog(@"%@", dataCtr.sumChannelLoginTimes);
//    
//    NSLog(@"%@", dataCtr.selectedChannelLoginTimes);
    
    CGFloat offsetTop = 3;
    CGFloat offsetLeft = 270;
    CGFloat controlHeight = 220;
    
    offsetTop += 73;
    
    
    sumPlotControl = [self linePlotControlWithTtile:@"图表：登录用户总数" lineColor:[UIColor redColor]];
    sumPlotControl.frame = CGRectMake(offsetLeft, offsetTop, kScreenHeight - offsetLeft, controlHeight);
    [self.view addSubview:sumPlotControl];
    
    offsetTop += sumPlotControl.height;
    productPlotControl = [self linePlotControlWithTtile:@"图表：分渠道登录数" lineColor:[UIColor colorWithHexString:@"1a8291"]];
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
    CGPathAddRect(path, &CGAffineTransformIdentity, CGRectMake(70, top, 150, height));
    CGPathAddRect(path, &CGAffineTransformIdentity, CGRectMake(288, top, 364, height));
    CGPathAddRect(path, &CGAffineTransformIdentity, CGRectMake(696, top, 143, height));
    CGPathAddRect(path, &CGAffineTransformIdentity, CGRectMake(864, top, 145, height));
//    CGPathAddRect(path, &CGAffineTransformIdentity, CGRectMake(490, top, 111, height));
//    CGPathAddRect(path, &CGAffineTransformIdentity, CGRectMake(611, top, 97, height));
//    CGPathAddRect(path, &CGAffineTransformIdentity, CGRectMake(730, top, 97, height));
//    CGPathAddRect(path, &CGAffineTransformIdentity, CGRectMake(850, top, 152, height));
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
    
    NSIndexPath *indexPath = [bottomSelectTableView indexPathForCell:cell];
    NSDictionary *dataDic = dataCtr.channelList[indexPath.row];
    
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    [attr setValue:[UIColor grayColor] forKey:NSForegroundColorAttributeName];
    [attr setValue:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName];
    
    [dataDic[kChannelIdKey] drawAtPoint:CGPointMake(85, offsetTop) withAttributes:attr];
    [dataDic[kChannelNameKey] drawAtPoint:CGPointMake(299, offsetTop) withAttributes:attr];
    [[NSString stringWithFormat:@"%lld", [dataDic[kLoginTimesKey] longLongValue]] drawAtPoint:CGPointMake(705, offsetTop) withAttributes:attr];
    [cachePlotCtr.lastDateStr drawAtPoint:CGPointMake(870, offsetTop) withAttributes:attr];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{    return [dataCtr.channelList count];
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
    if (dataCtr.currentChannelIndex != (int)scrollView.contentOffset.y / 30) {
        dataCtr.currentChannelIndex = (int)scrollView.contentOffset.y / 30;
        //1057
        [self refreshSelectedChannelList];
        [bgDrawView setNeedsDisplay];
        //AudioServicesPlaySystemSound(1057);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = (scrollView.contentOffset.y + 15) / 30;
    if (index != dataCtr.currentChannelIndex) {
        dataCtr.currentChannelIndex = index;
        [self refreshSelectedChannelList];
        [bgDrawView setNeedsDisplay];
    }
    [scrollView setContentOffset:CGPointMake(0, index * 30) animated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        NSInteger index = (scrollView.contentOffset.y + 15) / 30;
        if (index != dataCtr.currentChannelIndex) {
            dataCtr.currentChannelIndex = index;
            [bgDrawView setNeedsDisplay];
            [self refreshSelectedChannelList];
        }
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
    NSNumber *ret = nil;
    if ([plot.plotName isEqualToString:@"图表：登录用户总数"]) {
        ret = dataCtr.sumChannelLoginTimes[index];
    }
    else {
        ret = dataCtr.selectedChannelLoginTimes[index];
    }
    return ret;
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

- (void)refreshAllView {
    [super refreshAllView];
    [bottomSelectTableView reloadData];
    sumPlotControl.layerManager.maxValue = [[dataCtr.sumChannelLoginTimes maxValue] longLongValue];
    [sumPlotControl reloadData];
    [self refreshSelectedChannelList];
}

- (void)refreshSelectedChannelList {
    productPlotControl.layerManager.maxValue = [[dataCtr.selectedChannelLoginTimes maxValue] longLongValue];
    [productPlotControl reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)contentView:(MYDrawContentView *)view drawRect:(CGRect)rect {
    [super contentView:view drawRect:rect];
    
    long long sumToday = [dataCtr.sumChannelLoginTimes[kDateSpan - 1] longLongValue];
    long long sumYesterday = [dataCtr.sumChannelLoginTimes[kDateSpan - 2] longLongValue];
    long long sumLastWeak = [dataCtr.sumChannelLoginTimes[kDateSpan - 7] longLongValue];
    
    CGFloat offsetTop = 125;
    CGFloat rightEdge = 230;
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    NSMutableParagraphStyle *para = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    para.alignment = NSTextAlignmentRight;
    [attr setValue:para forKey:NSParagraphStyleAttributeName];
    
    [attr setValue:[UIFont systemFontOfSize:20] forKey:NSFontAttributeName];
    [attr setValue:[UIColor colorWithHexString:@"3a53c1"] forKey:NSForegroundColorAttributeName];
    
    [@"总数" drawInRect:CGRectMake(0, offsetTop, rightEdge, 24) withAttributes:attr];
    
    offsetTop += 20 + 10;
    [attr setValue:[UIFont systemFontOfSize:24] forKey:NSFontAttributeName];
    [attr setValue:[UIColor darkGrayColor] forKey:NSForegroundColorAttributeName];
    [[NSString stringWithFormat:@"%lld次", [dataCtr.sumChannelLoginTimes[kDateSpan - 1] longLongValue]] drawInRect:CGRectMake(0, offsetTop, rightEdge, 40) withAttributes:attr];
    
    offsetTop += 24 + 5;
    CGFloat offsetLeft = rightEdge;
    NSString *tongbiStr = percentageChange(sumYesterday, sumToday);
    [attr setValue:[UIFont systemFontOfSize:24] forKey:NSFontAttributeName];
    [attr setValue:[self radioColorWithLastValue:sumYesterday currentValue:sumToday] forKey:NSForegroundColorAttributeName];
    CGFloat fontWidth = [tongbiStr sizeWithAttributes:attr].width;
    offsetLeft -= fontWidth;
    [tongbiStr drawAtPoint:CGPointMake(offsetLeft, offsetTop) withAttributes:attr];
    
    [attr setObject:[UIFont systemFontOfSize:12] forKey:NSFontAttributeName];
    [attr setObject:[UIColor grayColor] forKey:NSForegroundColorAttributeName];
    [@"同比：" drawAtPoint:CGPointMake(offsetLeft - 35, offsetTop + 10) withAttributes:attr];
    [[UIImage imageNamed:[self radioImageNameWithLastValue:sumYesterday currentValue:sumToday]] drawAtPoint:CGPointMake(offsetLeft - 60, offsetTop + 10)];
    
//    offsetTop += 24 + 5;
//    [attr setValue:[UIFont systemFontOfSize:18] forKey:NSFontAttributeName];
//    [attr setValue:[UIColor grayColor] forKey:NSForegroundColorAttributeName];
//    [@"+234GB" drawInRect:CGRectMake(0, offsetTop, rightEdge, 20) withAttributes:attr];
    
    offsetTop += 18 + 5;
    offsetLeft = rightEdge;
    NSString *huanbiStr = percentageChange(sumLastWeak, sumToday);
    [attr setValue:[UIFont systemFontOfSize:24] forKey:NSFontAttributeName];
    [attr setValue:[self radioColorWithLastValue:sumLastWeak currentValue:sumToday] forKey:NSForegroundColorAttributeName];
    fontWidth = [huanbiStr sizeWithAttributes:attr].width;
    offsetLeft -= fontWidth;
    [huanbiStr drawAtPoint:CGPointMake(offsetLeft, offsetTop) withAttributes:attr];
    
    [attr setObject:[UIFont systemFontOfSize:12] forKey:NSFontAttributeName];
    [attr setObject:[UIColor grayColor] forKey:NSForegroundColorAttributeName];
    [@"环比：" drawAtPoint:CGPointMake(offsetLeft - 35, offsetTop + 10) withAttributes:attr];
    
    [[UIImage imageNamed:[self radioImageNameWithLastValue:sumLastWeak currentValue:sumToday]] drawAtPoint:CGPointMake(offsetLeft - 60, offsetTop + 10)];
    
//    offsetTop += 24 + 5;
//    [attr setValue:[UIFont systemFontOfSize:18] forKey:NSFontAttributeName];
//    [attr setValue:[UIColor grayColor] forKey:NSForegroundColorAttributeName];
//    [@"-2134GB" drawInRect:CGRectMake(0, offsetTop, rightEdge, 20) withAttributes:attr];
    
    
    
    
    ///////////////////////////////////////////////////
    offsetTop += 100;
    
    
    [attr setValue:[UIFont systemFontOfSize:20] forKey:NSFontAttributeName];
    [attr setValue:[UIColor colorWithHexString:@"3a53c1"] forKey:NSForegroundColorAttributeName];
    
    if ([dataCtr.channelList count] != 0) {
        NSDictionary *channelDic = dataCtr.channelList[dataCtr.currentChannelIndex];
        CGFloat nameHeight = 0;
        [channelDic[kChannelNameKey] drawInRect:CGRectMake(10, offsetTop, rightEdge - 10, 80) withAttributes:attr];
        
        nameHeight = [channelDic[kChannelNameKey] boundingRectWithSize:CGSizeMake(rightEdge - 10, 300) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attr context:NULL].size.height;
        
        offsetTop += nameHeight + 30;
        [attr setValue:[UIFont systemFontOfSize:24] forKey:NSFontAttributeName];
        [attr setValue:[UIColor darkGrayColor] forKey:NSForegroundColorAttributeName];
        [[NSString stringWithFormat:@"%lld次", [channelDic[kLoginTimesKey] longLongValue]] drawInRect:CGRectMake(0, offsetTop, rightEdge, 40) withAttributes:attr];
    }
    
    offsetTop = 520;
    NSArray *bottomTitles = @[@"渠道ID", @"渠道", @"登录次数", @"登录日期"];
    NSArray *originXList = @[@85.0, @293.0, @708.0, @875.0];
    
    [attr setValue:[UIColor grayColor] forKey:NSForegroundColorAttributeName];
    [attr setValue:[UIFont systemFontOfSize:18] forKey:NSFontAttributeName];
    for (int i = 0; i < [bottomTitles count]; i++) {
        NSString *title = bottomTitles[i];
        [title drawAtPoint:CGPointMake([originXList[i] floatValue], offsetTop) withAttributes:attr];
    }
}

@end

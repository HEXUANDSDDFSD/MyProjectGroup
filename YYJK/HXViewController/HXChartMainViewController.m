//
//  HXChartMainViewController.m
//  tysx
//
//  Created by zwc on 13-11-12.
//  Copyright (c) 2013年 huangjia. All rights reserved.
//

#import "HXChartMainViewController.h"
#import "HXChartDataSimpleCell.h"
#import "TYSXChartDataCtr.h"
#import "HXChartDataDetailCell.h"
#import "NSNumber+Format.h"
#import "HXMainDataView.h"
#import "MyListSelectorView.h"
#import "HXMeasureView.h"
#import "HXListLabelView.h"
#import "MyPlotView.h"
#import "MyDragListView.h"
#import <objc/runtime.h>
#import "HXSegmentedControl.h"

#define kHorizonalTableTag 1000
#define kVerticalTableTag 1005
#define kHorizonalCellWidth 200
#define kVerticalCellWidth kScreenHeight
#define kVerticalCellHeight 40
#define kHorizonalCellHeight 141

@interface HXChartMainViewController ()<UITableViewDataSource, UITableViewDelegate, MYDrawContentViewDrawDelegate, MyListSelectorViewDelegate, MyListSelectorViewDataSource, HXSegmentedControlDelegate>

@end

@implementation HXChartMainViewController {
    UITableView *verticalView;
    NSInteger selectedIndex;
    HXMainDataView *mainDataView;
    TYSXChartDataCtr *tysxChartCtr;
    MyPlotView *plotView;
}

- (id)initWithPlotName:(NSString *)name {
    self = [super initWithPlotName:name];
    if (self) {
        tysxChartCtr = [[TYSXChartDataCtr alloc] init];
        tysxChartCtr.dimensionType = DimensionType_All;
        [tysxChartCtr reloadData];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    int offsetTop = 0;
    
    offsetTop += 44;
    
   //[tysxChartCtr updateData];
    
    mainDataView = [[HXMainDataView alloc] initWithFrame:CGRectMake(0, offsetTop, kScreenHeight, 500)];
    mainDataView.userInteractionEnabled = NO;
    mainDataView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:mainDataView];
    [self refreshMainView];
    
    plotView = [[MyPlotView alloc] initWithFrame:CGRectMake(250, 70, kScreenHeight - 250, 560)];
    plotView.backgroundColor = [UIColor clearColor];
    plotView.paddingLeft = 80;
    plotView.paddingBottom = 80;
    plotView.paddingTop = 80;
    plotView.paddingRight = 20;
    plotView.plotpaddingLeft = 0;
    plotView.plotPaddingRight = 0;
    
    [self refreshPlotView];
    
    [self.view addSubview:plotView];
    
    
    offsetTop += 320;
    
    UITableView *horizontalView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kHorizonalCellHeight, kScreenHeight) style:UITableViewStylePlain];
    horizontalView.tag = kHorizonalTableTag;
    horizontalView.delegate = self;
    horizontalView.backgroundColor = [UIColor clearColor];
    horizontalView.separatorStyle = UITableViewCellSeparatorStyleNone;
    horizontalView.dataSource = self;
    horizontalView.transform=CGAffineTransformMakeRotation(-M_PI/2);
    horizontalView.frame = CGRectMake(0, kScreenWidth - horizontalView.bounds.size.width - 25, horizontalView.bounds.size.height, horizontalView.bounds.size.width);
    horizontalView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:horizontalView];
    
    offsetTop += horizontalView.frame.size.height;
    //    labelView = [[HXListLabelView alloc] initWithFrame:CGRectMake(0, offsetTop, kScreenHeight, 30)];
    //    labelView.monthStr = [monthArr objectAtIndex:selectedIndex];
    //    labelView.backgroundColor = [UIColor whiteColor];
    //    [self.view addSubview:labelView];
    //
    //    offsetTop += 30;
    offsetTop += 10;
    
    verticalView = [[UITableView alloc] initWithFrame:CGRectMake(0, offsetTop, kVerticalCellWidth, kScreenWidth - offsetTop) style:UITableViewStylePlain];
    verticalView.tag = kVerticalTableTag;
    verticalView.delegate = self;
    verticalView.separatorStyle = UITableViewCellSeparatorStyleNone;
    verticalView.dataSource = self;
    verticalView.showsVerticalScrollIndicator = NO;
   // [self.view addSubview:verticalView];
    
    //    UIView *alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, verticalView.frame.origin.y, verticalView.bounds.size.width, 40)];
    //    alphaView.backgroundColor = [UIColor grayColor];
    //    alphaView.alpha = 0.5;
    //    alphaView.userInteractionEnabled = NO;
    //    [self.view addSubview:alphaView];
    
    
    UIView *verticalViewFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenHeight, verticalView.bounds.size.height - 40)];
    //verticalViewHeaderView.backgroundColor = [UIColor whiteColor];
    verticalView.tableFooterView = verticalViewFooterView;
    
    if (!isGuest()) {
        HXSegmentedControl *segmentControl = [[HXSegmentedControl alloc] initWithItems:@[@"总量", @"自然", @"推广"]];
        segmentControl.needBorder = YES;
        segmentControl.itemHeight = 40;
        segmentControl.itemWidth = 70;
        segmentControl.delegate = self;
        segmentControl.selectedColor = [UIColor lightBlueColor];
        segmentControl.frame = CGRectMake(32, 520, segmentControl.bounds.size.width, segmentControl.bounds.size.height);
        [self.view addSubview:segmentControl];
    }
//    MyDragListView *dragListView = [[MyDragListView alloc] initWithFrame:CGRectMake(94, 410, 150, 140)];
//    dragListView.backgroundColor = [UIColor grayColor];
//    dragListView.selectedColor = [UIColor blackColor];
//    dragListView.titleColor = [UIColor whiteColor];
//    dragListView.titles = @[@"总量", @"订购", @"推广"];
//    [self.view addSubview:dragListView];
    
//    HXMeasureView *measureView = [[HXMeasureView alloc] initWithFrame:CGRectMake(0, 0, kScreenHeight, kScreenWidth)];
//    [self.view addSubview:measureView];
    
//    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(80, 350, 100, 0)];
//    [self.view addSubview:pickerView];
//    pickerView.dataSource = self;
//    pickerView.delegate = self;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    return;
    if (!isGuest() && ![tysxChartCtr hasAnyData]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"本地没有任何数据,是否更新最新数据" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSString *)lastDateStr {
    return tysxChartCtr.currentDayStr;
}

- (void)changeDateAction:(NSDate *)date {
    if (date == nil) {
        showPrompt(@"您选择的日期不合法,请重新选择", 1, YES);
        return;
    }
    
    NeedOperateType operateType = [tysxChartCtr changeLastDate:date];
    switch (operateType) {
        case NeedOperateType_OverDate:
            showPrompt(@"您选择的日期还没有数据生成", 1, YES);
            break;
            
        case NeedOperateType_Reload:
        {
            [self dismissDatePickView];
            [tysxChartCtr reloadData];
            [self refreshAllView];
        }
            break;
        case NeedOperateType_Update: {
            return;
            [self dismissDatePickView];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"该天无本地数据，是否从网络更新？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
        }
        default:
            break;
    }
}

- (void)refreshPlotView {
    
    NSArray *values = nil;
    
    switch (tysxChartCtr.currentTypeId) {
        case 0:
            values = tysxChartCtr.orderDatas;
            plotView.fillColor = [UIColor colorWithRed:0 green:60/255.0 blue:1 alpha:1];
            plotView.gradientColor = [UIColor colorWithRed:153/255.0 green:177/255.0 blue:1 alpha:1];
            plotView.needChangeBigUnit = NO;
            plotView.unitStr = @"次";
            break;
        case 1:
            values = tysxChartCtr.unsubscribeDatas;
            plotView.fillColor = [UIColor colorWithRed:1 green:98/255.0 blue:0 alpha:1];
            plotView.gradientColor = [UIColor colorWithRed:1 green:192/255.0 blue:153/255.0 alpha:1];
            plotView.needChangeBigUnit = NO;
            plotView.unitStr = @"次";
            break;
        case 2:
            values = tysxChartCtr.flowDatas;
            plotView.fillColor = [UIColor colorWithRed:144/255.0 green:1 blue:0 alpha:1];
            plotView.gradientColor = [UIColor colorWithRed:211/255.0 green:1 blue:153/255.0 alpha:1];
            plotView.needChangeBigUnit = YES;
            plotView.unitStr = @"GB";
            break;
        default:
            break;
    }
    
    plotView.maxVerticalValue = tysxChartCtr.maxValue;
    plotView.minVerticalValue = tysxChartCtr.minValue;
    plotView.values = values;
    plotView.horizonalTitles = tysxChartCtr.dateStrs;
    plotView.showHorizonalTitles = tysxChartCtr.dateStrs;
    [plotView setNeedsDisplay];
}

- (void)refreshMainView {
    mainDataView.productName = tysxChartCtr.currentDimensionName;
    mainDataView.typeName = tysxChartCtr.currentTypeName;
    mainDataView.isCompareWeek = tysxChartCtr.isCompareWeek;
    mainDataView.dayCompareValue = [tysxChartCtr dayCompareValueWith:tysxChartCtr.currentTypeId];
    mainDataView.weakCompareValue = [tysxChartCtr weakCompareValueWith:tysxChartCtr.currentTypeId];
    mainDataView.currentValue = [tysxChartCtr currentValueWith:tysxChartCtr.currentTypeId];
    mainDataView.compareValue = [tysxChartCtr compareValueWith:tysxChartCtr.currentTypeId];
    mainDataView.unitStr = tysxChartCtr.unitStr;
    [mainDataView setNeedsDisplay];
    if (tysxChartCtr.currentTypeId == 2) {
        mainDataView.needChangeBigUnit = YES;
    }
    else {
        mainDataView.needChangeBigUnit = NO;
    }
}

- (void)refreshAllView {
    [self refreshPlotView];
    [self refreshMainView];
    [drawView setNeedsDisplay];
    UITableView *tableView = (UITableView *)[self.view viewWithTag:kHorizonalTableTag];
    if ([tableView isKindOfClass:[UITableView class]]) {
        [tableView reloadData];
    }
}

- (void)segmentedControlValueChanged:(HXSegmentedControl *)control {
    tysxChartCtr.showType = (ShowDataType)control.currentIndex;
    [tysxChartCtr reloadData];
    [self refreshAllView];
}

- (void)contentView:(MYDrawContentView *)view touchBeginAtPoint:(CGPoint)p {
    [super contentView:view touchBeginAtPoint:p];
    if (!isGuest() && p.y > 110 && p.x < 300 && p.y < 220) {
        [self showListSelectorView];
    }
}

#pragma listselector view

- (void)showListSelectorView {
    if (isGuest()) {
        return;
    }
    UIView *listSelectorBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenHeight, kScreenWidth)];
    
    UIControl *control = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, kScreenHeight, kScreenWidth)];
    
    control.backgroundColor = [UIColor blackColor];
    control.alpha = 0.4;
    [control addTarget:self action:@selector(dismissListSelectorView:) forControlEvents:UIControlEventTouchUpInside];
    [listSelectorBgView addSubview:control];
    
    MyListSelectorView *listSelectView = [[MyListSelectorView alloc] initWithFrame:CGRectMake(0, 0, 400, 300)];
    listSelectView.sectionTitles = @[@"分产品包", @"分平台"];
    
    listSelectView.center = listSelectorBgView.center;
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < [[tysxChartCtr productIds] count]; i++) {
        [array addObject:[tysxChartCtr productNameWithId:[tysxChartCtr.productIds objectAtIndex:i]]];
    }
    listSelectView.titles = array;
    listSelectView.delegate = self;
    listSelectView.dataSource = self;
    [listSelectorBgView addSubview:listSelectView];
    
    [self.view addSubview:listSelectorBgView];

}
- (void)dismissListSelectorView:(UIControl *)control {
    [control.superview removeFromSuperview];
}

#pragma mark list delegate and datasource

- (NSString *)rowTitleWithRow:(int)row section:(int)section {
    NSString *ret = nil;
    switch (section) {
        case 0:
            ret = [tysxChartCtr productNameWithId:tysxChartCtr.productIds[row]];
            break;
        case 1:
            ret = [tysxChartCtr platNameWithId:tysxChartCtr.platIds[row]];
            break;
            
        default:
            break;
    }
    return ret;
}


- (int)rowNumberOfSection:(int)number {
    if (number == 0) {
        return (int)[[tysxChartCtr productIds] count];
    }
    return (int)[[tysxChartCtr platIds] count];
}


- (void)listSelectorViewDidSelect:(MyListSelectorView *)view {
    [view.superview removeFromSuperview];
    switch (view.currentSection) {
        case 0:
            if (view.currentRow == 0) {
                tysxChartCtr.dimensionType = DimensionType_All;
            }
            else {
                tysxChartCtr.dimensionType = DimensionType_Product;
            }
            tysxChartCtr.currentProductId = [tysxChartCtr.productIds objectAtIndex:view.currentRow];
            break;
        case 1:
            tysxChartCtr.currentPlatIndex = view.currentRow;
            tysxChartCtr.dimensionType = DimensionType_Plat;
            break;
        default:
            break;
    }
    [tysxChartCtr reloadData];
    [self refreshMainView];
    [self refreshPlotView];
    UITableView *tableView = (UITableView *)[self.view viewWithTag:kHorizonalTableTag];
    if ([tableView isKindOfClass:[UITableView class]]) {
        [tableView reloadData];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        
        showStatusView(YES);
        
        __block HXChartMainViewController *ctr = self;
        [tysxChartCtr sendRequestWith:^{
            showPrompt(tysxChartCtr.resultInfo, 1, YES);
            if (tysxChartCtr.result == NetworkBaseResult_Success) {
                [tysxChartCtr saveNetworkDataWithCompleteBlock:^{
                    [tysxChartCtr reloadData];
                    run_async_main(^{
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

#pragma mark tableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0.0;
    if (tableView.tag == kHorizonalTableTag) {
        height = kScreenHeight / 3;
    }
    else {
        height = kVerticalCellHeight;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == kHorizonalTableTag && tysxChartCtr.currentTypeId != indexPath.row) {
        tysxChartCtr.currentTypeId = (int)indexPath.row;
       [tableView reloadData];
        [self refreshMainView];
        [self refreshPlotView];
    }
}

#pragma mark tableview datasourse

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (tableView.tag == kVerticalTableTag) {
//        return [tysxChartCtr.days count];
//    }
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView horizonalCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"verticalCell";
    HXChartDataDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[HXChartDataDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.transform=CGAffineTransformMakeRotation(-M_PI*1.5);
        cell.backgroundColor = [UIColor clearColor];
    }
    
    cell.currentValue = [tysxChartCtr currentValueWith:(int)indexPath.row];
    cell.compareValue = [tysxChartCtr compareValueWith:(int)indexPath.row];
    cell.dayCompareValue = [tysxChartCtr dayCompareValueWith:(int)indexPath.row];
    cell.weakCompareValue = [tysxChartCtr weakCompareValueWith:(int)indexPath.row];
    cell.isSelected = (tysxChartCtr.currentTypeId == indexPath.row);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.typeIndex = (int)indexPath.row;
    if (cell.typeIndex <= 1) {
        cell.unitStr = @"次";
        cell.needChangeBigUnit = NO;
    }
    else if (cell.typeIndex == 2) {
        cell.unitStr = @"GB";
        cell.needChangeBigUnit = YES;
    }
    
//    BOOL isIncrease = [[boolArr objectAtIndex:indexPath.row] boolValue];
//    cell.isIncrease = isIncrease;
    return cell;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView verticalCellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *CellIdentifier = @"horizonalCell";
//    HXChartDataSimpleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[HXChartDataSimpleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//    cell.index = (int)indexPath.row;
//    cell.unusualNumber = [[tysxChartCtr.unusualNumbers objectAtIndex:indexPath.row] intValue];
//    cell.unusualRate = cell.unusualNumber * 1.0 / [tysxChartCtr.products count];
//    cell.dayStr = [tysxChartCtr.days objectAtIndex:indexPath.row];
//    return cell;
//}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == kHorizonalTableTag) {
        return  [self tableView:tableView horizonalCellForRowAtIndexPath:indexPath];
    }
//    else {
//        return  [self tableView:tableView verticalCellForRowAtIndexPath:indexPath];
//    }
    return nil;
}

- (UIStatusBarStyle)preferredStatusBarStyle NS_AVAILABLE_IOS(7_0){
    return UIStatusBarStyleLightContent;
}

#pragma mark - Rotation Support (must needed!!!)

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return UIInterfaceOrientationLandscapeRight == interfaceOrientation;
}

@end

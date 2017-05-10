//
//  HXIPOrderAbnormalViewController.m
//  tysx
//
//  Created by zwc on 14-8-13.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "HXIPOrderAbnormalViewController.h"
#import "HXTableChartCell.h"
#import "TYSXIPOrderAbnormalCtr.h"

@interface HXIPOrderAbnormalViewController ()<UITableViewDataSource, UITableViewDelegate, HXTableChartCellDataSource>

@end

@implementation HXIPOrderAbnormalViewController {
    TYSXIPOrderAbnormalCtr *ipOrderAbnormalCtr;
    UITableView *tableChart;
}

- (id)initWithPlotName:(NSString *)name {
    if (self = [super initWithPlotName:name]) {
        ipOrderAbnormalCtr = [[TYSXIPOrderAbnormalCtr alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [ipOrderAbnormalCtr reloadData];
    
    tableChart = [[UITableView alloc] initWithFrame:CGRectMake(20, 130, kScreenHeight - 40 , kScreenWidth - 130 - 5)];
    tableChart.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableChart.showsVerticalScrollIndicator = NO;
    tableChart.dataSource = self;
    tableChart.delegate = self;
    [self.view addSubview:tableChart];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (![ipOrderAbnormalCtr hasAnyData]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"本地没有任何数据,是否更新最新数据" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

- (void)refreshView {
    [tableChart reloadData];
    [drawView setNeedsDisplay];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [ipOrderAbnormalCtr.abnormalDatas count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:nil];
    HXTableChartCell *titleCell = [[HXTableChartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"title"];
    titleCell.frame = headerView.bounds;
    titleCell.dataSource = self;
    titleCell.chartInsets = UIEdgeInsetsMake(1, 1, 0.5, 1);
    titleCell.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [headerView addSubview:titleCell];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 52;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"identifier";
    HXTableChartCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[HXTableChartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.dataSource = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row == 0) {
        cell.chartInsets = UIEdgeInsetsMake(-1, 1, 0, 1);
    }
    else if (indexPath.row == [ipOrderAbnormalCtr.abnormalDatas count] - 1) {
        cell.chartInsets = UIEdgeInsetsMake(0, 1, 1, 1);
    }
    else {
        cell.chartInsets = UIEdgeInsetsMake(0, 1, 0, 1);
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)numberOfColumnInTableChartCell:(HXTableChartCell *)cell {
    return 4;
}

- (NSString *)contentInTableChartCell:(HXTableChartCell *)cell atColumn:(NSInteger)column {
    NSString *ret = nil;
    NSIndexPath *indexPath = [tableChart indexPathForCell:cell];
    if ([cell.reuseIdentifier isEqualToString:@"title"]) {
        NSArray *contents = @[@"IP", @"产品包", @"省份", @"订购次数"];
        ret = contents[column];
    }
    else {
        NSDictionary *dic = ipOrderAbnormalCtr.abnormalDatas[indexPath.row];
        switch (column) {
            case 0:
                ret = [dic objectForKey:kIpKey];
                break;
            case 1:
                ret = [dic objectForKey:kProductNameKey];
                break;
            case 2:
                ret = [dic objectForKey:kAddressKey];
                break;
            case 3:
                ret = [NSString stringWithFormat:@"%lld次", [[dic objectForKey:kOrderTimesKey] longLongValue]];
                break;
                
            default:
                break;
        }
    }
    return ret;
}
- (CGFloat)widthOfColumnInTableChartCell:(HXTableChartCell *)cell atColumn:(NSInteger)column {
        return (kScreenHeight - 42) / 4;
}
- (UIFont *)fontOfColumnInTableChartCell:(HXTableChartCell *)cell atColumn:(NSInteger)column {
    return [UIFont systemFontOfSize:18];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)lastDateStr {
    return ipOrderAbnormalCtr.lastDateStr;
}

- (void)changeDateAction:(NSDate *)date {
    if (date == nil) {
        showPrompt(@"您选择的日期不合法,请重新选择", 1, YES);
        return;
    }
    
    NeedOperateType operateType = [ipOrderAbnormalCtr updateLastDate:date];
    switch (operateType) {
        case NeedOperateType_OverDate:
            showPrompt(@"您选择的日期还没有数据生成", 1, YES);
            break;
            
        case NeedOperateType_Reload:
        {
            [self dismissDatePickView];
            [ipOrderAbnormalCtr reloadData];
            [self refreshView];
        }
            break;
        case NeedOperateType_Update: {
            [self dismissDatePickView];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"该天无本地数据，是否从网络更新？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
        }
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        
        showStatusView(YES);
        
        __block HXIPOrderAbnormalViewController *ctr = self;
        [ipOrderAbnormalCtr sendRequestWith:^{
            showPrompt(ipOrderAbnormalCtr.resultInfo, 1, YES);
            if (ipOrderAbnormalCtr.result == NetworkBaseResult_Success) {
                [ipOrderAbnormalCtr saveNetworkDataWithCompleteBlock:^{
                    [ipOrderAbnormalCtr reloadData];
                    run_async_main(^{
                        dismissStatusView();
                        [ctr refreshView];
                    });
                }];
            }
            else {
                dismissStatusView();
            }
        }];
    }
}

@end

//
//  HXCRMViewController.m
//  tysx
//
//  Created by zwc on 14-2-21.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "HXCRMViewController.h"
#import "TYSXCRMDataCtr.h"
#import "HXTableChartView.h"
#import "MYDrawContentView.h"
#import "HXMixChartCell.h"
#import "HXMixChartView.h"

#define kMenuBtnBaseValue 1000
#define kCharDetailViewTag 1005
#define kShowTopTableViewTag 1010

@interface HXCRMViewController ()<MYDrawContentViewDrawDelegate, HXTableChartViewDataSource, UIScrollViewDelegate>

@end

@implementation HXCRMViewController {
    UIScrollView *scrollView;
    UIButton *currentMenuBtn;
    TYSXCRMDataCtr *crmCtr;
    HXTableChartView *showTopTableView;
    BOOL isHaveShowTop;
    BOOL isNeedShowTop;
    CGFloat showheight;
    UIView *showTopView;
}

- (id)initWithPlotName:(NSString *)plotName;
{
    self = [super init];
    if (self) {
        crmCtr = [[TYSXCRMDataCtr alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    MYDrawContentView *drawView = [[MYDrawContentView alloc] initWithFrame:CGRectMake(0, 0, kScreenHeight, 88)];
    drawView.autoresizingMask = UIViewAutoresizingNone;
    drawView.backgroundColor = [UIColor grayColorWithGrayDegree:237/255.0];
    drawView.drawDelegate = self;
    [self.view addSubview:drawView];
    
//    int btnInterval = 40;
//    UIButton *firstBtn = [self buttonWithTitle:@"CRM整体概况" origin:CGPointMake(87, drawView.bounds.size.height - 9 - 40)];
//    firstBtn.tag = kMenuBtnBaseValue;
//    [drawView addSubview:firstBtn];
//    
//    UIButton *secondBtn = [self buttonWithTitle:@"全能看CRM" origin:CGPointMake(firstBtn.frame.origin.x + firstBtn.bounds.size.width + btnInterval, firstBtn.frame.origin.y)];
//    secondBtn.tag = kMenuBtnBaseValue + 1;
//    [drawView addSubview:secondBtn];
//    
//    UIButton *thirdBtn = [self buttonWithTitle:@"CRM详细概况" origin:CGPointMake(secondBtn.frame.origin.x + secondBtn.bounds.size.width + btnInterval, secondBtn.frame.origin.y)];
//    thirdBtn.tag = kMenuBtnBaseValue + 2;
//    [drawView addSubview:thirdBtn];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, drawView.bounds.size.height, kScreenHeight, kScreenWidth - drawView.bounds.size.height)];
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    [self makeSubView];
}

- (void)makeSubView {
    isNeedShowTop = YES;
    CGFloat offsetTop = 0;
    CGFloat intervalY = 4;
    HXTableChartView *tableChartView = [self makeGeneralTableChartView];
    tableChartView.frame = CGRectMake(0, offsetTop, kScreenHeight, 380);
    tableChartView.paddingTop = 80;
    tableChartView.title = @"CRM新增和取消自订购数量";
    tableChartView.paddingLeft = (kScreenHeight - 800) / 2;
    tableChartView.bottomStr = crmCtr.orderAndCancelStr;
    tableChartView.backgroundColor = [UIColor grayColorWithGrayDegree:237/255.0];
    tableChartView.identifier = @"新增和取消";
    tableChartView.dataSource = self;
    offsetTop += tableChartView.bounds.size.height + intervalY;
    [scrollView addSubview:tableChartView];
    
    showTopTableView = tableChartView;
    
    HXMixChartView *charView = [[HXMixChartView alloc] initWithFrame:CGRectMake(0, offsetTop, kScreenHeight, 500)];
    charView.title = @"CRM 全量留存、新增和退订情况";
    charView.yCount = 5;
    charView.leftMaxValue = 608;
    charView.isShowCellName = YES;
    charView.leftMinValue = 597;
    charView.rightMaxValue = 2;
    charView.rightMinValue = 0;
    charView.xNames = [crmCtr dates];
    charView.backgroundColor = [UIColor grayColorWithGrayDegree:237/255.0];
    {
        HXMixChartCell *cell1 = [[HXMixChartCell alloc] init];
        cell1.color = kFreshBlueColor;
        cell1.name = @"留存";
        cell1.type = ChartType_Bar;
        cell1.datas = [crmCtr.orderAndCancelChartData objectAtIndex:0];
        
        HXMixChartCell *cell2 = [[HXMixChartCell alloc] init];
        cell2.color = [UIColor redColor];
        cell2.name = @"新增";
        cell2.type = ChartType_Line;
        cell2.datas = [crmCtr.orderAndCancelChartData objectAtIndex:1];
        
        HXMixChartCell *cell3 = [[HXMixChartCell alloc] init];
        cell3.name = @"退订";
        cell3.color = [UIColor orangeColor];
        cell3.type = ChartType_Line;
        cell3.datas = [crmCtr.orderAndCancelChartData objectAtIndex:2];
        
        charView.cells = @[cell1, cell2, cell3];
    }
    
    [scrollView addSubview:charView];
    offsetTop += charView.bounds.size.height + intervalY;
    
    HXMixChartView *charView2 = [[HXMixChartView alloc] initWithFrame:CGRectMake(0, offsetTop, kScreenHeight, 500)];
    charView2.title = @"分省CRM订购留存数量和月累计用户活跃度情况";
    charView2.yCount = 5;
    charView2.leftMaxValue = 120;
    charView2.leftMinValue = 0;
    charView2.rightMaxValue = 0.2;
    charView2.rightMinValue = 0;
    charView2.xNames = [crmCtr provinces];
    charView2.backgroundColor = [UIColor grayColorWithGrayDegree:237/255.0];
    
    {
        HXMixChartCell *cell1 = [[HXMixChartCell alloc] init];
        cell1.color = kFreshBlueColor;
        cell1.type = ChartType_Bar;
        cell1.datas = [crmCtr.orderByProvinceData objectAtIndex:0];
        
        HXMixChartCell *cell2 = [[HXMixChartCell alloc] init];
        cell2.color = [UIColor orangeColor];
        cell2.type = ChartType_Line;
        cell2.datas = [crmCtr.orderByProvinceData objectAtIndex:1];
        
        charView2.cells = @[cell1,cell2];
    }
    
    [scrollView addSubview:charView2];
    offsetTop += charView2.bounds.size.height;
    
    showheight = offsetTop;
    
    HXTableChartView *tableChartView2 = [self makeGeneralTableChartView];
    tableChartView2.frame = CGRectMake(0, offsetTop, kScreenHeight, 40 * [[crmCtr crmProvinceTableData] count] + 140);
    tableChartView2.paddingTop = 80;
    tableChartView2.title = @"分省全能看CRM订购情况";
    tableChartView2.paddingLeft = 27;
    tableChartView2.backgroundColor = [UIColor grayColorWithGrayDegree:237/255.0];
    tableChartView2.identifier = @"分省";
    tableChartView2.dataSource = self;
    offsetTop += tableChartView2.bounds.size.height + intervalY;
    [scrollView addSubview:tableChartView2];
    
    showTopTableView = tableChartView2;

    
    scrollView.contentSize = CGSizeMake(kScreenHeight, offsetTop);
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//
//}
//
//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    [self.view addSubview:showTopTableView.showTopView];
//}

- (HXTableChartView *)makeGeneralTableChartView {
    __autoreleasing HXTableChartView *tableChartView = [[HXTableChartView alloc] initWithFrame:CGRectZero];
    tableChartView.borderLineWidth = 2;
    tableChartView.borderLineColor = [UIColor grayColorWithGrayDegree:165 / 255.0];
    tableChartView.rowLineColor = [UIColor whiteColor];
    tableChartView.rowLineWidth = 1;
    tableChartView.columnLineWidth = 1;
    tableChartView.columnLineColor = [UIColor whiteColor];
    tableChartView.dataSource = self;
    return tableChartView;
}

- (void)contentView:(MYDrawContentView*)view drawRect:(CGRect)rect {
    if (view.tag == kCharDetailViewTag) {
        CGFloat offsetTop = 60;
        [@"全能看CRM详细概况" drawInRect:CGRectMake(0, offsetTop, rect.size.width, 20)
               withFont:[UIFont systemFontOfSize:20]
          lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
        
        offsetTop += 46;
        CGFloat leftPadding = 50;
        for (int i = 0; i < [crmCtr.crmDetails count]; i++) {
            [[crmCtr.crmDetails objectAtIndex:i] drawInRect:CGRectMake(leftPadding, offsetTop, rect.size.width - 2 * leftPadding, 24800)
                                                   withFont:[UIFont systemFontOfSize:18] lineBreakMode:NSLineBreakByTruncatingTail];
            offsetTop += 24;
        }
    }
    else {
        int offsetTop = 10;
        int offsetLeft = 29;
        [[UIImage imageNamed:@"logo_lit.png"] drawAtPoint:CGPointMake(offsetLeft, offsetTop)];
        
        [[UIColor grayColor] set];
        [@"天翼视讯全能看CRM监控系统" drawAtPoint:CGPointMake(87, 18) withFont:[UIFont systemFontOfSize:18]];
        
        offsetTop += 34;
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextMoveToPoint(context, 0, offsetTop);
        CGContextAddLineToPoint(context, rect.size.width, offsetTop);
        CGContextSetLineWidth(context, 0.7);
        CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
        CGContextStrokePath(context);
        
        offsetTop += 4;
        CGContextSetFillColorWithColor(context, [UIColor grayColorWithGrayDegree:211/255.0].CGColor);
        CGContextFillRect(context, CGRectMake(0, offsetTop, rect.size.width, 38));
        
        [[UIColor grayColor] set];
        [@"2014-03-01" drawAtPoint:CGPointMake(87, offsetTop + 10) withFont:[UIFont systemFontOfSize:16]];
        [[UIColor whiteColor] set];
        [@"CRM订购情况" drawInRect:CGRectMake(0, offsetTop + 7, rect.size.width, 25)
                      withFont:[UIFont systemFontOfSize:20]
                 lineBreakMode:NSLineBreakByTruncatingTail
                     alignment:NSTextAlignmentCenter];
    }
}

- (UIButton *)buttonWithTitle:(NSString *)title origin:(CGPoint)origin{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor grayColorWithGrayDegree:155/255.0]];
    [button addTarget:self action:@selector(switchSubView:) forControlEvents:UIControlEventTouchUpInside];
    UIFont *font = [UIFont systemFontOfSize:18];
    CGSize size = [title sizeWithFont:font];
    button.frame = CGRectMake(origin.x, origin.y, size.width + 20, size.height + 15);
    return button;
}

- (void)switchSubView:(UIButton *)sender {
    sender.backgroundColor = kFreshBlueColor;
    [currentMenuBtn setBackgroundColor:[UIColor grayColorWithGrayDegree:155/255.0]];
    currentMenuBtn.userInteractionEnabled = YES;
    currentMenuBtn = sender;
    currentMenuBtn.userInteractionEnabled = NO;
    
    for (UIView *view in [scrollView subviews]) {
        [view removeFromSuperview];
    }
    scrollView.contentOffset = CGPointMake(0, 0);
    
    CGFloat offsetTop = 0;
    CGFloat intervalY = 4;
    offsetTop += intervalY;
    switch (sender.tag - kMenuBtnBaseValue) {
        case 0:
        {
            isNeedShowTop = NO;
            HXTableChartView *tableChartView = [self makeGeneralTableChartView];
            tableChartView.frame = CGRectMake(0, offsetTop, kScreenHeight, 350);
            tableChartView.paddingTop = 80;
            tableChartView.title = @"CRM新增和取消自订购数量";
            tableChartView.paddingLeft = (kScreenHeight - 800) / 2 + 50;
            tableChartView.bottomStr = crmCtr.orderAndCancelStr;
            tableChartView.backgroundColor = [UIColor grayColorWithGrayDegree:237/255.0];
            tableChartView.identifier = @"新增和取消";
            tableChartView.dataSource = self;
            offsetTop += tableChartView.bounds.size.height + intervalY;
            [scrollView addSubview:tableChartView];
            
            showTopTableView = tableChartView;
            
            HXMixChartView *charView = [[HXMixChartView alloc] initWithFrame:CGRectMake(0, offsetTop, kScreenHeight, 500)];
            charView.title = @"CRM 全量留存、新增和退订情况";
            charView.yCount = 5;
            charView.leftMaxValue = 608;
            charView.isShowCellName = YES;
            charView.leftMinValue = 597;
            charView.rightMaxValue = 2;
            charView.rightMinValue = 0;
            charView.xNames = [crmCtr dates];
            charView.backgroundColor = [UIColor grayColorWithGrayDegree:237/255.0];
            {
                HXMixChartCell *cell1 = [[HXMixChartCell alloc] init];
                cell1.color = kFreshBlueColor;
                cell1.name = @"留存";
                cell1.type = ChartType_Bar;
                cell1.datas = [crmCtr.orderAndCancelChartData objectAtIndex:0];
                
                HXMixChartCell *cell2 = [[HXMixChartCell alloc] init];
                cell2.color = [UIColor redColor];
                cell2.name = @"新增";
                cell2.type = ChartType_Line;
                cell2.datas = [crmCtr.orderAndCancelChartData objectAtIndex:1];
                
                HXMixChartCell *cell3 = [[HXMixChartCell alloc] init];
                cell3.name = @"退订";
                cell3.color = [UIColor orangeColor];
                cell3.type = ChartType_Line;
                cell3.datas = [crmCtr.orderAndCancelChartData objectAtIndex:2];
                
                charView.cells = @[cell1, cell2, cell3];
            }
            
            [scrollView addSubview:charView];
            offsetTop += charView.bounds.size.height + intervalY;
            
            HXMixChartView *charView2 = [[HXMixChartView alloc] initWithFrame:CGRectMake(0, offsetTop, kScreenHeight, 500)];
            charView2.title = @"分省CRM订购留存数量和月累计用户活跃度情况";
            charView2.yCount = 5;
            charView2.leftMaxValue = 120;
            charView2.leftMinValue = 0;
            charView2.rightMaxValue = 0.2;
            charView2.rightMinValue = 0;
            charView2.xNames = [crmCtr provinces];
            charView2.backgroundColor = [UIColor grayColorWithGrayDegree:237/255.0];
            
            {
                HXMixChartCell *cell1 = [[HXMixChartCell alloc] init];
                cell1.color = kFreshBlueColor;
                cell1.type = ChartType_Bar;
                cell1.datas = [crmCtr.orderByProvinceData objectAtIndex:0];
                
                HXMixChartCell *cell2 = [[HXMixChartCell alloc] init];
                cell2.color = [UIColor orangeColor];
                cell2.type = ChartType_Line;
                cell2.datas = [crmCtr.orderByProvinceData objectAtIndex:1];
                
                charView2.cells = @[cell1,cell2];
            }
            
            [scrollView addSubview:charView2];
            offsetTop += charView2.bounds.size.height;
            
            scrollView.contentSize = CGSizeMake(kScreenHeight, offsetTop);
        }
            break;
        case 1:
        {
            isNeedShowTop = YES;
            HXMixChartView *charView = [[HXMixChartView alloc] initWithFrame:CGRectMake(0, offsetTop, kScreenHeight, 500)];
            charView.title = @"全能看CEM留存、新增、退订情况";
            charView.yCount = 6;
            charView.leftMaxValue = 615;
            charView.leftMinValue = 590;
            charView.rightMaxValue = 2;
            charView.rightMinValue = 0;
            charView.xNames = [crmCtr dates];
            charView.tag = kShowTopTableViewTag;
            charView.backgroundColor = [UIColor grayColorWithGrayDegree:237/255.0];
            {
                HXMixChartCell *cell1 = [[HXMixChartCell alloc] init];
                cell1.color = kFreshBlueColor;
                cell1.type = ChartType_Bar;
                cell1.datas = [crmCtr.cemChartData objectAtIndex:0];
                
//                HXMixChartCell *cell2 = [[HXMixChartCell alloc] init];
//                cell2.color = [UIColor redColor];
                //                cell2.type = ChartType_Line;
                //                cell2.datas = [crmCtr.orderAndCancelChartData objectAtIndex:1];
                
                charView.cells = @[cell1];
            }
            
            [scrollView addSubview:charView];
            offsetTop += charView.bounds.size.height + intervalY;
            
            showheight = offsetTop;
            
            HXTableChartView *tableChartView = [self makeGeneralTableChartView];
            tableChartView.frame = CGRectMake(0, offsetTop, kScreenHeight, 40 * [[crmCtr crmProvinceTableData] count] + 140);
            tableChartView.paddingTop = 80;
            tableChartView.title = @"分省全能看CRM订购情况";
            tableChartView.paddingLeft = 27;
            tableChartView.backgroundColor = [UIColor grayColorWithGrayDegree:237/255.0];
            tableChartView.identifier = @"分省";
            tableChartView.dataSource = self;
            offsetTop += tableChartView.bounds.size.height + intervalY;
            [scrollView addSubview:tableChartView];
            
            showTopTableView = tableChartView;
            
            scrollView.contentSize = CGSizeMake(kScreenHeight, offsetTop);
        }
            break;
        case 2:
        {
            isNeedShowTop = NO;
            MYDrawContentView *drawView = [[MYDrawContentView alloc] initWithFrame:CGRectMake(0, offsetTop, kScreenHeight, scrollView.bounds.size.height - offsetTop)];
            drawView.tag = kCharDetailViewTag;
            drawView.drawDelegate = self;
            drawView.backgroundColor = [UIColor grayColorWithGrayDegree:237/255.0];
            [scrollView addSubview:drawView];
            offsetTop += drawView.bounds.size.height;
            
            scrollView.contentSize = CGSizeMake(kScreenHeight, offsetTop);
        }
            break;
        default:
            break;
    }
}

- (void)contentView:(MYDrawContentView*)view touchBeginAtPoint:(CGPoint)p {
    if (p.y < 44 && p.x < 280) {
        [self backMenuView];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark table chart view data source

- (NSInteger)numberOfRowsInTableChartView:(HXTableChartView *)tableChartView {
    int ret = 0;
    if ([tableChartView.identifier isEqualToString:@"新增和取消"]) {
        ret = (int)[crmCtr.orderAndCancelData count];
    }
    else if ([tableChartView.identifier isEqualToString:@"分省"]) {
        ret = (int)[crmCtr.crmProvinceTableData count];
    }
    return ret;
}

- (NSInteger)numberOfColumnsInTableChartView:(HXTableChartView *)tableChartView {
    int ret = 0;
    if ([tableChartView.identifier isEqualToString:@"新增和取消"]) {
        ret = (int)[[crmCtr.orderAndCancelData objectAtIndex:0] count];
    }
    else if ([tableChartView.identifier isEqualToString:@"分省"]) {
        ret = (int)[[crmCtr.crmProvinceTableData objectAtIndex:0] count];

    }
    return ret;
}

- (CGFloat)tableChartView:(HXTableChartView *)tableChartView widthOfColumn:(NSInteger)column {
    CGFloat ret = 100;
    if ([tableChartView.identifier isEqualToString:@"新增和取消"]) {
        ret = 200;
    }
    else if ([tableChartView.identifier isEqualToString:@"分省"] && column == 0) {
        ret = 80;
    }
    return ret;
}

- (CGFloat)tableChartView:(HXTableChartView *)tableChartView heightOfRow:(NSInteger)row {
    return 40;
}

- (UIFont *)tableChartView:(HXTableChartView *)tableChartView
                 fontOfRow:(NSInteger)row
                    column:(NSInteger)column {
    return [UIFont systemFontOfSize:14];
}

- (UIColor *)tableChartView:(HXTableChartView *)tableChartView
       backgroundColorOfRow:(NSInteger)row
                     column:(NSInteger)column {
    UIColor *ret = nil;
    if (row == 0) {
        ret = [UIColor grayColorWithGrayDegree:202 / 255.0];
    }
    else if (row % 2 == 0) {
        ret = [UIColor grayColorWithGrayDegree:236 / 255.0];
    }
    else {
        ret = [UIColor grayColorWithGrayDegree:246 / 255.0];
    }
    
    return ret;
}

- (UIColor *)tableChartView:(HXTableChartView *)tableChartView
             textColorOfRow:(NSInteger)row
                     column:(NSInteger)column {
    return [UIColor blackColor];
}

- (NSString *)tableChartView:(HXTableChartView *)tableChartView
                   textOfRow:(NSInteger)row
                      column:(NSInteger)column {
    NSString *ret = nil;
    if ([tableChartView.identifier isEqualToString:@"新增和取消"]) {
        ret = [[crmCtr.orderAndCancelData objectAtIndex:row] objectAtIndex:column];
    }
    else if ([tableChartView.identifier isEqualToString:@"分省"]) {
        ret = [[crmCtr.crmProvinceTableData objectAtIndex:row] objectAtIndex:column];
        if ( row != 0 && column >= 7) {
            ret = [NSString stringWithFormat:@"%.2f%%",[ret floatValue] * 100];
        }
    }
    return ret;
}

- (BOOL)tableChartView:(HXTableChartView *)tableChartView
    needDrawTrendOfRow:(NSInteger)row
                column:(NSInteger)column {
    BOOL ret = NO;
//    if ([tableChartView.identifier isEqualToString:@"新增和取消"]) {
//        if (row != 0 && column != 0 && column % 2 == 0) {
//            ret = YES;
//        }
//    }
    if ([tableChartView.identifier isEqualToString:@"分省"]) {
        if (row != 0 && column != 0 && column % 3 == 0) {
            ret = YES;
        }
    }
    
    return ret;
}

- (eDrawDirection)tableChartView:(HXTableChartView *)tableChartView
         drawTrendDerictionOfRow:(NSInteger)row
                          column:(NSInteger)column {
    double showNumber = 0;
    if ([tableChartView.identifier isEqualToString:@"新增和取消"]) {
        showNumber = [[[crmCtr.orderAndCancelData objectAtIndex:row] objectAtIndex:column] intValue];
    }
    else if ([tableChartView.identifier isEqualToString:@"分省"]) {
        showNumber = [[[crmCtr.crmProvinceTableData objectAtIndex:row] objectAtIndex:column] floatValue];
    }
    if (showNumber > 0) {
        return DrawDirection_Up;
    }
    else if (showNumber < 0) {
        return DrawDirection_Down;
    }
    else {
        return DrawDirection_Right;
    }
}

#pragma mark scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView_{
    if (isNeedShowTop) {
        if (isHaveShowTop && scrollView_.contentOffset.y < showheight) {
            [showTopView removeFromSuperview];
            isHaveShowTop = NO;
        }
        if (!isHaveShowTop && scrollView_.contentOffset.y > showheight) {
            showTopView = showTopTableView.showTopView;
            showTopView.frame = CGRectMake(0, scrollView.frame.origin.y, scrollView.bounds.size.width, showTopView.bounds.size.height);
            [self.view addSubview:showTopView];
            isHaveShowTop = YES;
        }
    }
}

@end

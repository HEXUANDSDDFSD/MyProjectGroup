//
//  PPTVBaseViewController.m
//  tysx
//
//  Created by zwc on 14/10/22.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "IPTVBaseViewController.h"
#import "HXSegmentedControl.h"
#import "IPTVDataCell.h"

#define kSectionHeaderViewTag 'shvt'

@interface IPTVBaseViewController ()<MYDrawContentViewDrawDelegate, UITableViewDataSource, UITableViewDelegate>

@end

@implementation IPTVBaseViewController {
    NSString *_plotName;
}

- (id)initWithPlotName:(NSString *)plotName {
    if (self = [super init]) {
        _plotName = plotName;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    MYDrawContentView *drawView = [[MYDrawContentView alloc] initWithFrame:CGRectZero];
    [self.view insertSubview:drawView atIndex:0];
    drawView.drawDelegate = self;
    drawView.backgroundColor = [UIColor whiteColor];
    [drawView locationAtSuperView:self.view edgeInsets:UIEdgeInsetsZero];
    
    if (!useDefaultPlot) {
        return;
    }
    
    UITableView *leftDataView = [[UITableView alloc] initWithFrame:CGRectMake(0, 65, 256, self.view.height - 65) style:UITableViewStylePlain];
    leftDataView.dataSource = self;
    leftDataView.delegate = self;
    leftDataView.showsVerticalScrollIndicator = NO;
    leftDataView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:leftDataView];
    
    HXSegmentedControl *segementControl = [[HXSegmentedControl alloc] initWithItems:@[@"开机用户", @"剔除用户"]];
    segementControl.itemHeight = 43;
    segementControl.itemWidth = 121;
    segementControl.frame = CGRectMake((self.view.width - leftDataView.width - 242) / 2 + leftDataView.width, 81, 242, 43);
    segementControl.font = [UIFont systemFontOfSize:20];
    segementControl.normalColor = [UIColor clearColor];
    segementControl.selectedColor = [UIColor colorWithHexString:@"#e5e5e5"];
    segementControl.normalTitleColor = [UIColor colorWithHexString:@"#e5e5e5"];
    segementControl.selectedTitleColor = [UIColor colorWithHexString:@"#b3b3b3"];
    segementControl.needBorder = YES;
    [self.view addSubview:segementControl];
    
    // Do any additional setup after loading the view.
}

- (NSArray *)leftDataTitles {
    return @[@"全局总活跃用户数", @"宝山", @"北区", @"崇明", @"东区", @"浦东新区", @"闵行区"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self leftDataTitles] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"left_info_cell";
    IPTVDataCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[IPTVDataCell alloc] initWithStyle:UITableViewCellSeparatorStyleNone reuseIdentifier:cellIdentifier];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *headerViewIdentifier = @"footerViewIdentifier";
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerViewIdentifier];
    if (headerView == nil) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerViewIdentifier];
        [headerView prepareForReuse];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        [headerView addSubview:label];
        label.backgroundColor = [UIColor grayColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:20];
        label.tag = kSectionHeaderViewTag;
        [label locationAtSuperView:headerView edgeInsets:UIEdgeInsetsZero];
    }

    UILabel *label = (UILabel *)[headerView viewWithTag:kSectionHeaderViewTag];
    label.text = [self leftDataTitles][section];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 129;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)contentView:(MYDrawContentView*)view drawRect:(CGRect)rect {
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    
    [attr setValue:[UIFont systemFontOfSize:20] forKey:NSFontAttributeName];
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraph.alignment = NSTextAlignmentCenter;
    [attr setValue:paragraph forKey:NSParagraphStyleAttributeName];
    
    [_plotName drawInRect:CGRectMake(0, 10, rect.size.width, rect.size.height) withAttributes:attr];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGPoint oriPoint = CGPointMake(30, 24);
    CGFloat horOffset = 14;
    CGFloat verOffset = 11;
    
    CGContextSetFillColorWithColor(ctx, [UIColor grayColor].CGColor);
    CGContextMoveToPoint(ctx, oriPoint.x, oriPoint.y);
    CGContextAddLineToPoint(ctx, oriPoint.x + horOffset, oriPoint.y - verOffset);
    CGContextAddLineToPoint(ctx, oriPoint.x + horOffset, oriPoint.y + verOffset);
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
    
    CGContextSetStrokeColorWithColor(ctx, [UIColor grayColor].CGColor);
    CGContextMoveToPoint(ctx, 0, 49);
    CGContextAddLineToPoint(ctx, rect.size.width, 49);
    CGContextStrokePath(ctx);
}

- (void)contentView:(MYDrawContentView*)view touchBeginAtPoint:(CGPoint)p {
    if (p.y < 44 && p.x < 280) {
        [self backMenuView];
    }
}

- (void)backMenuView {
    CGFloat scale = 0.27;
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:ctx];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.view.bounds.size.width * scale, self.view.bounds.size.height * scale), NO, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0, 0, self.view.bounds.size.width * scale, self.view.bounds.size.height * scale)];
    ctx = UIGraphicsGetCurrentContext();
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    NSString *imagePath = [KCachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", NSStringFromClass([self class])]];
    [imageData writeToFile:imagePath atomically:YES];
    
    [self.navigationController popViewControllerAnimated:NO];
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

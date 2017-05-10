//
//  IPTVTempViewController.m
//  tysx
//
//  Created by zwc on 14/11/5.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "IPTVTempViewController.h"

@implementation BubbleButton

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
       // [self setTitle:@"崇\n明" forState:UIControlStateNormal];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(-4, -51, 0, 0)];
       // [self setImageEdgeInsets:UIEdgeInsetsMake(0, 7, 0, 0)];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        self.titleLabel.numberOfLines = -1;
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    }
    return self;
}

@end

@interface IPTVTempViewController ()

@end

@implementation IPTVTempViewController {
    int currentSelTag;
}

- (id)initWithPlotName:(NSString *)plotName {
    if (self = [super initWithPlotName:plotName]) {
        useDefaultPlot = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    currentSelTag = 1010;
    
    NSArray *first = @[@1010, @1011, @1012, @1013, @1014];
    NSArray *second = @[@1003, @1004, @1005, @1009, @1008];
    
    for (int i = 0; i < 14; i++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:1000 + i + 1];
        NSString *currentTagStr = [NSString stringWithFormat:@"%d", i + 1000 + 1];
        NSString *imgName = nil;
        NSString *selImgName = nil;
        
        if (currentSelTag == [currentTagStr intValue]) {
            button.selected = YES;
            button.userInteractionEnabled = NO;
        }
        
        if ([self array:first containIntValue:[currentTagStr intValue]]) {
            imgName = @"red_bubble.png";
            selImgName = @"red_bubble_d.png";
        }
        else if ([self array:second containIntValue:[currentTagStr intValue]]){
            imgName = @"green_bubble.png";
            selImgName = @"green_bubble_d.png";
        }
        else {
            imgName = @"blue_bubble.png";
            selImgName = @"blue_bubble_d.png";
        }
        [button addTarget:self action:@selector(changeSelBtn:) forControlEvents:UIControlEventTouchDown];
        [button setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:selImgName] forState:UIControlStateSelected];
        [button setTitle:[[self nameDic] objectForKey:currentTagStr] forState:UIControlStateNormal];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changeSelBtn:(UIButton *)button {
    button.selected = YES;
    button.userInteractionEnabled = NO;
    
    UIButton *selButton = (UIButton *)[self.view viewWithTag:currentSelTag];
    selButton.userInteractionEnabled = YES;
    selButton.selected = NO;
    currentSelTag = (int)button.tag;
}

- (NSDictionary *)nameDic {
    return @{@"1001": @"崇\n明",
             @"1002": @"宝\n山",
             @"1003": @"嘉\n定",
             @"1004": @"青\n浦",
             @"1005": @"松\n江",
             @"1006": @"金\n山",
             @"1007": @"奉\n贤",
             @"1008": @"浦\n东",
             @"1009": @"闵\n行",
             @"1010": @"东\n区",
             @"1011": @"西\n区",
             @"1012": @"南\n区",
             @"1013": @"北\n区",
             @"1014": @"中\n区"};
}

- (BOOL)array:(NSArray *)array containIntValue:(int)value {
    for(NSNumber *number in array) {
        if ([number intValue] == value) {
            return YES;
        }
    }
    return NO;
}

- (void)contentView:(MYDrawContentView*)view drawRect:(CGRect)rect {
    [super contentView:view drawRect:rect];
    
    CGFloat offsetTop = 600;
    CGFloat offsetLeft = 363;
    CGFloat intervalX = 5;
    CGFloat intervalY = -14;
    CGFloat cellHeight = 61;
    CGFloat imageCellWidth = 51;
    
    NSMutableDictionary *attr = [@{NSFontAttributeName : [UIFont systemFontOfSize:15],} mutableCopy];
    [[UIImage imageNamed:@"red_bubble.png"] drawAtPoint:CGPointMake(offsetLeft, offsetTop)];
    [@"各区活跃用户前五名" drawAtPoint:CGPointMake(offsetLeft + imageCellWidth + intervalX, offsetTop + 22) withAttributes:attr];
    
    offsetTop += cellHeight + intervalY;
    [[UIImage imageNamed:@"green_bubble.png"] drawAtPoint:CGPointMake(offsetLeft, offsetTop)];
    [@"各区活跃用户5-10名" drawAtPoint:CGPointMake(offsetLeft + imageCellWidth + intervalX, offsetTop + 22) withAttributes:attr];
    
    offsetTop += cellHeight + intervalY;
    [[UIImage imageNamed:@"blue_bubble.png"] drawAtPoint:CGPointMake(offsetLeft, offsetTop)];
    [@"各区活跃用户十名外" drawAtPoint:CGPointMake(offsetLeft + imageCellWidth + intervalX, offsetTop + 22) withAttributes:attr];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, [UIColor grayColorWithGrayDegree:233/255.0].CGColor);
    CGContextFillRect(ctx, CGRectMake(625, 50, 30, rect.size.height - 50));
    
    CGContextSetFillColorWithColor(ctx, [UIColor grayColorWithGrayDegree:215/255.0].CGColor);
    CGContextFillRect(ctx, CGRectMake(625, (rect.size.height - 50 - 5) / 2 + 50, rect.size.width - 625, 5));
    
    [self drawPlotCellAtOriPoint:CGPointMake(625, 50) title:@"活跃用户"];
    [self drawPlotCellAtOriPoint:CGPointMake(625, (rect.size.height - 50 - 5) / 2 + 50) title:@"剔除酒店"];
}


- (void)drawPlotCellAtOriPoint:(CGPoint)point title:(NSString *)title {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paraStyle.alignment = NSTextAlignmentCenter;
    paraStyle.lineSpacing = 20;
    
    NSMutableDictionary *attr = [@{NSFontAttributeName : [UIFont systemFontOfSize:20], NSParagraphStyleAttributeName:paraStyle} mutableCopy];
    [title drawInRect:CGRectMake(point.x, point.y + 100, 30, (self.view.bounds.size.height - 50) / 2) withAttributes:attr];
    
    CGFloat offsetTop = 239 + point.y;
    CGFloat offsetLeft = point.x + 50;
    CGFloat intervalY = 20;
    CGFloat fontHeight = 20;
    [attr removeObjectForKey:NSParagraphStyleAttributeName];
    [attr setObject:[UIFont systemFontOfSize:20] forKey:NSFontAttributeName];
    [@"同比增长：" drawAtPoint:CGPointMake(offsetLeft, offsetTop) withAttributes:attr];
    [[UIImage imageNamed:@"arrow_down.png"] drawAtPoint:CGPointMake(offsetLeft + 94, offsetTop)];
    [attr setObject:[UIFont systemFontOfSize:32] forKey:NSFontAttributeName];
    [attr setObject:[UIColor colorWithRed:250/255.0 green:96/255.0 blue:96/255.0 alpha:1] forKey:NSForegroundColorAttributeName];
    [@"-0.3%" drawAtPoint:CGPointMake(offsetLeft + 130, offsetTop - 10) withAttributes:attr];
    
    [attr setObject:[UIFont systemFontOfSize:20] forKey:NSFontAttributeName];
    [attr setObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
    offsetTop += fontHeight + intervalY;
    [@"环比增长：" drawAtPoint:CGPointMake(offsetLeft, offsetTop) withAttributes:attr];
    [[UIImage imageNamed:@"arrow_up.png"] drawAtPoint:CGPointMake(offsetLeft + 94, offsetTop)];
    [attr setObject:[UIFont systemFontOfSize:32] forKey:NSFontAttributeName];
    [attr setObject:[UIColor colorWithRed:62/255.0 green:212/255.0 blue:58/255.0 alpha:1.0] forKey:NSForegroundColorAttributeName];
    [@"+0.3%" drawAtPoint:CGPointMake(offsetLeft + 130, offsetTop - 10) withAttributes:attr];
    
    [attr setObject:[UIFont systemFontOfSize:20] forKey:NSFontAttributeName];
    [attr setObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
    offsetTop += fontHeight + intervalY;
    [@"当前用户数：" drawAtPoint:CGPointMake(offsetLeft, offsetTop) withAttributes:attr];
    [@"1667504" drawAtPoint:CGPointMake(offsetLeft + 120, offsetTop) withAttributes:attr];
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

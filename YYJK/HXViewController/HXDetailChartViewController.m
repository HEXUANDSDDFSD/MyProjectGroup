//
//  HXDetailChartViewController.m
//  tysx
//
//  Created by zwc on 13-12-10.
//  Copyright (c) 2013年 huangjia. All rights reserved.
//

#import "HXDetailChartViewController.h"
#import "TYSXDetailChartDataCtr.h"
#import "HXHSeparateBarView.h"
#import "NSString+Draw.h"
#import "HXSeparateBarView.h"
#import "HXTableChartView.h"
#import "MYDrawContentView.h"
#import "HXSectionMenuView.h"

#define kTableDrawViewTag 1000
#define kOrderViewTag 2000
#define kUnsubscribeViewTag 2001
#define kMenuBtnBaseValue 1080
#define kCharDetailViewTag 1090

@interface HXNodeLineChartView : UIView

@property (nonatomic, assign) CGFloat paddingLeft;
@property (nonatomic, assign) CGFloat paddingRight;
@property (nonatomic, assign) CGFloat paddingTop;
@property (nonatomic, assign) CGFloat paddingBottom;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) int maxValue;
@property (nonatomic, assign) int minValue;
@property (nonatomic, assign) int verticalCount;
@property (nonatomic, copy) NSArray *data;

@end

@implementation HXNodeLineChartView {
    CGFloat _paddingTop;
    CGFloat _paddingBottom;
    CGFloat _paddingLeft;
    CGFloat _paddingRight;

}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]){
    }
    return self;
}

- (void)drawRhombusAtPoint:(CGPoint) center
                     color:(UIColor *)color
                      side:(CGFloat)side {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGFloat drawHeight = side * sin(M_2_PI / 2);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, &CGAffineTransformIdentity, center.x, center.y - drawHeight);
    CGPathAddLineToPoint(path, &CGAffineTransformIdentity, center.x + drawHeight, center.y);
    CGPathAddLineToPoint(path, &CGAffineTransformIdentity, center.x, center.y + drawHeight);
    CGPathAddLineToPoint(path, &CGAffineTransformIdentity, center.x - drawHeight, center.y);
    CGPathCloseSubpath(path);
    CGContextAddPath(context, path);
    CGPathRelease(path);
    CGContextFillPath(context);
    
}

- (void)drawRectAtPoint:(CGPoint) center
                     color:(UIColor *)color
                      side:(CGFloat)side {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, &CGAffineTransformIdentity, center.x - side/2 , center.y - side/2);
    CGPathAddLineToPoint(path, &CGAffineTransformIdentity, center.x + side/2, center.y - side/2);
    CGPathAddLineToPoint(path, &CGAffineTransformIdentity, center.x + side/2, center.y + side/2);
    CGPathAddLineToPoint(path, &CGAffineTransformIdentity, center.x - side/2, center.y + side/2);
    CGPathCloseSubpath(path);
    CGContextAddPath(context, path);
    CGPathRelease(path);
    CGContextFillPath(context);
}


- (void)drawRect:(CGRect)rect {
    _paddingTop = 60;
    _paddingBottom = 40;
    _paddingLeft = 80;
    _paddingRight = 20;
    [self.title drawInRect:CGRectMake(0, 15, rect.size.width, 20)
                  withFont:[UIFont systemFontOfSize:15]
             lineBreakMode:NSLineBreakByTruncatingTail
                 alignment:NSTextAlignmentCenter];
    [@"x10000" drawRotationAtPoint:CGPointMake(30, _paddingTop + 100) withFont:[UIFont systemFontOfSize:12] angle:M_PI_2];
    
    _paddingTop += 30;
    
    CGFloat everyV = (rect.size.height - _paddingTop - _paddingBottom ) / (self.verticalCount - 1);
    CGFloat everyVValue = (self.maxValue - self.minValue) * 1.0 / (self.verticalCount - 1);
    for (int i = 0; i < self.verticalCount; i++) {
        NSString *drawStr = [NSString stringWithFormat:@"%.1f", self.maxValue - everyVValue * i];
        [drawStr drawInRect:CGRectMake(_paddingLeft - 30, _paddingTop - 7 + everyV * i, 25, 20)
                   withFont:[UIFont systemFontOfSize:12]
              lineBreakMode:NSLineBreakByTruncatingTail
                  alignment:NSTextAlignmentRight];
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, _paddingLeft, rect.size.height - _paddingBottom);
    CGContextAddLineToPoint(context, rect.size.width - _paddingRight, rect.size.height - _paddingBottom);
    CGContextStrokePath(context);
    
    NSArray *dates = @[@"2014/02/23", @"2014/02/24", @"2014/02/25", @"2014/02/26", @"2014/02/27", @"2014/02/28", @"2014/03/01"];
    CGFloat everyH = (rect.size.width - _paddingLeft - _paddingRight) / [dates count];
    for (int i = 0; i < [dates count]; i++) {
        [[dates objectAtIndex:i] drawInRect:CGRectMake(_paddingLeft + i * everyH, rect.size.height - _paddingBottom + 5, everyH, 20)
                                   withFont:[UIFont systemFontOfSize:10]
                              lineBreakMode:NSLineBreakByTruncatingTail
                                  alignment:NSTextAlignmentCenter];
    }
    
    CGContextSetStrokeColorWithColor(context, kFreshBlueColor.CGColor);
    CGMutablePathRef path = CGPathCreateMutable();
    for (int i = 0; i < [[self.data objectAtIndex:0] count]; i++) {
        if (i == 0) {
            CGPathMoveToPoint(path, &CGAffineTransformIdentity, _paddingLeft + everyH / 2, [self yWithValue:[[[self.data objectAtIndex:0] objectAtIndex:0] floatValue]]);
        }
        else {
            CGPathAddLineToPoint(path, &CGAffineTransformIdentity, _paddingLeft + everyH / 2 + i * everyH, [self yWithValue:[[[self.data objectAtIndex:0] objectAtIndex:i] floatValue]]);
        }
        [self drawRhombusAtPoint:CGPointMake(_paddingLeft + everyH / 2 + i * everyH, [self yWithValue:[[[self.data objectAtIndex:0] objectAtIndex:i] floatValue]]) color:kFreshBlueColor side:15];
    }
    CGContextAddPath(context, path);
    CGPathRelease(path);
    CGContextStrokePath(context);
    
    CGMutablePathRef path1 = CGPathCreateMutable();
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    for (int i = 0; i < [[self.data objectAtIndex:0] count]; i++) {
        if (i == 0) {
            CGPathMoveToPoint(path1, &CGAffineTransformIdentity, _paddingLeft + everyH / 2, [self yWithValue:[[[self.data objectAtIndex:1] objectAtIndex:0] floatValue]]);
        }
        else {
            CGPathAddLineToPoint(path1, &CGAffineTransformIdentity, _paddingLeft + everyH / 2 + i * everyH, [self yWithValue:[[[self.data objectAtIndex:1] objectAtIndex:i] floatValue]]);
        }
        [self drawRectAtPoint:CGPointMake(_paddingLeft + everyH / 2 + i * everyH, [self yWithValue:[[[self.data objectAtIndex:1] objectAtIndex:i] floatValue]]) color:[UIColor redColor] side:7];
    }
    CGContextAddPath(context, path1);
    CGPathRelease(path1);
    CGContextStrokePath(context);
    
    {
        CGFloat offsetLeft = 180;
        CGFloat offsetTop = 50;
        CGContextSetStrokeColorWithColor(context, kFreshBlueColor.CGColor);
        CGContextMoveToPoint(context, offsetLeft, offsetTop);
        CGContextAddLineToPoint(context, offsetLeft + 15, offsetTop);
        CGContextStrokePath(context);
        offsetLeft += 20;
        [[UIColor grayColor] set];
        [@"门户自然渠道" drawAtPoint:CGPointMake(offsetLeft , offsetTop - 9) withFont:[UIFont systemFontOfSize:12]];
        offsetLeft += 80;
        
        CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
        CGContextMoveToPoint(context, offsetLeft, offsetTop);
        CGContextAddLineToPoint(context, offsetLeft + 15, offsetTop);
        CGContextStrokePath(context);
        offsetLeft += 20;
        [[UIColor grayColor] set];
        [@"推广合作渠道" drawAtPoint:CGPointMake(offsetLeft , offsetTop - 9) withFont:[UIFont systemFontOfSize:12]];
    }
}

- (CGFloat)yWithValue:(CGFloat)value {
    CGFloat height = (value - self.minValue) / (self.maxValue - self.minValue) * (self.bounds.size.height - _paddingBottom - _paddingTop);
    return self.bounds.size.height - _paddingBottom - height;
}


@end


@interface HXMuchBarChartView : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL isShowLeft;
@property (nonatomic, assign) BOOL isZheng;
@property (nonatomic, assign) CGFloat maxValue;
@property (nonatomic, assign) CGFloat minValue;
@property (nonatomic, assign) int verticalCount;
@property (nonatomic, copy) NSArray *colors;
@property (nonatomic, copy) NSArray *datas;

@end

@implementation HXMuchBarChartView {
    CGFloat paddingTop;
    CGFloat paddingBottom;
    CGFloat paddingLeft;
    CGFloat paddingRight;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]){
        paddingTop = 60;
        paddingBottom = 80;
        paddingLeft = 80;
        paddingRight = 20;
    }
    return self;
}

- (void)layoutSubviews {
    for (UIView *view in [self subviews]) {
        [view removeFromSuperview];
    }
    
    NSArray *xNames = @[@"WAP", @"富媒体", @"客户端1x、2x", @"客户端4x", @"客户端5x", @"其他"];
    
    CGFloat xEvery = (self.bounds.size.width - paddingLeft - paddingRight) / [xNames count];
    for (int i = 0; i < [xNames count]; i++) {
        NSString *text = [xNames objectAtIndex:i];
        CGFloat offset = [text sizeWithFont:[UIFont systemFontOfSize:12]].width / 4;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft + xEvery * i - 4, self.bounds.size.height - paddingBottom + 5 + offset, xEvery + 8, 13)];
        label.font = [UIFont systemFontOfSize:12];
        
        label.text = [xNames objectAtIndex:i];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor grayColor];
        label.transform = CGAffineTransformMakeRotation(-M_PI_2 / 3);
        [self addSubview:label];
    }
}

- (void)drawRect:(CGRect)rect {
    CGFloat tempTop = paddingTop;
    [self.title drawInRect:CGRectMake(0, tempTop - 30, rect.size.width, 20)
                  withFont:[UIFont systemFontOfSize:15]
             lineBreakMode:NSLineBreakByTruncatingTail
                 alignment:NSTextAlignmentCenter];
   // tempTop += 30;
    
    if (self.isShowLeft) {
        [@"x10000" drawRotationAtPoint:CGPointMake(30, tempTop + 100) withFont:[UIFont systemFontOfSize:12] angle:M_PI_2];
    }
    
    CGFloat everyV = (rect.size.height - tempTop - paddingBottom ) / (self.verticalCount - 1);
    CGFloat everyVValue = (self.maxValue - self.minValue) * 1.0 / (self.verticalCount - 1);
    for (int i = 0; i < self.verticalCount; i++) {
        NSString *drawStr = nil;
        if (self.isZheng) {
            drawStr = [NSString stringWithFormat:@"%d", (int)(self.maxValue - everyVValue * i)];
        }
        else {
            drawStr = [NSString stringWithFormat:@"%.2f", self.maxValue - everyVValue * i];
        }
        [drawStr drawInRect:CGRectMake(paddingLeft - 40, tempTop - 7 + everyV * i, 35, 20)
                   withFont:[UIFont systemFontOfSize:12]
              lineBreakMode:NSLineBreakByTruncatingTail
                  alignment:NSTextAlignmentRight];
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, paddingLeft, rect.size.height - paddingBottom);
    CGContextAddLineToPoint(context, rect.size.width - paddingRight, rect.size.height - paddingBottom);
    CGContextStrokePath(context);
    
    NSArray *dates = @[@"2014/02/23", @"2014/02/24", @"2014/02/25", @"2014/02/26", @"2014/02/27", @"2014/02/28", @"2014/03/01"];
    
    CGFloat offsetLeft = 30;
    for (int i = 0; i < [dates count]; i++) {
        UIColor *color = [self.colors objectAtIndex:i];
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGFloat offsetTop = rect.size.height - 20;
        CGContextFillRect(context, CGRectMake(offsetLeft, offsetTop, 5, 5));
        [[UIColor darkGrayColor] set];
        [[dates objectAtIndex:i] drawAtPoint:CGPointMake(offsetLeft + 8, offsetTop - 4) withFont:[UIFont systemFontOfSize:10]];
        offsetLeft += 70;
    }
    
    CGFloat everyXWidth = (rect.size.width - paddingLeft - paddingRight) / 6;
    CGFloat everyOffsetX = everyXWidth / 9;
    for (int i = 0; i < [self.datas count]; i++) {
        NSArray *data = [self.datas objectAtIndex:i];
        for (int j = 0; j < [data count]; j++) {
            UIColor *color = [self.colors objectAtIndex:j];
            CGContextSetFillColorWithColor(context, color.CGColor);
            CGContextFillRect(context, CGRectMake(paddingLeft + everyXWidth * i + everyOffsetX * (j + 1) , rect.size.height - paddingBottom, everyOffsetX, [self heightWithValue:[[data objectAtIndex:j] floatValue]] * -1));
        }
    }
}

- (CGFloat)heightWithValue:(CGFloat)value {
    return (self.bounds.size.height - paddingTop - paddingBottom) * value / (self.maxValue - self.minValue);
}

@end


@interface HXDetailChartViewController ()<MYDrawContentViewDrawDelegate,HXSectionMenuViewDelegate, HXSectionMenuViewDataSource, HXTableChartViewDataSource, UIScrollViewDelegate>

@end

@implementation HXDetailChartViewController {
    TYSXDetailChartDataCtr *detailChartCtr;
    NSMutableArray *plotData;
    MYDrawContentView *topView;
    UIButton *currentMenuBtn;
    UIScrollView *scrollView;
    BOOL isShowFloatView;
    NSRange range1;
    NSRange range2;
    HXTableChartView *table1;
    HXTableChartView *table2;
    UIView *showTopView;
}

- (id)initWithPlotName:(NSString *)plotName;
{
    self = [super init];
    if (self) {
        detailChartCtr = [[TYSXDetailChartDataCtr alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //[detailChartCtr updateData];
    int offsetTop = 0;
    
    topView = [[MYDrawContentView alloc] initWithFrame:CGRectMake(0, 0, kScreenHeight, 150)];
    topView.autoresizingMask = UIViewAutoresizingNone;
    topView.backgroundColor = [UIColor grayColorWithGrayDegree:237/255.0];
    topView.drawDelegate = self;
    [self.view addSubview:topView];
    
    int btnInterval = 40;
    UIButton *firstBtn = [self buttonWithTitle:@"总体自订购情况" origin:CGPointMake(87, topView.bounds.size.height - 9 - 40)];
    firstBtn.tag = kMenuBtnBaseValue;
    [topView addSubview:firstBtn];
    
    UIButton *secondBtn = [self buttonWithTitle:@"新增退订数量构成" origin:CGPointMake(firstBtn.frame.origin.x + firstBtn.bounds.size.width + btnInterval, firstBtn.frame.origin.y)];
    secondBtn.tag = kMenuBtnBaseValue + 1;
    [topView addSubview:secondBtn];
    
    UIButton *thirdBtn = [self buttonWithTitle:@"各项重要指标" origin:CGPointMake(secondBtn.frame.origin.x + secondBtn.bounds.size.width + btnInterval, secondBtn.frame.origin.y)];
    thirdBtn.tag = kMenuBtnBaseValue + 2;
    [topView addSubview:thirdBtn];
    
    UIButton *fourthBtn = [self buttonWithTitle:@"登录UV" origin:CGPointMake(thirdBtn.frame.origin.x + thirdBtn.bounds.size.width + btnInterval, secondBtn.frame.origin.y)];
    fourthBtn.tag = kMenuBtnBaseValue + 3;
    [topView addSubview:fourthBtn];
    
    offsetTop += topView.bounds.size.height;
    
//    HXSectionMenuView *menuView = [[HXSectionMenuView alloc] initWithFrame:CGRectMake(0, offsetTop, kScreenHeight, 100)];
//    menuView.delegate = self;
//    menuView.dataSource = self;
//    menuView.backgroundColor = [UIColor grayColorWithGrayDegree:237/255.0];
//    [self.view addSubview:menuView];
//    
//    offsetTop += menuView.bounds.size.height;
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, offsetTop, kScreenHeight, kScreenWidth - offsetTop)];
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    [self switchSubView:firstBtn];
    
//    scrollView.contentSize = CGSizeMake(kScreenHeight, 700 + kScreenWidth - offsetTop);
    
//    [self makeScrollViewSubViewWithIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
	// Do any additional setup after loading the view.
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
    [showTopView removeFromSuperview];
    isShowFloatView = NO;
    
    CGFloat offsetTop = 0;
    CGFloat intervalY = 4;
    offsetTop += intervalY;
    switch (sender.tag - kMenuBtnBaseValue) {
        case 0:
        {
            MYDrawContentView *drawView = [[MYDrawContentView alloc] initWithFrame:CGRectMake(0, offsetTop, kScreenHeight, 400)];
            drawView.tag = kCharDetailViewTag;
            drawView.drawDelegate = self;
            drawView.backgroundColor = [UIColor grayColorWithGrayDegree:237/255.0];
            [scrollView addSubview:drawView];
            offsetTop += drawView.bounds.size.height + intervalY;
            
            HXNodeLineChartView *chartView1 = [[HXNodeLineChartView alloc] initWithFrame:CGRectMake(0, offsetTop, kScreenHeight / 2, 300)];
            chartView1.backgroundColor = [UIColor grayColorWithGrayDegree:237/255.0];
            chartView1.title = @"新增情况";
            chartView1.maxValue = 1;
            chartView1.minValue = 0;
            chartView1.data = detailChartCtr.add;
            chartView1.verticalCount = 10;
            [scrollView addSubview:chartView1];
            
            HXNodeLineChartView *chartView2 = [[HXNodeLineChartView alloc] initWithFrame:CGRectMake(kScreenHeight / 2, offsetTop, kScreenHeight / 2, 300)];
            chartView2.backgroundColor = [UIColor grayColorWithGrayDegree:237/255.0];
            chartView2.title = @"退订情况";
            chartView2.maxValue = 1;
            chartView2.minValue = 0;
            chartView2.data = detailChartCtr.unadd;
            chartView2.verticalCount = 10;
            [scrollView addSubview:chartView2];
            scrollView.delegate = nil;
            offsetTop += chartView1.bounds.size.height;
            
           // offsetTop += chartView2.bounds.size.height;
        }
            break;
        case 1:
        {
            HXMuchBarChartView *chartView1 = [[HXMuchBarChartView alloc] initWithFrame:CGRectMake(0, offsetTop, kScreenHeight / 2, 400)];
            chartView1.backgroundColor = [UIColor grayColorWithGrayDegree:237/255.0];
            chartView1.title = @"平台自然新增数量构成";
            chartView1.isShowLeft = YES;
            chartView1.maxValue = 0.35;
            chartView1.datas = detailChartCtr.ziranAdd;
            chartView1.colors = @[
                                  [UIColor colorWithRed:136/255.0 green:55/255.0 blue:52/255.0 alpha:1],
                                  [UIColor colorWithRed:158/255.0 green:65/255.0 blue:62/255.0 alpha:1],
                                  [UIColor colorWithRed:176/255.0 green:73/255.0 blue:70/255.0 alpha:1],
                                  [UIColor colorWithRed:192/255.0 green:80/255.0 blue:77/255.0 alpha:1],
                                  [UIColor colorWithRed:206/255.0 green:134/255.0 blue:132/255.0 alpha:1],
                                  [UIColor colorWithRed:217/255.0 green:170/255.0 blue:169/255.0 alpha:1],
                                  [UIColor colorWithRed:228/255.0 green:197/255.0 blue:197/255.0 alpha:1],
                                  
                                  ];
            chartView1.minValue = 0;
//            chartView1.data = detailChartCtr.add;
            chartView1.verticalCount = 8;
            [scrollView addSubview:chartView1];
            
            HXMuchBarChartView *chartView2 = [[HXMuchBarChartView alloc] initWithFrame:CGRectMake(kScreenHeight / 2, offsetTop, kScreenHeight / 2, 400)];
            chartView2.backgroundColor = [UIColor grayColorWithGrayDegree:237/255.0];
            chartView2.title = @"平台自然退订数量构成";
            chartView2.maxValue = 4000;
            chartView2.minValue = 0;
            chartView2.colors = @[
                                  [UIColor colorWithRed:54/255.0 green:90/255.0 blue:134/255.0 alpha:1],
                                  [UIColor colorWithRed:64/255.0 green:105/255.0 blue:156/255.0 alpha:1],
                                  [UIColor colorWithRed:72/255.0 green:118/255.0 blue:172/255.0 alpha:1],
                                  [UIColor colorWithRed:79/255.0 green:130/255.0 blue:189/255.0 alpha:1],
                                  [UIColor colorWithRed:133/255.0 green:160/255.0 blue:202/255.0 alpha:1],
                                  [UIColor colorWithRed:170/255.0 green:186/255.0 blue:215/255.0 alpha:1],
                                  [UIColor colorWithRed:197/255.0 green:208/255.0 blue:225/255.0 alpha:1],
                                  
                                  ];
            chartView2.isZheng = YES;
            chartView2.datas = detailChartCtr.ziranUnAdd;
            chartView2.verticalCount = 9;
            [scrollView addSubview:chartView2];
            offsetTop += chartView1.bounds.size.height + intervalY;

            
            HXTableChartView *tableChartView1 = [self makeGeneralTableChartView];
            tableChartView1.frame = CGRectMake(0, offsetTop, kScreenHeight, 40 * [[detailChartCtr hezuoadd] count] + 140);
            tableChartView1.paddingTop = 80;
            tableChartView1.title = @"合作推广新增订购主要构成";
            tableChartView1.paddingLeft = (kScreenHeight - 750) / 2;
            tableChartView1.backgroundColor = [UIColor grayColorWithGrayDegree:237/255.0];
            tableChartView1.identifier = @"合作推广新增订购主要构成";
            tableChartView1.dataSource = self;
            offsetTop += tableChartView1.bounds.size.height + intervalY;
            [scrollView addSubview:tableChartView1];
            
            HXTableChartView *tableChartView2 = [self makeGeneralTableChartView];
            tableChartView2.frame = CGRectMake(0, offsetTop, kScreenHeight, 40 * [detailChartCtr.hezuounadd count] + 140);
            tableChartView2.paddingTop = 80;
            tableChartView2.title = @"合作推广退订主要构成";
            tableChartView2.paddingLeft = (kScreenHeight - 750) / 2;;
            tableChartView2.backgroundColor = [UIColor grayColorWithGrayDegree:237/255.0];
            tableChartView2.identifier = @"合作推广退订主要构成";
            tableChartView2.dataSource = self;
            offsetTop += tableChartView2.bounds.size.height + intervalY;
            [scrollView addSubview:tableChartView2];
            
             scrollView.delegate = self;
            table1 = tableChartView1;
            table2 = tableChartView2;
        }
            break;
        case 2:
        {
            HXTableChartView *tableChartView1 = [self makeGeneralTableChartView];
            tableChartView1.frame = CGRectMake(0, offsetTop, kScreenHeight, 40 * [[detailChartCtr pingtaiTop] count] + 140);
            tableChartView1.paddingTop = 80;
            tableChartView1.title = @"平台自然渠道";
            tableChartView1.paddingLeft = (kScreenHeight - 800) / 2;
            tableChartView1.backgroundColor = [UIColor grayColorWithGrayDegree:237/255.0];
            tableChartView1.identifier = @"平台自然渠道";
            tableChartView1.dataSource = self;
            offsetTop += tableChartView1.bounds.size.height + intervalY;
            [scrollView addSubview:tableChartView1];
            
            HXTableChartView *tableChartView2 = [self makeGeneralTableChartView];
            tableChartView2.frame = CGRectMake(0, offsetTop, kScreenHeight, 40 * [detailChartCtr.hezuoTop count] + 140);
            tableChartView2.paddingTop = 80;
            tableChartView2.title = @"合作推广渠道";
            tableChartView2.paddingLeft = (kScreenHeight - 800) / 2;
            tableChartView2.backgroundColor = [UIColor grayColorWithGrayDegree:237/255.0];
            tableChartView2.identifier = @"合作推广渠道";
            tableChartView2.dataSource = self;
            offsetTop += tableChartView2.bounds.size.height + intervalY;
            [scrollView addSubview:tableChartView2];
            scrollView.delegate = self;
            
            table1 = tableChartView1;
            table2 = tableChartView2;
        }

            break;
        case 3:
        {
            HXTableChartView *tableChartView1 = [self makeGeneralTableChartView];
            tableChartView1.frame = CGRectMake(0, offsetTop, kScreenHeight, 40 * [[detailChartCtr pingtai] count] + 140);
            tableChartView1.paddingTop = 80;
            tableChartView1.title = @"平台自然渠道TOP10";
            tableChartView1.paddingLeft = (kScreenHeight - 750) / 2;
            tableChartView1.backgroundColor = [UIColor grayColorWithGrayDegree:237/255.0];
            tableChartView1.identifier = @"平台自然渠道TOP10";
            tableChartView1.dataSource = self;
            offsetTop += tableChartView1.bounds.size.height + intervalY;
            [scrollView addSubview:tableChartView1];
            
            HXTableChartView *tableChartView2 = [self makeGeneralTableChartView];
            tableChartView2.frame = CGRectMake(0, offsetTop, kScreenHeight, 40 * [detailChartCtr.hezuo count] + 140);
            tableChartView2.paddingTop = 80;
            tableChartView2.title = @"合作推广渠道TOP10";
            tableChartView2.paddingLeft = (kScreenHeight - 750) / 2;
            tableChartView2.backgroundColor = [UIColor grayColorWithGrayDegree:237/255.0];
            tableChartView2.identifier = @"合作推广渠道TOP10";
            tableChartView2.dataSource = self;
            offsetTop += tableChartView2.bounds.size.height + intervalY;
            [scrollView addSubview:tableChartView2];
            scrollView.delegate = self;
            
            table1 = tableChartView1;
            table2 = tableChartView2;
        }
            break;
        default:
            break;
    }
    scrollView.contentSize = CGSizeMake(kScreenHeight, offsetTop);
    
}


- (void)contentView:(MYDrawContentView*)view drawRect:(CGRect)rect {
    if (view.tag == kCharDetailViewTag) {
        CGFloat offsetTop = 40;
        CGFloat leftPadding = 50;
        for (NSString *summaryString in detailChartCtr.summaryStrings) {
            [summaryString  drawInRect:CGRectMake(leftPadding, offsetTop, rect.size.width - 2 * leftPadding, 24800)
                                             withFont:[UIFont systemFontOfSize:16] lineBreakMode:NSLineBreakByTruncatingTail];
            offsetTop += [summaryString sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(rect.size.width - 2 * leftPadding, 20480)].height + 8;
        }
        
        return;
    }
    int offsetTop = 10;
    int offsetLeft = 29;
    [[UIImage imageNamed:@"logo_lit.png"] drawAtPoint:CGPointMake(offsetLeft, offsetTop)];
    
    [[UIColor grayColor] set];
    [@"天翼视讯渠道经营日报统计系统" drawAtPoint:CGPointMake(87, 18) withFont:[UIFont systemFontOfSize:18]];
    
    offsetTop += 34;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, 0, offsetTop);
    CGContextAddLineToPoint(context, rect.size.width, offsetTop);
    CGContextSetLineWidth(context, 0.7);
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextStrokePath(context);
    
    offsetTop += 3;
    
    CGContextSetFillColorWithColor(context, [UIColor grayColorWithGrayDegree:211/255.0].CGColor);
    CGContextFillRect(context, CGRectMake(0, offsetTop, rect.size.width, 38));
    
    [[UIColor grayColor] set];
    [@"2014-03-01" drawAtPoint:CGPointMake(87, offsetTop + 10) withFont:[UIFont systemFontOfSize:16]];
    [[UIColor whiteColor] set];
//    [@"CRM订购情况" drawInRect:CGRectMake(0, offsetTop + 7, rect.size.width, 25)
//                  withFont:[UIFont systemFontOfSize:20]
//             lineBreakMode:NSLineBreakByTruncatingTail
//                 alignment:NSTextAlignmentCenter];
    
//    CGContextSetFillColorWithColor(context, [UIColor grayColorWithGrayDegree:211 / 255.0].CGColor);
//    CGContextFillRect(context, CGRectMake(0, offsetTop, kScreenHeight, rect.size.height - offsetTop));
//    
//    offsetTop += 8;
//    [[UIColor grayColorWithGrayDegree:29/ 255.0] set];
//    [detailChartCtr.lastDate drawAtPoint:CGPointMake(75, offsetTop) withFont:[UIFont systemFontOfSize:15]];
//    [@"渠道包月新增" drawInRect:CGRectMake(0, offsetTop, rect.size.width, 20) withFont:[UIFont systemFontOfSize:15] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
}

- (void)contentView:(MYDrawContentView*)view touchBeginAtPoint:(CGPoint)p {
    if (p.y < 44 && p.x < 280 && view.tag != kTableDrawViewTag) {
        [self backMenuView];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

#pragma mark HXSectionMenuView datasource and  delegate
- (NSInteger)numberOfSectionsInSectionMenuView:(HXSectionMenuView *)menuView {
    return [[detailChartCtr sectionTitles] count];
}

- (NSString *)sectionMenuView:(HXSectionMenuView *)sectionMenuView titleInSection:(NSInteger)section {
    return [[detailChartCtr sectionTitles] objectAtIndex:section];
}

- (NSInteger)sectionMenuView:(HXSectionMenuView *)sectionMenuView numberOfRowsInSection:(NSInteger)section {
    return [[detailChartCtr rowTitlesWithSection:section] count];
}

- (NSString *)sectionMenuView:(HXSectionMenuView *)sectionMenuView titleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[detailChartCtr rowTitlesWithSection:indexPath.section] objectAtIndex:indexPath.row];
}

#pragma mark table chart view data source

- (NSInteger)numberOfRowsInTableChartView:(HXTableChartView *)tableChartView {
    NSArray *array = nil;
    if ([tableChartView.identifier isEqualToString:@"平台自然渠道TOP10"]) {
        array = detailChartCtr.pingtaiTop;
    }
    else if ([tableChartView.identifier isEqualToString:@"合作推广渠道TOP10"]) {
        array = detailChartCtr.hezuoTop;
    }
    else if ([tableChartView.identifier isEqualToString:@"平台自然渠道"]) {
        array = detailChartCtr.pingtai;
    }
    else if ([tableChartView.identifier isEqualToString:@"合作推广渠道"]) {
        array = detailChartCtr.hezuo;
    }
    else if ([tableChartView.identifier isEqualToString:@"合作推广新增订购主要构成"]) {
        array = detailChartCtr.hezuoadd;
    }
    else if ([tableChartView.identifier isEqualToString:@"合作推广退订主要构成"]) {
        array = detailChartCtr.hezuounadd;
    }
    return [array count];
}

- (NSInteger)numberOfColumnsInTableChartView:(HXTableChartView *)tableChartView {
    int ret = 0;
    if ([tableChartView.identifier isEqualToString:@"平台自然渠道TOP10"] ||
        [tableChartView.identifier isEqualToString:@"合作推广新增订购主要构成"] ||
        [tableChartView.identifier isEqualToString:@"合作推广渠道TOP10"] ||
        [tableChartView.identifier isEqualToString:@"合作推广退订主要构成"]) {
        ret = 3;
    }
    else if([tableChartView.identifier isEqualToString:@"平台自然渠道"] ||
            [tableChartView.identifier isEqualToString:@"合作推广渠道"]) {
        ret = 5;
    }
    
    return ret;
}

- (CGFloat)tableChartView:(HXTableChartView *)tableChartView widthOfColumn:(NSInteger)column {
    CGFloat ret = 0;
    ret = 100;
    if ([tableChartView.identifier isEqualToString:@"平台自然渠道TOP10"] ||
        [tableChartView.identifier isEqualToString:@"合作推广渠道TOP10"] ||
        [tableChartView.identifier isEqualToString:@"合作推广新增订购主要构成"] ||
        [tableChartView.identifier isEqualToString:@"合作推广退订主要构成"]) {
        if (column == 0) {
            ret = 400;
        }
        else if (column == 1) {
            ret = 200;
        }
        else {
            ret = 150;
        }
    }
    else if ([tableChartView.identifier isEqualToString:@"平台自然渠道"] ||
             [tableChartView.identifier isEqualToString:@"合作推广渠道"]){
        if (column == 0) {
            ret = 400;
        }
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
    NSArray *array = nil;
    if ([tableChartView.identifier isEqualToString:@"平台自然渠道TOP10"]) {
        array = detailChartCtr.pingtaiTop;
    }
    else if ([tableChartView.identifier isEqualToString:@"合作推广渠道TOP10"]) {
        array = detailChartCtr.hezuoTop;
    }
    else if ([tableChartView.identifier isEqualToString:@"平台自然渠道"]) {
        array = detailChartCtr.pingtai;
    }
    else if ([tableChartView.identifier isEqualToString:@"合作推广渠道"]) {
        array = detailChartCtr.hezuo;
    }
    else if ([tableChartView.identifier isEqualToString:@"合作推广新增订购主要构成"]) {
        array = detailChartCtr.hezuoadd;
    }
    else if ([tableChartView.identifier isEqualToString:@"合作推广退订主要构成"]) {
        array = detailChartCtr.hezuounadd;
    }
    return [[array objectAtIndex:row] objectAtIndex:column];
}

- (BOOL)tableChartView:(HXTableChartView *)tableChartView
    needDrawTrendOfRow:(NSInteger)row
                column:(NSInteger)column {
    if (row == 0) {
        return  NO;
    }
    if ([tableChartView.identifier isEqualToString:@"平台自然渠道TOP10"] ||
        [tableChartView.identifier isEqualToString:@"合作推广渠道TOP10"] ||
        [tableChartView.identifier isEqualToString:@"合作推广新增订购主要构成"] ||
        [tableChartView.identifier isEqualToString:@"合作推广退订主要构成"]) {
        if (column == 2) {
            return YES;
        }
    }

    
    return NO;
}

- (eDrawDirection)tableChartView:(HXTableChartView *)tableChartView
         drawTrendDerictionOfRow:(NSInteger)row
                          column:(NSInteger)column {
    double showNumber = 0;
    if ([tableChartView.identifier isEqualToString:@"平台自然渠道TOP10"]) {
        showNumber = [[[detailChartCtr.pingtaiTop objectAtIndex:row] objectAtIndex:column] doubleValue];
    }
    else if ([tableChartView.identifier isEqualToString:@"合作推广渠道TOP10"]) {
        showNumber = [[[detailChartCtr.hezuoTop objectAtIndex:row] objectAtIndex:column] doubleValue];
    }
    else if ([tableChartView.identifier isEqualToString:@"合作推广新增订购主要构成"]) {
        showNumber = [[[detailChartCtr.hezuoadd objectAtIndex:row] objectAtIndex:column] doubleValue];
    }
    else if ([tableChartView.identifier isEqualToString:@"合作推广退订主要构成"]){
        showNumber = [[[detailChartCtr.hezuounadd objectAtIndex:row] objectAtIndex:column] doubleValue];
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

#pragma mark -- uiscroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!isShowFloatView &&
        [table1 convertPoint:CGPointMake(0, 0) toView:self.view].y < topView.frame.size.height &&
        [table1 convertPoint:CGPointMake(0, table1.paddingTop + 40 * 11) toView:self.view].y > topView.frame.size.height + showTopView.bounds.size.height) {
        showTopView = [table1 showTopView];
        isShowFloatView = YES;
        showTopView.frame = CGRectMake(0, topView.frame.origin.y + topView.frame.size.height, showTopView.frame.size.width, showTopView.frame.size.height);
        [self.view addSubview:showTopView];
    }
    else if (isShowFloatView && [table1 convertPoint:CGPointMake(0, 0) toView:self.view].y > topView.frame.size.height) {
        [showTopView removeFromSuperview];
        isShowFloatView = NO;
    }
    else if (isShowFloatView &&
             [table1 convertPoint:CGPointMake(0, table1.paddingTop + 40 * 11) toView:self.view].y < topView.frame.size.height + showTopView.bounds.size.height &&
             [table1 convertPoint:CGPointMake(0, table1.paddingTop + 40 * 11) toView:self.view].y > topView.frame.size.height) {
        [showTopView removeFromSuperview];
        isShowFloatView = NO;
        showTopView.frame = CGRectMake(0, table1.paddingTop + 40 * 11 - showTopView.bounds.size.height, showTopView.bounds.size.width, showTopView.bounds.size.height);
        [table1 addSubview:showTopView];
    }
    else if (!isShowFloatView && [table2 convertPoint:CGPointMake(0, 0) toView:self.view].y < topView.frame.size.height) {
        showTopView = [table2 showTopView];
        isShowFloatView = YES;
        showTopView.frame = CGRectMake(0, topView.frame.origin.y + topView.frame.size.height, showTopView.frame.size.width, showTopView.frame.size.height);
        [self.view addSubview:showTopView];
    }
    else if (isShowFloatView && [table2 convertPoint:CGPointMake(0, 0) toView:self.view].y > topView.frame.size.height && [table2 convertPoint:CGPointMake(0, 0) toView:self.view].y < topView.frame.size.height + 20) {
        [showTopView removeFromSuperview];
        isShowFloatView = NO;
    }
}

@end

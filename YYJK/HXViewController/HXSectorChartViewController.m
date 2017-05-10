//
//  HXSectorChartViewController.m
//  tysx
//
//  Created by zwc on 14-10-17.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "HXSectorChartViewController.h"
#import "MYDrawContentView.h"
#import "HXTurntableControl.h"

@interface HXSectorChartViewController()<MYDrawContentViewDrawDelegate, HXTurntableControlDelegate>

@end

@implementation HXSectorChartViewController {
    NSString *plotName;
    NSArray *colors;
    NSArray *values;
    NSArray *itemTitles;
    HXTurntableControl *turntableControl;
    MYDrawContentView *drawView;
}

- (id)initWithPlotName:(NSString *)name {
    if (self = [super init]) {
        plotName = name;
        itemTitles = @[@"50英寸", @"32英寸", @"42英寸", @"55英寸", @"39英寸", @"40英寸", @"48英寸", @"46英寸", @"47英寸", @"60英寸", @"其它"];
        colors = @[[UIColor colorWithHexString:@"#04621a"],
                  [UIColor colorWithHexString:@"#195828"],
                  [UIColor colorWithHexString:@"#287a3c"],
                  [UIColor colorWithHexString:@"#3c9d53"],
                  [UIColor colorWithHexString:@"#50b167"],
                  [UIColor colorWithHexString:@"#62c279"],
                  [UIColor colorWithHexString:@"#74d18a"],
                  [UIColor colorWithHexString:@"#d48a3a"],
                  [UIColor colorWithHexString:@"#d4693a"],
                  [UIColor colorWithHexString:@"#e46b47"],
                  [UIColor colorWithHexString:@"#d4453a"]];
        values = @[@16, @15, @14, @13, @9, @8, @6, @5, @5, @3, @6];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    drawView = [[MYDrawContentView alloc] initWithFrame:self.view.bounds];
    drawView.drawDelegate = self;
    [self.view addSubview:drawView];
    
    turntableControl = [[HXTurntableControl alloc] initWithFrame:CGRectMake(50, 150, 550, 550)];
    turntableControl.delegate = self;
    turntableControl.colors = colors;
    turntableControl.values = values;
    [self.view addSubview:turntableControl];
    
}

- (void)contentView:(MYDrawContentView*)view drawRect:(CGRect)rect {
    int offsetTop = 10;
    int offsetLeft = 29;
    [[UIImage imageNamed:@"logo_lit.png"] drawAtPoint:CGPointMake(offsetLeft, offsetTop)];
    
    UIColor *textColor = [UIColor grayColor];
    UIFont *textFont = [UIFont systemFontOfSize:18];
    
    NSMutableDictionary *textAttr = [NSMutableDictionary dictionary];
    [textAttr setObject:textFont forKey:NSFontAttributeName];
    [textAttr setObject:textColor forKey:NSForegroundColorAttributeName];
    
    [plotName drawAtPoint:CGPointMake(87, 18) withAttributes:textAttr];
    
    offsetTop += 34;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, 0, offsetTop);
    CGContextAddLineToPoint(context, rect.size.width, offsetTop);
    CGContextSetLineWidth(context, 0.7);
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, turntableControl.x + turntableControl.width + 30, offsetTop);
    CGContextAddLineToPoint(context, turntableControl.x + turntableControl.width + 30, rect.size.height);
    CGContextStrokePath(context);
    
    textFont = [UIFont systemFontOfSize:25];
    [textAttr setObject:textFont forKey:NSFontAttributeName];
    NSString *currentItemRate = [NSString stringWithFormat:@"%@:%.1f%%", itemTitles[turntableControl.currentIndex], turntableControl.currentRate * 100];
    [currentItemRate drawAtPoint:CGPointMake(250, 80) withAttributes:textAttr];
    
    offsetLeft = 742;
    offsetTop = 189;
    CGFloat intervalX = 15;
    CGFloat intervalY = 22;
    CGFloat colorHeight = 20;
    
    textFont = [UIFont systemFontOfSize:17];
    [textAttr setObject:textFont forKey:NSFontAttributeName];
    
    for (int i = 0; i < [colors count]; i++) {
        UIColor *fillColor = colors[i];
        CGContextSetFillColorWithColor(context, fillColor.CGColor);
        CGContextFillRect(context, CGRectMake(offsetLeft, offsetTop, colorHeight, colorHeight));
        [itemTitles[i] drawInRect:CGRectMake(offsetLeft + colorHeight + intervalX, offsetTop, 200, 20) withAttributes:textAttr];
        offsetTop += colorHeight + intervalY;
    }
}

- (void)turntableControlDidChangeIndex:(HXTurntableControl *)control {
    [drawView setNeedsDisplay];
}

- (void)contentView:(MYDrawContentView*)view touchBeginAtPoint:(CGPoint)p {
    if (p.y < 44 && p.x < 280) {
        [self backMenuView];
    }
}

@end

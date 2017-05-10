//
//  HXMainMenuViewController.m
//  tysx
//
//  Created by zwc on 13-11-27.
//  Copyright (c) 2013年 huangjia. All rights reserved.
//

#import "HXMainMenuViewController.h"
#import "HXMapButtonViewController.h"
#import "HXChartMainViewController.h"
#import "TYSXClientViewController.h"
#import "HXLoginViewController.h"
#import "HXCRMViewController.h"
#import "HXBottomInfoButton.h"
#import "HXDetailChartViewController.h"
#import "MYDrawContentView.h"
#import "PageCellViewController.h"
#import "HXSegmentedControl.h"
#import "PageViewController.h"
#import "HXSettingViewController.h"
#import "HXTransformRateViewController.h"
#import "HXPlatformDataViewController.h"
#import "HXSuccessRateViewController.h"
#import "HXIPOrderAbnormalViewController.h"
#import "UIView+CornerRadius.h"
#import "HXAAAFailureViewController.h"
#import "HXSectorChartViewController.h"
#import "IPTVActiveUsersViewController.h"
#import "IPTVHDUsersViewController.h"
#import "IPTVPowerUsersViewController.h"
#import "TYSXLoginUserViewController.h"
#import "TYSXLoginUserChannelViewController.h"
#import "TYSXStreamMediaMonitorViewController.h"
#import "TYSXTempShowViewController.h"
#import "TYSXProductPackageOrderViewController.h"
#import "TYSXProductPackageUnsubscribeViewController.h"
#import "TYSXPlatLoginPlayViewController.h"
#import "TYSXLoveLook4GViewController.h"
#import "TYSXKeyProductPackageViewController.h"
#import "TYSXSplitScreenRealTimeViewController.h"
#import "TYSXOrderAndUnViewController.h"
#import "IPTVTempViewController.h"
#import "TYSXMonitorCtr.h"
#import "HXPlotListCtr.h"
#import "OSSMemberCache.h"
#import <objc/runtime.h>

#define kSettingViewTag 2000
#define kControlViewTag 2001
#define kControlBgViewTag 2002
#define kInfoDrawViewTag 2003

#define kLeftSettingViewWidth 256

@interface MonitorMenuCell : UIButton

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *dateStr;
@property (nonatomic, assign) long long sumValue;
@property (nonatomic, assign) int tongbiQuestionNum;
@property (nonatomic, assign) int hunbiQuestionNum;
@property (nonatomic, assign) int status;
@property (nonatomic, assign) int showType;

@end

@implementation MonitorMenuCell {
    int _status;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 150, 175)]) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor grayColor].CGColor;
    }
    return self;
}

- (void)setStatus:(int)status {
    if (status != _status) {
        _status = status;
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    UIColor *topFillColor = nil;
    UIColor *fontColor = nil;
    switch (_status) {
        case 0:
            topFillColor = [UIColor colorWithHexString:@"74de00"];
            fontColor = [UIColor colorWithHexString:@"2d5500"];
            break;
        case 1:
            topFillColor = [UIColor colorWithHexString:@"fa0c00"];
            fontColor = [UIColor colorWithHexString:@"75000b"];
            break;
            
        default:
            break;
    }
    
    CGContextSetFillColorWithColor(ctx, topFillColor.CGColor);
    CGContextFillRect(ctx, UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(0, 0, 30, 0)));
    
    CGContextSetFillColorWithColor(ctx,  [[UIColor colorWithHexString:@"#111C46"] colorWithAlphaComponent:0.2].CGColor);
    CGContextFillRect(ctx, CGRectMake(0, rect.size.height - 30, rect.size.width, 30));
    
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    [attr setValue:fontColor forKey:NSForegroundColorAttributeName];
    [attr setValue:[UIFont systemFontOfSize:15] forKey:NSFontAttributeName];
    
    CGFloat offsetTop = 15;
    CGFloat offsetLeft = 15;
    [@"Monitor" drawAtPoint:CGPointMake(offsetLeft, offsetTop) withAttributes:attr];
    
    offsetTop += 15 + 3;
    [self.dateStr drawAtPoint:CGPointMake(offsetLeft, offsetTop) withAttributes:attr];
    
    [attr setValue:[UIFont systemFontOfSize:12] forKey:NSFontAttributeName];
    if (self.showType == 0) {
        offsetTop += 15 + 14;
        [@"总数" drawAtPoint:CGPointMake(offsetLeft, offsetTop) withAttributes:attr];
        [attr setValue:[UIFont systemFontOfSize:24] forKey:NSFontAttributeName];
        [[NSString stringWithFormat:@"%lld", self.sumValue] drawAtPoint:CGPointMake(50, offsetTop - 10) withAttributes:attr];
    }
    else {
        offsetTop += 15 + 19;
        [@"同比问题数" drawAtPoint:CGPointMake(offsetLeft, offsetTop) withAttributes:attr];
        
        NSMutableParagraphStyle *para = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        [attr setValue:para forKey:NSParagraphStyleAttributeName];
        para.alignment = NSTextAlignmentRight;
        [attr setValue:para forKey:NSParagraphStyleAttributeName];
        
        [@"环比问题数" drawInRect:CGRectMake(0, offsetTop + 40, rect.size.width - offsetLeft, 20) withAttributes:attr];
        
        [attr setValue:[UIFont systemFontOfSize:36] forKey:NSFontAttributeName];
        [[NSString stringWithFormat:@"%d", self.tongbiQuestionNum] drawAtPoint:CGPointMake(80, offsetTop - 18) withAttributes:attr];
        
        [[NSString stringWithFormat:@"%d", self.hunbiQuestionNum] drawInRect:CGRectMake(0, offsetTop + 22, rect.size.width - 80, 40) withAttributes:attr];
    }
    
    [attr setValue:[UIFont systemFontOfSize:16] forKey:NSFontAttributeName];
    [attr setValue:kDefaultTextColor forKey:NSForegroundColorAttributeName];
    NSMutableParagraphStyle *para = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    [attr setValue:para forKey:NSParagraphStyleAttributeName];
    para.alignment = NSTextAlignmentCenter;
    [self.title drawInRect:CGRectMake(0, rect.size.height - 26, rect.size.width, 30) withAttributes:attr];
}

@end

@interface HXMenuCellView : UIView

@property (nonatomic, readonly) UIButton *button;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *contentDate;
@property (nonatomic, copy) NSString *updateDate;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, assign) CGFloat buttonHeight;

@end

@implementation HXMenuCellView {
    UIButton *_button;
}

@synthesize button;
@synthesize title;
@synthesize contentDate;
@synthesize updateDate;
@synthesize updateTime;
@synthesize buttonHeight;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - 60)];
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:_button];
    }
    
    return self;
}

- (UIButton *)button {
    return _button;
}

- (void)drawRect:(CGRect)rect {
    self.backgroundColor = [UIColor clearColor];
    CGContextRef ref = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(ref,  [[UIColor colorWithHexString:@"#111C46"] colorWithAlphaComponent:0.2].CGColor);
    CGContextFillRect(ref, CGRectMake(0, rect.size.height - 60, rect.size.width, 60));
    
    CGFloat offsetTop = rect.size.height - 60;
    
    CGFloat offsetLeft = 11;
    
    NSMutableDictionary *attribu = [NSMutableDictionary dictionary];
    [attribu setValue:[UIFont systemFontOfSize:18] forKey:NSFontAttributeName];
    [attribu setValue:kDefaultTextColor forKey:NSForegroundColorAttributeName];
    
    [self.title drawAtPoint:CGPointMake(offsetLeft, offsetTop + 9) withAttributes:attribu];
    
    [attribu setValue:[UIFont systemFontOfSize:13] forKey:NSFontAttributeName];
    [self.contentDate drawAtPoint:CGPointMake(offsetLeft, offsetTop + 9 + 18 + 7) withAttributes:attribu];
    
    NSMutableParagraphStyle *para = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    para.alignment = NSTextAlignmentRight;
    [attribu setValue:[UIFont systemFontOfSize:9] forKey:NSFontAttributeName];
    [attribu setValue:para forKey:NSParagraphStyleAttributeName];
    
    [[NSString stringWithFormat:@"更新于%@", self.updateDate] drawInRect:CGRectMake(0, offsetTop + 30, rect.size.width - offsetLeft, 30) withAttributes:attribu];
    [self.updateTime drawInRect:CGRectMake(0, offsetTop + 30 + 2 + 10, rect.size.width - offsetLeft, 30) withAttributes:attribu];
}

@end

@interface HXMainMenuViewController ()<MYDrawContentViewDrawDelegate, UIAlertViewDelegate, HXSegmentedControlDelegate>

@end

@implementation HXMainMenuViewController {
    int currentItem;
    MYDrawContentView *drawView;
    UIScrollView *scrollView;
    UILabel *dateLabel;
    UILabel *timeLabel;
    CADisplayLink *timeDisplay;
    BOOL isSettingViewShow;
    HXSegmentedControl *segment;
    HXPlotListCtr *plotListCtr;
    TYSXMonitorCtr *tysxMonitorCtr;
    NSArray *classList;
}

- (id)init
{
    self = [super init];
    if (self) {
        
//        monitorClassList = @[[TYSXLoginUserViewController class], [TYSXLoginUserChannelViewController class], [TYSXStreamMediaMonitorViewController class], [TYSXProductPackageOrderViewController class],
//            [TYSXProductPackageUnsubscribeViewController class]];
//        monitorTitles = @[@"登录用户数统计", @"登录用户渠道统计", @"流媒体监控", @"产品包订购监控", @"产品包退订监控"];
        
        plotListCtr = [[HXPlotListCtr alloc] init];
        
        tysxMonitorCtr = [[TYSXMonitorCtr alloc] init];
       // plotListCtr.organizationType = OrganizationType_IPTV;
        
        timeDisplay = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateTimeControl)];
        timeDisplay.frameInterval = 60;
        
        classList = @[@"HXSectorChartViewController",@"HXCRMViewController",@"HXDetailChartViewController"];
        
        
        
    }
    return self;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (needLogin()) {
        HXLoginViewController *ctr = [[HXLoginViewController alloc] init];
        [self presentViewController:ctr animated:NO completion:NULL];
        return;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self switchItemWithIndex:segment.currentIndex];
}

- (void)changeShowChartList {
    if ([OSSMemberCache shareCache].organizationType == OrganizationType_HUANGJIA ||
        [OSSMemberCache shareCache].organizationType == OrganizationType_Guest) {
//        viewControllerClasses = @[[HXChartMainViewController class],
//                                  [HXMapButtonViewController class],
//                                  [HXSectorChartViewController class]];
//        viewControllerTitles = @[@"同环比统计", @"分省统计", @"扇形统计"];
//        plotImageNames = @[@"first.png",@"second.png", @"bing.jpg"];
    }
    else if ([OSSMemberCache shareCache].organizationType == OrganizationType_TYSX){
        //OSSMemberCache *memCache = [OSSMemberCache shareCache];
//        viewControllerClasses = memCache.viewControllerClasses;
//        viewControllerTitles =  memCache.titles;
//        plotImageNames = memCache.defaultImageNames;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [tysxMonitorCtr sendRequestWith:^{
        if (tysxMonitorCtr.result == NetworkBaseResult_Success) {
            run_async_main(^{
                if (currentItem == 1) {
                    [self switchItemWithIndex:1];
                }
            });
        }
    }];
    
    self.navigationController.navigationBarHidden = YES;
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_bg.jpg"]];
    [self.view addSubview:bgImageView];
    [bgImageView locationAtSuperView:self.view edgeInsets:UIEdgeInsetsZero];
    
    drawView = [[MYDrawContentView alloc] initWithFrame:CGRectMake(0, 0, kScreenHeight, kScreenWidth)];
    drawView.autoresizingMask = UIViewAutoresizingNone;
    drawView.drawDelegate = self;
    
    [self.view addSubview:drawView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    [drawView addGestureRecognizer:tapGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    [self.view addGestureRecognizer:panGesture];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 110, kScreenHeight, kScreenWidth - 110)];
    scrollView.showsVerticalScrollIndicator = NO;
    [drawView addSubview:scrollView];
    
    [self switchItemWithIndex:0];
    
    segment = [[HXSegmentedControl alloc] initWithItems:@[@"业务展示", @"监控大厅", @"报表仓库",@"demo"]];
    segment.selectedColor = [UIColor colorWithHexString:@"#e3651e"];
    segment.selectedTitleColor = kDefaultTextColor;
    segment.normalTitleColor = [UIColor colorWithHexString:@"#e3651e"];
    segment.normalColor = [UIColor colorWithHexString:@"#de942b"];
    segment.itemWidth = 120;
    segment.font = [UIFont systemFontOfSize:20];
    segment.delegate = self;
    segment.itemHeight = 45;
    segment.frame = CGRectMake((kScreenHeight - segment.bounds.size.width) / 2, 45, segment.bounds.size.width, segment.bounds.size.height);
    
    [drawView addSubview:segment];
}

- (void)panGestureAction:(UIPanGestureRecognizer *)sender {
    static BOOL isWillShow = NO;
    if (sender.state == UIGestureRecognizerStateBegan) {
        isWillShow = !isSettingViewShow;
        if (!isSettingViewShow) {
            [self addLeftSettingView];
        }
    }
    else if (sender.state == UIGestureRecognizerStateChanged) {
        if (isWillShow) {
            [self changeLeftSettingViewWithDegree:[sender translationInView:sender.view].x / kLeftSettingViewWidth];
        }
        else {
            [self changeLeftSettingViewWithDegree: (1 - [sender translationInView:sender.view].x * -1 / kLeftSettingViewWidth)];
        }
    }
    else if (sender.state == UIGestureRecognizerStateEnded) {
        BOOL willHide = YES;
        if (drawView.x > kLeftSettingViewWidth / 2) {
            willHide = NO;
        }
        [UIView animateWithDuration:0.2 animations:^{
            if (willHide) {
                [self changeLeftSettingViewWithDegree:0];
            }
            else {
                [self changeLeftSettingViewWithDegree:1];
            }
        } completion:^(BOOL complete){
            if (complete && willHide) {
                [self removeLeftSettingView];
            }
        }];
    }
}

- (void)segmentedControlValueChanged:(HXSegmentedControl *)control {
    currentItem = control.currentIndex;
    [self switchItemWithIndex:control.currentIndex];
}

- (void)updateTimeControl {
    dateLabel.text = [nowDateStr() stringByAppendingFormat:@" %@", nowWeekStr()];
    timeLabel.text = nowTimeStr();
}

- (void)addLeftSettingView {
    if (!isSettingViewShow) {
        [timeDisplay addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        
        isSettingViewShow = YES;
        
        CGFloat settingWidth = kLeftSettingViewWidth;
        CGFloat offsetTop = 55;
        
        UIControl *leftSettingView = [[UIControl alloc] initWithFrame:CGRectMake(-settingWidth, 0, settingWidth, kScreenWidth)];
        leftSettingView.tag = kSettingViewTag;
        
        UIImageView *avatar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_2.png"]];
        CGFloat avatarWidth = avatar.image.size.width;
        avatar.frame = CGRectMake((settingWidth - avatarWidth) / 2, offsetTop, avatarWidth, avatarWidth);
        [leftSettingView addSubview:avatar];
        
        offsetTop += avatarWidth + 15;
        CGFloat welcomeWidth = settingWidth;
        UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake((settingWidth - welcomeWidth) / 2, offsetTop, welcomeWidth, 20)];
        welcomeLabel.font = [UIFont systemFontOfSize:18];
        welcomeLabel.textAlignment = NSTextAlignmentCenter;
        welcomeLabel.textColor = kDefaultTextColor;
        
        NSString *userName = [NSString stringWithFormat:@"欢迎您：%@",[OSSMemberCache shareCache].userName];
        if (userName.length == 0) {
            welcomeLabel.text = @"游客";
        }
        welcomeLabel.text = userName;
        [leftSettingView addSubview:welcomeLabel];
        
        CGFloat dateWidth = settingWidth;
        offsetTop += welcomeLabel.bounds.size.height + 47;
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake((settingWidth - dateWidth) / 2, offsetTop, welcomeWidth, 17)];
        dateLabel.numberOfLines = -1;
        dateLabel.font = [UIFont systemFontOfSize:15];
        dateLabel.textAlignment = NSTextAlignmentCenter;
        dateLabel.textColor = kDefaultTextColor;
        [leftSettingView addSubview:dateLabel];
        
        CGFloat timeWidth = settingWidth;
        offsetTop += dateLabel.bounds.size.height + 10;
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake((settingWidth - dateWidth) / 2, offsetTop, timeWidth, 17)];
        timeLabel.font = [UIFont systemFontOfSize:15];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.textColor = kDefaultTextColor;
        [leftSettingView addSubview:timeLabel];
        
        [self updateTimeControl];
        
        CGFloat logoutBtnWidth = settingWidth;
        UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        offsetTop += timeLabel.bounds.size.height + 30;
        
        logoutBtn.frame = CGRectMake((settingWidth - logoutBtnWidth) / 2, offsetTop, logoutBtnWidth, 49);
        logoutBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [logoutBtn setTitle:@"注 销 账 户" forState:UIControlStateNormal];
        [logoutBtn setTitleColor:kDefaultTextColor forState:UIControlStateNormal];
        [logoutBtn addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *logoutBgView = [[UIView alloc] initWithFrame:logoutBtn.frame];
        logoutBgView.backgroundColor = [UIColor colorWithHexString:@"#FFCA80"];
        logoutBgView.alpha = 0.2;
        [leftSettingView addSubview:logoutBgView];
        
        if (!kNeedVirtualData) {
            [leftSettingView addSubview:logoutBtn];
        }
        
        CGFloat versionBtnWidth = 65;
        CGFloat versionBtnHeight = 25;
        UIButton *versionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        versionBtn.frame = CGRectMake(settingWidth - versionBtnWidth, leftSettingView.bounds.size.height - 17 - versionBtnHeight, versionBtnWidth, versionBtnHeight);
        versionBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [versionBtn setTitle:@"演示版" forState:UIControlStateNormal];
        [versionBtn setTitleColor:kDefaultTextColor forState:UIControlStateNormal];
        [versionBtn addTarget:self action:@selector(showProductInfo) forControlEvents:(UIControlEventTouchUpInside)];
        [leftSettingView addSubview:versionBtn];
        
        CGFloat productBtnWidth = 120;
        CGFloat productBtnHeight = 25;
        UIButton *productBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        productBtn.frame = CGRectMake(settingWidth - productBtnWidth, versionBtn.frame.origin.y - productBtnHeight, productBtnWidth, productBtnHeight);
        productBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [productBtn setTitle:@"Monitor Oss" forState:UIControlStateNormal];
        [productBtn setTitleColor:kDefaultTextColor forState:UIControlStateNormal];
        [productBtn addTarget:self action:@selector(showProductInfo) forControlEvents:(UIControlEventTouchUpInside)];
        [leftSettingView addSubview:productBtn];
        
        [self.view addSubview:leftSettingView];
        
        UIView *controlBgView = [[UIView alloc] initWithFrame:drawView.bounds];
        UIControl *control = [[UIControl alloc] initWithFrame:controlBgView.bounds];
        controlBgView.tag = kControlBgViewTag;
        [controlBgView addSubview:control];
        [self.view addSubview:controlBgView];
        
        control.backgroundColor = [UIColor colorWithHexString:@"#03091f"];
        control.tag = kControlViewTag;
        control.alpha = 0.0;
        
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.frame = CGRectMake(17, 50, 35, 29);
        [leftBtn setBackgroundImage:[UIImage imageNamed:@"left.png"] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(dismissSettingView:) forControlEvents:UIControlEventTouchUpInside];
        [controlBgView addSubview:leftBtn];

    }
}

- (void)removeLeftSettingView {
    if (isSettingViewShow) {
        UIView *leftSettingView = [self.view viewWithTag:kSettingViewTag];
        UIView *controlBgView = [self.view viewWithTag:kControlBgViewTag];
        [leftSettingView removeFromSuperview];
        [controlBgView removeFromSuperview];
        [timeDisplay invalidate];
        isSettingViewShow = NO;
    }
}

- (void)changeLeftSettingViewWithDegree:(CGFloat)degree {
    if (degree < 0.0 || degree > 1.0) {
        return;
    }
    UIView *leftSettingView = [self.view viewWithTag:kSettingViewTag];
    UIView *controlBgView = [self.view viewWithTag:kControlBgViewTag];
    UIView *controlView = [controlBgView viewWithTag:kControlViewTag];
    
    leftSettingView.x = -leftSettingView.width + leftSettingView.width * degree;
    drawView.x = leftSettingView.width * degree;
    controlBgView.x = drawView.x;
    controlView.alpha = 0.9 * degree;
}

- (void)tapGestureAction:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:gesture.view];
    
    if (location.x < 100 && location.y < 100) {
        [self addLeftSettingView];
        [UIView animateWithDuration:0.2 animations:^{
            [self changeLeftSettingViewWithDegree:1];
        }];
    }
}

- (void)showProductInfo {
    UIView *infoBgView = [[UIView alloc] initWithFrame:self.view.bounds];
    UIControl *control = [[UIControl alloc] initWithFrame:infoBgView.bounds];
    control.backgroundColor = [UIColor colorWithHexString:@"#03091f"];
    control.alpha = 0.7;
    [control addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchDown];
    [infoBgView addSubview:control];
    [self.view addSubview:infoBgView];
    
    CGFloat infoWidth = 400;
    CGFloat infoHeight = 200;
    MYDrawContentView *infoDrawView = [[MYDrawContentView alloc] initWithFrame:CGRectMake((infoBgView.bounds.size.width - infoWidth) / 2, (infoBgView.bounds.size.height - infoHeight) / 2, infoWidth, infoHeight)];
    infoDrawView.autoresizingMask = UIViewAutoresizingNone;
    infoDrawView.backgroundColor = kDefaultTextColor;
    infoDrawView.drawDelegate = self;
    infoDrawView.tag = kInfoDrawViewTag;
    [infoBgView addSubview:infoDrawView];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.backgroundColor = [UIColor colorWithHexString:@"#7382ba"];
    closeBtn.frame = CGRectMake(0, infoDrawView.bounds.size.height - 44, infoDrawView.bounds.size.width, 44);
    [closeBtn setTitle:@"关    闭" forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [closeBtn setTitleColor:kDefaultTextColor forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [infoDrawView addSubview:closeBtn];
}

- (void)closeAction:(UIControl *)sender {
    if ([sender isKindOfClass:[UIButton class]]) {
        [sender.superview.superview removeFromSuperview];
    }
    else {
        [sender.superview removeFromSuperview];
    }
}

- (void)dismissSettingView:(UIButton *)sender {
    [UIView animateWithDuration:0.2 animations:^{
        [self changeLeftSettingViewWithDegree:0];
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeLeftSettingView];
        }
    }];
}

- (UIButton *)switchButtonWithTitle:(NSString *)title
                             origin:(CGPoint)origin
                         isSelected:(BOOL)isSelected {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(origin.x, origin.y, 80, 40);
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}

- (void)switchItemWithIndex:(int)index {
    for (UIView *view in [scrollView subviews]) {
        [view removeFromSuperview];
    }
    
    int paddingTop = 20;
    int paddingLeft = 24;
    int btnWidth = 305;
   // int btnHeight = 273;
    int intervalX = (kScreenHeight - 3 * btnWidth - 2 * paddingLeft) / 2;
    int intervalY = 20;
    CGFloat offsetLeft = paddingLeft;
    CGFloat offsetTop = paddingTop;
    
    if (index == 0) {
        
        [OSSMemberCache shareCache].selectedSegment = 0;
        NSArray *titleNames = [OSSMemberCache shareCache].titleList;
        NSArray *imageNames = [OSSMemberCache shareCache].imageNameList;
        
        int btnHeight = 229;
        int titleLableHeight = 60;
        
        for (int i = 0; i < [titleNames count]; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(offsetLeft, offsetTop, btnWidth, btnHeight);
            button.tag = i;
            [button addTarget:self action:@selector(gotoMemberViewController:) forControlEvents:UIControlEventTouchUpInside];
            [button setBackgroundImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor redColor];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(button.x, button.y + button.height, button.width, titleLableHeight)];
            label.backgroundColor = [[UIColor colorWithHexString:@"#111C46"] colorWithAlphaComponent:0.2];
            label.textColor = kDefaultTextColor;
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:18];
            label.text = titleNames[i];
            
            [scrollView addSubview:label];
            
            offsetLeft += btnWidth + intervalX;
            
            if (i == [titleNames count] - 1 || offsetLeft > scrollView.width) {
                offsetLeft = paddingLeft;
                offsetTop += btnHeight + intervalY + titleLableHeight;
            }
            
            [scrollView addSubview:button];
        }
    }
    else if (index == 1) {
        [OSSMemberCache shareCache].selectedSegment = 1;
        NSArray *titleNames = [OSSMemberCache shareCache].titleList;
        NSArray *keyList = [OSSMemberCache shareCache].selectedKeyList;
        NSDictionary *monitorDicKey = @{@"1-1":kLoginKey, @"1-2":kChannelKey, @"1-3":kTrafficKey, @"1-4":kOrderKey, @"1-5":kUnSubScribeKey};
        
        offsetLeft = 53;
        NSInteger sumCell = [titleNames count];
        for (int i = 0; i < sumCell; i++) {
            MonitorMenuCell *cell = [[MonitorMenuCell alloc] initWithFrame:CGRectMake(offsetLeft, offsetTop, 0, 0)];
            [cell addTarget:self action:@selector(gotoMemberViewController:) forControlEvents:UIControlEventTouchUpInside];
            offsetLeft += cell.width;
            cell.title = titleNames[i];
            cell.tag = i;
            [scrollView addSubview:cell];
            
            NSDictionary *monitorInfo = tysxMonitorCtr.monitorInfo[monitorDicKey[keyList[i]]];
            cell.dateStr = tysxMonitorCtr.monitorInfo[kDateKey];
            if ([monitorInfo[kStatusKey] isEqualToString:@"normal"]) {
                cell.status = 0;
            }
            else {
                cell.status = 1;
            }
            
            if ([keyList[i] isEqualToString:@"1-2"]) {
                cell.showType = 0;
                cell.sumValue = [monitorInfo[kLoginTimesKey] longLongValue];
            }
            else {
                cell.showType = 1;
                cell.tongbiQuestionNum = [monitorInfo[kTongbiNumKey] intValue];
                cell.hunbiQuestionNum = [monitorInfo[kHuanbiNumKey] intValue];
            }
            
            if (i == sumCell - 1 || offsetLeft + cell.width > scrollView.width) {
                offsetLeft = 53;
                offsetTop += cell.height;
            }
        }
    }
    else if(index == 2) {
        CGFloat offsetY = 100;
        NSArray *titles = @[@"饼图控件",@"CRM监控",@"渠道经营日报"];
        for (int i = 0; i < [classList count]; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake((self.view.width - 200) / 2, offsetY, 200, 50);
            btn.tag = i;
            btn.layer.cornerRadius = 5;
            [btn setTitle:titles[i] forState:UIControlStateNormal];
            //[btn setTitle:titleList[i] forState:UIControlStateNormal];
            [scrollView addSubview:btn];
            [btn addTarget:self action:@selector(testAction:) forControlEvents:UIControlEventTouchUpInside];
            btn.backgroundColor = [UIColor orangeColor];
            offsetY += 90;
        }

    }
    else if (index == 3) {
//        if ([OSSMemberCache shareCache].organizationType == OrganizationType_IPTV) {
//            viewControllerClasses = @[[IPTVActiveUsersViewController class], [IPTVHDUsersViewController class], [IPTVPowerUsersViewController class], [IPTVTempViewController class]];
//            viewControllerTitles = @[@"活跃用户（阿网平台统计）", @"高清用户（阿网平台统计）", @"高清IPTV用户统计(电信CRM系统共计)", @"活跃用户(阿网统计平台)"];
//        }
        
        NSArray *viewControllerClasses = @[[IPTVActiveUsersViewController class], [IPTVHDUsersViewController class]];
        NSArray * viewControllerTitles = @[@"活跃用户（阿网平台统计）", @"高清用户（阿网平台统计）", @"高清IPTV用户统计(电信CRM系统共计)", @"活跃用户(阿网统计平台)"];
        
        NSArray * plotImageNames = @[@"first.png",@"second.png", @"bing.jpg", @"bing.jpg"];
        CGFloat btnWidth = 300;
        CGFloat btnHeight = 250;
        //  else {
        for (int i = 0; i < [viewControllerClasses count]; i++) {
            HXMenuCellView *menuCell = [[HXMenuCellView alloc] initWithFrame:CGRectMake(offsetLeft, offsetTop, btnWidth, btnHeight)];
            menuCell.title = viewControllerTitles[i];
            NSString *imagePath = [KCachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", NSStringFromClass(viewControllerClasses[i])]];
            UIImage *bgImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:imagePath]];
            bgImage = [UIImage imageNamed:plotImageNames[i]];
            if (bgImage == nil) {
                bgImage = [UIImage imageNamed:plotImageNames[i]];
            }
            
            [menuCell.button setBackgroundImage:bgImage forState:UIControlStateNormal];
            [menuCell.button addTarget:self action:@selector(menuCellAction:) forControlEvents:UIControlEventTouchUpInside];
            menuCell.button.tag = i;
            menuCell.contentDate = @"2014年08月24日";
            menuCell.updateDate = @"2014年08月05日";
            menuCell.updateTime = @"下午14:12";
            [scrollView addSubview:menuCell];
            
            offsetLeft += btnWidth + intervalX;
            
            if (offsetLeft + btnWidth> kScreenHeight || i == [viewControllerClasses count] - 1) {
                offsetLeft = paddingLeft;
                offsetTop += intervalY + btnHeight;
            }
        }
        //}
        
        paddingTop += 310;
    }
    
    scrollView.contentSize = CGSizeMake(kScreenWidth, offsetTop);
}

- (void)testAction:(UIButton *)sender {
    UIViewController *ctr = [[NSClassFromString(classList[sender.tag]) alloc] initWithPlotName:@"测试"];
    [self.navigationController pushViewController:ctr animated:YES];
}

- (void)menuCellAction:(UIButton *)sender {
    IPTVBaseViewController *ctr;
    NSArray *viewControllerClasses = @[[HXChartMainViewController class], [HXMapButtonViewController class], [IPTVPowerUsersViewController class], [IPTVTempViewController class]];
    NSArray * viewControllerTitles = @[@"活跃用户（阿网平台统计）", @"高清用户（阿网平台统计）", @"高清IPTV用户统计(电信CRM系统共计)", @"活跃用户(阿网统计平台)"];
    ctr = [[viewControllerClasses[sender.tag] alloc] initWithPlotName:viewControllerTitles
           [sender.tag]];
    [self.navigationController pushViewController:ctr animated:NO];
}

- (void)gotoMemberViewController:(UIButton *)sender {
    
    NSArray *titleNames = [OSSMemberCache shareCache].titleList;
    NSArray *classNames = [OSSMemberCache shareCache].classNameList;
    
    UIViewController *ctr = nil;
    ctr = [[NSClassFromString(classNames[sender.tag]) alloc] initWithPlotName:titleNames
           [sender.tag]];
    [self.navigationController pushViewController:ctr animated:NO];
}

- (void)gotoTempViewController:(UIButton *)sender {
    NSString *filePath = nil;
    if (sender.tag == 0) {
        filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"关键指标日报.xlsx"];
    }
    else if (sender.tag == 1) {
        filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"2014年海外游戏视频直播平台案例研究报告.pdf"];
    }
    else {
        [self newDataAction];
        return;
    }
    TYSXTempShowViewController *ctr = [[TYSXTempShowViewController alloc] initWithFilePath:filePath];
    [self.navigationController pushViewController:ctr animated:NO];
}

- (void)logoutAction {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认退出登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [[OSSMemberCache shareCache] deleteMember];
        segment.currentIndex = 0;
        [self dismissSettingView:nil];
        HXLoginViewController *ctr = [[HXLoginViewController alloc] init];
        [self presentViewController:ctr animated:YES completion:NULL];
    }
}

- (void)newDataAction {
    PageViewController *ctr = [[PageViewController alloc] init];
    
    NSMutableArray *viewControllers = [NSMutableArray array];
    for (int i = 0; i < 17; i++) {
        PageCellViewController *cellCtr = [[PageCellViewController alloc] init];
        cellCtr.bgImageName = [NSString stringWithFormat:@"ppt%02d.jpg", i + 1];
        [viewControllers addObject:cellCtr];
        cellCtr.pageViewController = ctr;
//        if (i==1) {
//            cellCtr.isCataloguePage = YES;
//        }
//        
//        else if (i == 2) {
//            cellCtr.controlframes = @[[NSValue valueWithCGRect:CGRectMake(500, 390, 420, 210)]];
//            cellCtr.controlImagesNames = @[@"show2_1.jpg"];
//        }
//        else if  (i == 3) {
//            cellCtr.controlframes = @[[NSValue valueWithCGRect:CGRectMake(0, 220, 650, 350)], [NSValue valueWithCGRect:CGRectMake(655, 220, 400, 350)]];
//            cellCtr.controlImagesNames = @[@"show3_1.jpg", @"show3_2.jpg"];
//        }
    }
    ctr.viewControllers = viewControllers;
    [self.navigationController pushViewController:ctr animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)contentView:(MYDrawContentView*)view drawRect:(CGRect)rect {
    if (view.tag == kInfoDrawViewTag) {
        CGFloat offsetTop = 12;
        UIImage *infoLogoImg = [UIImage imageNamed:@"info_logo.png"];
        [infoLogoImg drawAtPoint:CGPointMake((rect.size.width - infoLogoImg.size.width) / 2, offsetTop)];
        
        offsetTop += infoLogoImg.size.height + 11;
        
        NSString *drawString = nil;
        UIFont *textFont = nil;
        UIColor *textColor = [UIColor colorWithHexString:@"#333333"];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        
        NSMutableDictionary *attri = [NSMutableDictionary dictionary];
        [attri setValue:textColor forKey:NSForegroundColorAttributeName];
        [attri setValue:paragraphStyle forKey:NSParagraphStyleAttributeName];
        
        drawString = @"上海皇家网络科技有限公司";
        textFont = [UIFont systemFontOfSize:18];
        [attri setValue:textFont forKey:NSFontAttributeName];
        [drawString drawInRect:CGRectMake(0, offsetTop, rect.size.width, textFont.pointSize + 2) withAttributes:attri];
        
        offsetTop += textFont.pointSize + 6;
        drawString = @"http://www.m2m.cn";
        textFont = [UIFont systemFontOfSize:12];
        [attri setValue:textFont forKey:NSFontAttributeName];
        [drawString drawInRect:CGRectMake(0, offsetTop, rect.size.width, textFont.pointSize + 2) withAttributes:attri];
        
        offsetTop += textFont.pointSize + 24;
        textFont = [UIFont systemFontOfSize:18];
        [attri setValue:textFont forKey:NSFontAttributeName];
        drawString = @"版本号：Monitor Oss 演示版";
        [drawString drawInRect:CGRectMake(0, offsetTop, rect.size.width, textFont.pointSize + 2) withAttributes:attri];
    }
    else {
        int offsetTop = 50;
        int offsetLeft = 17;
        [[UIImage imageNamed:@"left.png"] drawAtPoint:CGPointMake(offsetLeft, offsetTop)];
        offsetTop += 15;
        offsetLeft += 80;
    }
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeRight;
}

@end

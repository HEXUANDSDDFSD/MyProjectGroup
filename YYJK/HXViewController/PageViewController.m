//
//  PageViewController.m
//  PageViewControllerTest
//
//  Created by zwc on 14-5-30.
//  Copyright (c) 2014年 7tea. All rights reserved.
//

#import "PageViewController.h"
#import "HXMainMenuViewController.h"

#define kTopViewTag 1002

@interface HXTopView : UIView

@end

@implementation HXTopView

- (void)drawRect:(CGRect)rect {
    int offsetTop = 10;
    int offsetLeft = 29;
    [[UIImage imageNamed:@"logo_lit.png"] drawAtPoint:CGPointMake(offsetLeft, offsetTop)];
    
    [[UIColor grayColor] set];
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    [attr setValue:[UIColor grayColor] forKey:NSForegroundColorAttributeName];
    [attr setValue:[UIFont systemFontOfSize:18] forKey:NSFontAttributeName];
    [@"运营管理系统产品介绍" drawAtPoint:CGPointMake(87, 18) withAttributes:attr];
    
    offsetTop += 34;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, 0, offsetTop);
    CGContextAddLineToPoint(context, rect.size.width, offsetTop);
    CGContextSetLineWidth(context, 0.7);
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextStrokePath(context);
}

@end

@interface PageViewController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@end

@implementation PageViewController {
    UIPageViewController *pageViewController;
    BOOL isNeedShow;
}

@synthesize viewControllers;

- (id)init {
    if (self = [super init]) {
       // isNeedShow = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDictionary *options = @{UIPageViewControllerOptionSpineLocationKey : [NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin] };
    
    pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    pageViewController.dataSource = self;
    pageViewController.delegate = self;
    
    [pageViewController setViewControllers:@[[viewControllers objectAtIndex:0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
    
    [self addChildViewController:pageViewController];
    [self.view addSubview:pageViewController.view];
    
    HXTopView *topView = [[HXTopView alloc] initWithFrame:CGRectMake(0, 0, kScreenHeight, 50)];
    topView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popViewController:)];
    [topView addGestureRecognizer:tap];
    [self.view addSubview:topView];
    
//    UITapGestureRecognizer* doubleTapRecognizer;
//    doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapFrom)];
//    doubleTapRecognizer.numberOfTapsRequired = 2; // 双击
//    [self.view addGestureRecognizer:doubleTapRecognizer];
}

//- (void)handleDoubleTapFrom{
//    CGFloat topViewHeight = 50;
//    
//    if (isNeedShow) {
//        HXTopView *topView = [[HXTopView alloc] initWithFrame:CGRectMake(0, -topViewHeight, kScreenHeight, topViewHeight)];
//        topView.tag = kTopViewTag;
//        topView.backgroundColor = [UIColor whiteColor];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popViewController:)];
//        [topView addGestureRecognizer:tap];
//        
//        [self.view addSubview:topView];
//        [UIView animateWithDuration:0.2 animations:^{
//            topView.frame = CGRectMake(0, 0, kScreenHeight, topViewHeight);
//        }];
//    }
//    else {
//        UIView *view = [self.view viewWithTag:kTopViewTag];
//        [UIView animateWithDuration:0.2 animations:^{
//            view.frame = CGRectMake(0, -topViewHeight, kScreenHeight, topViewHeight);
//        } completion:^(BOOL completed){
//            if (completed) {
//                [view removeFromSuperview];
//            }
//        }];
//    }
//    isNeedShow = !isNeedShow;
//}

- (void)popViewController:(UITapGestureRecognizer *)gestureRecognizer {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)gotoPageWithIndex:(NSInteger)index {
    [pageViewController setViewControllers:@[[viewControllers objectAtIndex:index]]direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger pageIndex = [viewControllers indexOfObject:viewController];
    if (pageIndex >= [viewControllers count] - 1) {
        showPrompt(@"已经是最后一页", 1, YES);
        return nil;
    }
    NSLog(@"%ld", (long)++pageIndex);
    return [viewControllers objectAtIndex:pageIndex];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSInteger pageIndex = [viewControllers indexOfObject:viewController];
    if (pageIndex <= 0) {
        showPrompt(@"已经是第一页", 1, YES);
        return nil;
    }
    return [viewControllers objectAtIndex:--pageIndex];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

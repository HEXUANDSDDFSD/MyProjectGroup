//
//  PageCellViewController.m
//  tysx
//
//  Created by zwc on 14-6-10.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "PageCellViewController.h"
#import "HXMeasureView.h"

@interface PageCellViewController ()

@end

@implementation PageCellViewController {
    CGRect currentSelectedFrame;
}

@synthesize bgImageName;
@synthesize controlframes;
@synthesize pageViewController;
@synthesize isCataloguePage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.bgImageName]];
    
    CGFloat offsetTop = (kScreenWidth - kScreenHeight * imageView.image.size.height / imageView.image.size.width) / 2;
    
    imageView.frame = CGRectMake(0, offsetTop, kScreenHeight, kScreenHeight * imageView.image.size.height / imageView.image.size.width);
    [self.view addSubview:imageView];
    
    for (int i = 0; i < [controlframes count]; i++) {
        UIControl *control = [[UIControl alloc] initWithFrame:[[controlframes objectAtIndex:i] CGRectValue]];
        control.tag = i;
        control.backgroundColor = [UIColor clearColor];
        [control addTarget:self action:@selector(clickCotrolAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:control];
    }
    
    if (self.isCataloguePage) {
//        HXMeasureView *view = [[HXMeasureView alloc] initWithFrame:CGRectMake(0, 0, kScreenHeight, kScreenWidth)];
//        [self.view addSubview:view];
        
        
        CGFloat offsetLeft = 230;
        CGFloat offsetRight = 170;
        CGFloat offsetTop = 185;
        for (int i = 0; i < 5; i++) {
            UIControl *control = [[UIControl alloc] initWithFrame:CGRectMake(offsetLeft, offsetTop + i * (30 + 55), kScreenHeight - offsetLeft - offsetRight, 55)];
            control.backgroundColor = [UIColor clearColor];
            control.tag = i;
            [control addTarget:self action:@selector(gotoViewController:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:control];
        }
    }
    
    // Do any additional setup after loading the view.
}

- (void)gotoViewController:(UIControl *)sender {
    int indexs[] = {2, 3, 4, 5, 9};
    [self.pageViewController gotoPageWithIndex:indexs[sender.tag]];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return NO;
}

- (void)clickCotrolAction:(UIControl *)sender {
    currentSelectedFrame = CGRectMake(self.view.bounds.size.height - sender.frame.origin.y - sender.frame.size.height, sender.frame.origin.x, sender.bounds.size.height, sender.bounds.size.width);
    
   UIView *imageBgView = [[UIView alloc] initWithFrame:self.view.window.frame];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[self.controlImagesNames objectAtIndex:sender.tag]]];
    CGFloat imgShowWidth = imageBgView.bounds.size.height * imageView.image.size.width / imageView.image.size.height;
    imageView.frame = CGRectMake((imageBgView.bounds.size.width - imgShowWidth) / 2, 0, imgShowWidth, imageBgView.bounds.size.height);
    [imageBgView addSubview:imageView];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    imageBgView.clipsToBounds = YES;
    imageBgView.backgroundColor = [UIColor whiteColor];
    
    imageBgView.frame = currentSelectedFrame;
    
    [self.view.window addSubview:imageBgView];
    
    self.pageViewController.view.userInteractionEnabled = NO;
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeImageView:)];
    [imageBgView addGestureRecognizer:tapGes];
    
    [UIView animateWithDuration:0.5 animations:^{
        imageBgView.frame = self.view.window.frame;
        imageBgView.alpha = 1.0;
    }];
}


- (void)removeImageView:(UITapGestureRecognizer *)gestrue {
    [UIView animateWithDuration:0.5 animations:^{
        gestrue.view.frame = currentSelectedFrame;
        gestrue.view.alpha = 0.0;
    } completion:^(BOOL finished){
        if (finished) {
            self.pageViewController.view.userInteractionEnabled = YES;
            [gestrue.view removeFromSuperview];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

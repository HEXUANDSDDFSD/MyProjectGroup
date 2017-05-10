//
//  ViewController.m
//  Lianliankan
//
//  Created by hexuan on 16/8/18.
//  Copyright © 2016年 hexuan. All rights reserved.
//

#import "LLKViewController.h"

#define kColumnCount 15
#define kRowCount 10

typedef struct {
    int row;
    int column;
}Position;

@interface LLKViewController ()

@end

@implementation LLKViewController {
    UIButton *pressedBtn;
    CGFloat offsetX;
    CGFloat offsetY;
    CGFloat cellWidth;
    CAShapeLayer *layer;
    UIImageView *selectedAnimationView;
    int position[kRowCount + 2][kColumnCount + 2];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    layer = [CAShapeLayer layer];
    layer.frame = self.view.bounds;
    [self.view.layer addSublayer:layer];
    
    layer.strokeColor = [UIColor blackColor].CGColor;
    layer.strokeEnd = 0.0;
    layer.fillColor = [UIColor clearColor].CGColor;
    
    offsetX = 40;
    offsetY = 80;
    
    cellWidth = (self.view.bounds.size.width - 2 * offsetX) / kColumnCount;
    for (int i = 0; i < kRowCount; i++) {
        for (int j = 0; j < kColumnCount; j++) {
            position[i + 1][j + 1] = 1;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(offsetX + j * cellWidth, offsetY + i * cellWidth, cellWidth, cellWidth);
            NSInteger tag = arc4random() % 10;
            [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"y%ld.png", (long)tag]]
                              forState:UIControlStateNormal];
//            button.layer.borderWidth = 1;
//            button.layer.borderColor = [UIColor grayColor].CGColor;
            button.tag = tag;
            [button addTarget:self action:@selector(cellAction:) forControlEvents:UIControlEventTouchDown];
            [self.view addSubview:button];
        }
    }
    
    selectedAnimationView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    selectedAnimationView.animationImages = @[[UIImage imageNamed:@"p0.png"],
                                              [UIImage imageNamed:@"p1.png"],
                                              [UIImage imageNamed:@"p2.png"],
                                              [UIImage imageNamed:@"p3.png"],
                                              [UIImage imageNamed:@"p4.png"]];
    [self.view addSubview:selectedAnimationView];
    [selectedAnimationView startAnimating];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)addAnimation {
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 0.5;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnimation.autoreverses = NO;
    [layer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
}

- (BOOL)hasObstacleWithPosOne:(Position)one another:(Position)another {
    if (one.row == another.row && one.column == another.column) {
        return NO;
    }
    if (one.row == another.row || one.column == another.column) {
        if (one.row == another.row) {
            if (one.column < another.column) {
                for (int i = one.column + 1; i < another.column; i++) {
                    if (position[one.row][i] == 1) {
                        return YES;
                    }
                }
            }
            else {
                for (int i = another.column + 1; i < one.column; i++) {
                    if (position[one.row][i] == 1) {
                        return YES;
                    }
                }

            }
        }
        else {
            if (one.row < another.row) {
                for (int i = one.row + 1; i < another.row; i++) {
                    if (position[i][one.column] == 1) {
                        return YES;
                    }
                }
            }
            else {
                for (int i = another.row + 1; i < one.row; i++) {
                    if (position[i][one.column] == 1) {
                        return YES;
                    }
                }
                
            }

        }
    }
    return NO;
}

- (CGPoint)centerWithPosition:(Position)positiion {
   return CGPointMake(offsetX  - cellWidth / 2 + positiion.column * cellWidth, offsetY - cellWidth / 2  + positiion.row * cellWidth);
}

- (void)cellAction:(UIButton *)sender {
    
    if ([sender isEqual:pressedBtn]) {
        return;
    }
    
    [selectedAnimationView removeFromSuperview];
    selectedAnimationView.frame = sender.bounds;
    [sender addSubview:selectedAnimationView];
    if (pressedBtn != nil && pressedBtn.tag == sender.tag) {
        int column = (sender.center.x - offsetX) / cellWidth + 1;
        int row = (sender.center.y - offsetY) / cellWidth + 1;
        int pColumn = (pressedBtn.center.x - offsetX) / cellWidth + 1;
        int pRow = (pressedBtn.center.y - offsetY) / cellWidth + 1;
        
        Position another = {row,column};
        Position one = {pRow,pColumn};
        
        Position inflexionOne = {0,0};
        Position inflexionAnother = {0,0};
        
        
        inflexionOne.column = one.column;
        inflexionAnother.column = another.column;
        for (int i = 0; i < kRowCount + 2; i++) {
            inflexionOne.row = inflexionAnother.row = i;
            if ((position[inflexionOne.row][inflexionOne.column] == 0 || inflexionOne.row == one.row) &&
                (position[inflexionAnother.row][inflexionAnother.column] == 0 || inflexionAnother.row == another.row) &&
                ![self hasObstacleWithPosOne:inflexionOne another:inflexionAnother] &&
                ![self hasObstacleWithPosOne:one another:inflexionOne] &&
                ![self hasObstacleWithPosOne:another another:inflexionAnother]) {
                
                UIBezierPath *path = [UIBezierPath bezierPath];
                [path moveToPoint:[self centerWithPosition:one]];
                [path addLineToPoint:[self centerWithPosition:inflexionOne]];
                [path addLineToPoint:[self centerWithPosition:inflexionAnother]];
                [path addLineToPoint:[self centerWithPosition:another]];
                layer.path = path.CGPath;
                [self addAnimation];
                
                double delayInSeconds = 0.5;
                
                [self disappearAnimationWithBtn:pressedBtn];
                [self disappearAnimationWithBtn:sender];
                
                //创建一个调度时间,相对于默认时钟或修改现有的调度时间。
                dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                //推迟两纳秒执行
                dispatch_queue_t concurrentQueue = dispatch_get_main_queue();
                dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
                    [pressedBtn removeFromSuperview];
                    [sender removeFromSuperview];
                    position[row][column] = 0;
                    position[pRow][pColumn] = 0;
                    pressedBtn = nil;
                });
                return;
            }
        }
        
        
        inflexionOne.row = one.row;
        inflexionAnother.row = another.row;
        for (int i = 0; i < kColumnCount + 2; i++) {
            inflexionOne.column = inflexionAnother.column = i;
            if ((position[inflexionOne.row][inflexionOne.column] == 0 || inflexionOne.column == one.column) &&
                (position[inflexionAnother.row][inflexionAnother.column] == 0 || inflexionAnother.column == another.column) &&
                ![self hasObstacleWithPosOne:inflexionOne another:inflexionAnother] &&
                ![self hasObstacleWithPosOne:one another:inflexionOne] &&
                ![self hasObstacleWithPosOne:another another:inflexionAnother]) {
                
                UIBezierPath *path = [UIBezierPath bezierPath];
                [path moveToPoint:[self centerWithPosition:one]];
                [path addLineToPoint:[self centerWithPosition:inflexionOne]];
                [path addLineToPoint:[self centerWithPosition:inflexionAnother]];
                [path addLineToPoint:[self centerWithPosition:another]];
                layer.path = path.CGPath;
                [self addAnimation];

                
                double delayInSeconds = 0.5;
                //创建一个调度时间,相对于默认时钟或修改现有的调度时间。
                dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                
                
                //disappearAnimationView.animationDuration = 0.5;
                
                [self disappearAnimationWithBtn:pressedBtn];
                [self disappearAnimationWithBtn:sender];
                
                //推迟两纳秒执行
                dispatch_queue_t concurrentQueue = dispatch_get_main_queue();
                dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
                    [pressedBtn removeFromSuperview];
                    [sender removeFromSuperview];
                    position[row][column] = 0;
                    position[pRow][pColumn] = 0;
                    pressedBtn = nil;
                });
                
                return;
            }
        }
        
        
    }
    
    pressedBtn = sender;
}

- (void)disappearAnimationWithBtn:(UIButton *)btn {
    [selectedAnimationView removeFromSuperview];
    UIImageView *disappearAnimationView = [[UIImageView alloc] initWithFrame:CGRectZero];
    disappearAnimationView.animationImages = @[[UIImage imageNamed:@"tx1.png"],
                                               [UIImage imageNamed:@"tx2.png"],
                                               [UIImage imageNamed:@"tx3.png"]];
    disappearAnimationView.frame = btn.bounds;
    disappearAnimationView.animationDuration = 0.5;
    [btn addSubview:disappearAnimationView];
    [disappearAnimationView startAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

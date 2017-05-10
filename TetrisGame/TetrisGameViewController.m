//
//  ViewController.m
//  TetrisGame
//
//  Created by hexuan on 2017/4/12.
//  Copyright © 2017年 hexuan. All rights reserved.
//

#import "TetrisGameViewController.h"

const int rowNum = 21;
const int columnNum = 18;
const int cellWidth = 30;

typedef struct {
    int x;
    int y;
} Position;

@interface TetrisGameViewController ()

@end

@implementation TetrisGameViewController {
    int position[rowNum][columnNum];
    Position model[4];
    UIImageView * imageView[4];
    CADisplayLink *displayLink;
    UIView *contentBgView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *wallBgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wall.jpg"]];
    wallBgView.frame = CGRectMake(0, 0, 600, 768);
    [self.view addSubview:wallBgView];
    
    contentBgView = [[UIView alloc] initWithFrame:CGRectMake(30, 30, 540, 630)];
    contentBgView.clipsToBounds = YES;
    contentBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentBgView];
    
    
    [self initModel];
    
    UIButton *left = [self controlButton];
    left.frame = CGRectMake(730, 600, 80, 80);
    left.tag = 0;
    [self.view addSubview:left];
    
    UIButton *right = [self controlButton];
    right.frame = CGRectMake(900, 600, 80, 80);
    right.tag = 1;
    [self.view addSubview:right];
    
    UIButton *up = [self controlButton];
    up.frame = CGRectMake(810, 500, 80, 80);
    up.tag = 2;
    [self.view addSubview:up];
    
    UIButton *down = [self controlButton];
    down.frame = CGRectMake(810, 600, 80, 80);
    down.tag = 3;
    [self.view addSubview:down];
    
    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(down)];
    displayLink.preferredFramesPerSecond = 1;
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (UIButton*)controlButton{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
    button.backgroundColor = [UIColor orangeColor];
    button.layer.cornerRadius = 40;
    [button addTarget:self action:@selector(controlAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)controlAction:(UIButton *)button {
    switch (button.tag) {
        case 0:
            [self left];
            break;
        case 1:
            [self right];
            break;
        case 2:
            [self up];
            break;
        case 3:
            [self downAction];
            break;
        default:
            break;
    }
}

- (void)initModel{
    
    int modelType = arc4random() % 7;
    switch (modelType) {
        case 0:
            model[0].x = columnNum / 2 - 1;
            model[0].y = 0;
            model[1].x = model[0].x;
            model[1].y = model[0].y + 1;
            model[2].x = model[0].x + 1;
            model[2].y = model[0].y + 1;
            model[3].x = model[0].x + 2;
            model[3].y = model[0].y + 1;
            break;
        case 1:
            model[0].x = columnNum / 2 - 2;
            model[0].y = 0;
            model[1].x = model[0].x + 1;
            model[1].y = model[0].y;
            model[2].x = model[0].x + 2;
            model[2].y = model[0].y;
            model[3].x = model[0].x + 3;
            model[3].y = model[0].y;
            break;
        case 2:
            model[0].x = columnNum / 2 - 2;
            model[0].y = 0;
            model[1].x = model[0].x + 1;
            model[1].y = model[0].y;
            model[2].x = model[0].x;
            model[2].y = model[0].y + 1;
            model[3].x = model[0].x + 1;
            model[3].y = model[0].y + 1;
            break;
        case 3:
            model[0].x = columnNum / 2 - 2;
            model[0].y = 0;
            model[1].x = model[0].x;
            model[1].y = model[0].y + 1;
            model[2].x = model[0].x + 1;
            model[2].y = model[0].y + 1;
            model[3].x = model[0].x + 1;
            model[3].y = model[0].y + 2;
            break;

        case 4:
            model[0].x = columnNum / 2 - 2;
            model[0].y = 0;
            model[1].x = model[0].x;
            model[1].y = model[0].y + 1;
            model[2].x = model[0].x - 1;
            model[2].y = model[0].y + 1;
            model[3].x = model[0].x + 1;
            model[3].y = model[0].y + 1;
            break;
        case 5:
            model[0].x = columnNum / 2 - 2;
            model[0].y = 0;
            model[1].x = model[0].x;
            model[1].y = model[0].y + 1;
            model[2].x = model[0].x - 1;
            model[2].y = model[0].y + 1;
            model[3].x = model[0].x - 2;
            model[3].y = model[0].y + 1;
            break;
        case 6:
            model[0].x = columnNum / 2 - 2;
            model[0].y = 0;
            model[1].x = model[0].x;
            model[1].y = model[0].y + 1;
            model[2].x = model[0].x - 1;
            model[2].y = model[0].y + 1;
            model[3].x = model[0].x - 1;
            model[3].y = model[0].y + 2;
            break;
        case 7:
            model[0].x = columnNum / 2 - 2;
            model[0].y = 0;
            model[1].x = model[0].x;
            model[1].y = model[0].y + 1;
            model[2].x = model[0].x + 1;
            model[2].y = model[0].y + 1;
            model[3].x = model[0].x + 1;
            model[3].y = model[0].y + 2;
            break;
        default:
            break;
    }

    for (int i = 0;i < 4;i++){
        imageView[i] = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell.png"]];
        imageView[i].frame = CGRectMake(model[i].x * cellWidth, model[i].y * cellWidth, cellWidth, cellWidth);
        [contentBgView addSubview:imageView[i]];
    }
}

- (void)updateImageView {
    for (int i = 0;i < 4;i++){
        imageView[i].frame = CGRectMake(model[i].x * cellWidth, model[i].y * cellWidth, cellWidth, cellWidth);
    }
}

- (void)downAction {
    
    while ([self canDown]) {
        [self down];
    }
}

- (void)up{
    for(int i=0;i<4;i++){
        if (i != 1) {
            CGFloat originalX = model[i].x;
            int tempX = model[1].x + model[1].y - model[i].y;
            int tempY = model[1].y + originalX - model[1].x;
            if (tempX < 0 || tempX >= columnNum || position[tempY][tempX] == 1) {
                return;
            }
        }

    }
    for(int i=0;i<4;i++){
        if (i != 1) {
            CGFloat originalX = model[i].x;
            model[i].x = model[1].x + model[1].y - model[i].y;
            model[i].y = model[1].y + originalX - model[1].x;
        }
    }
    [self updateImageView];
}

- (void)left {
    for (int i = 0;i < 4;i++){
        if (model[i].x == 0 || position[model[i].y][model[i].x - 1] == 1) {
            return;
        }
    }
    for (int i = 0;i < 4;i++){
        model[i].x -= 1;
        imageView[i].frame = CGRectMake(model[i].x * cellWidth, model[i].y * cellWidth, cellWidth, cellWidth);
    }
}

- (void)right {
    for (int i = 0;i < 4;i++){
        if (model[i].x == 17 || position[model[i].y][model[i].x + 1] == 1) {
            return;
        }
    }
    for (int i = 0;i < 4;i++){
        model[i].x += 1;
        imageView[i].frame = CGRectMake(model[i].x * cellWidth,  model[i].y * cellWidth, cellWidth, cellWidth);
    }
}

- (void)down {
    if (![self canDown]) {
        [self fillPostion];
        [self deleteProcess];
        [self initModel];
        return;
    }
    for (int i = 0;i < 4;i++){
        model[i].y += 1;
        imageView[i].frame = CGRectMake(model[i].x * cellWidth, model[i].y * cellWidth, cellWidth, cellWidth);
    }
}

- (void)deleteProcess {
    int downNum = 0;
    for (int i=rowNum-1; i >= 0; i--) {
        if ([self isFullRow:i]) {
            for(UIView *view in [contentBgView subviews]) {
                if (view.center.y > i * 30 && view.center.y < (i + 1) * 30) {
                    [view removeFromSuperview];
                }
            }
            downNum++;
        }
        else if (downNum!=0){
            for(int j =0;j< columnNum;j++){
                position[i + downNum][j] = position[i][j];
            }
            for(UIView *view in [contentBgView subviews]) {
                if (view.center.y > i * 30 && view.center.y < (i + 1) * 30) {
                    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y + cellWidth * downNum, cellWidth, cellWidth);
                }
            }
        }
    }

}

- (BOOL)isFullRow:(int)row {
    BOOL result = YES;
    for(int i = columnNum - 1;i >= 0;i--){
        if (position[row][i] == 0) {
            result = NO;
            break;
        }
    }
    return result;
}

- (BOOL)canDown {
    BOOL result = YES;
    for (int i = 0; i < 4; i++) {
        if (model[i].y >= rowNum - 1 || position[model[i].y + 1][model[i].x] == 1) {
            result = NO;
            break;
        }
    }
    return result;
}

- (void)fillPostion {
    for (int i = 0; i < 4; i++) {
        position[model[i].y][model[i].x] = 1;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

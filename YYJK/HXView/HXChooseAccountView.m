//
//  HXChooseAccountView.m
//  tysx
//
//  Created by zwc on 13-11-4.
//  Copyright (c) 2013年 huangjia. All rights reserved.
//

#import "HXChooseAccountView.h"

@implementation HXChooseAccountView
@synthesize delegate;

- (id)initWithAccountArr:(NSArray *)accounts EveryCellSize:(CGSize)cellSize {
    if ([accounts count] == 0) {
        return nil;
    }
    
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, cellSize.width, cellSize.height * [accounts count]);
        self.backgroundColor = [UIColor grayColor];
        for (int i = 0; i < [accounts count]; i++) {
            UIButton *accountBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, cellSize.height * i, cellSize.width, cellSize.height)];
            [accountBtn setTitle:[accounts objectAtIndex:i] forState:UIControlStateNormal];
            [accountBtn addTarget:self action:@selector(chooseAccountAction:) forControlEvents:UIControlEventTouchUpInside];
            [accountBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            accountBtn.titleLabel.font = [UIFont systemFontOfSize:cellSize.height / 2.5];
            [self addSubview:accountBtn];
        }
    }
    
    return self;
}

- (void)chooseAccountAction:(UIButton *)sender{
    if ([delegate respondsToSelector:@selector(chooseAccountView:didChoosedAccount:)]) {
        [delegate chooseAccountView:self didChoosedAccount:[sender titleForState:UIControlStateNormal]];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

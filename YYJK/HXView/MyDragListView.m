//
//  MyDragListView.m
//  tysx
//
//  Created by zwc on 14-6-27.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "MyDragListView.h"

@implementation MyDragListView {
    UIView *dragView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    [self.titleColor set];
    
    for (int i = 0; i < [self.titles count]; i++) {
        UIFont *font = [UIFont systemFontOfSize:17];
        CGFloat fontHeight = [[self.titles objectAtIndex:i] sizeWithFont:font].height;
        [[self.titles objectAtIndex:i] drawInRect:CGRectMake(0, ([self everyHeight] - fontHeight) / 2 + i * [self everyHeight], rect.size.width, fontHeight) withFont:font lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
    }
}

- (CGFloat)everyHeight {
    return self.bounds.size.height / [self.titles count];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (dragView == nil) {
        dragView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, [self everyHeight])];
        dragView.backgroundColor = self.selectedColor;
        dragView.alpha = 0.2;
        [self addSubview:dragView];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    CGFloat y = [touch locationInView:self].y;
    CGFloat everyHeight = [self everyHeight];
    if (y < everyHeight / 2) {
        y = everyHeight / 2;
    }
    else if (y > self.bounds.size.height - everyHeight / 2) {
        y = self.bounds.size.height - everyHeight / 2;
    }
    dragView.center = CGPointMake(self.bounds.size.width / 2, y);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    CGFloat y = [touch locationInView:self].y;
    CGFloat everyHeight = [self everyHeight];
    if (y < everyHeight / 2) {
        y = everyHeight / 2;
    }
    else if (y > self.bounds.size.height - everyHeight / 2) {
        y = self.bounds.size.height - everyHeight / 2;
    }
    dragView.center = CGPointMake(self.bounds.size.width / 2, y);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    CGFloat everyHeight = [self everyHeight];
    int currentIndex = dragView.center.y / everyHeight;
    
    if (currentIndex != self.currentIndex) {
        self.currentIndex = currentIndex;
        if ([self.delegate respondsToSelector:@selector(dragListViewDidSeleted:)]) {
            [self.delegate dragListViewDidSeleted:self];
        }
    }
    
    dragView.center = CGPointMake(dragView.center.x, everyHeight * currentIndex + everyHeight / 2);
}

@end

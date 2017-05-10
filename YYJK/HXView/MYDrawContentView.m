//
//  MYDrawContentView.m
//  iddressbook
//
//  Created by 谌启亮 on 10-8-30.
//  Copyright 2010 Digisys Information. All rights reserved.
//

#import "MYDrawContentView.h"

@implementation MYDrawContentView
@synthesize drawDelegate;

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    self.contentMode = UIViewContentModeRedraw;
      self.backgroundColor = [UIColor clearColor];
    self.opaque = YES;
  }
  return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesBegan:touches withEvent:event];
  if ([(id)drawDelegate respondsToSelector:@selector(contentView:touchBeginAtPoint:)]) {
    [drawDelegate contentView:self touchBeginAtPoint:[[touches anyObject] locationInView:self]];
  }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  //    MLOG(@"touchesCancelled");
  [super touchesCancelled:touches withEvent:event];
  if ([(id)drawDelegate respondsToSelector:@selector(contentView:touchCancelAtPoint:)]) {
    [drawDelegate contentView:self touchCancelAtPoint:[[touches anyObject] locationInView:self]];
  }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  //    MLOG(@"toucheEnd");
  [super touchesEnded:touches withEvent:event];
  if ([(id)drawDelegate respondsToSelector:@selector(contentView:touchEndAtPoint:)]) {
    [drawDelegate contentView:self touchEndAtPoint:[[touches anyObject] locationInView:self]];
  }
}

- (BOOL)canBecomeFirstResponder {
  return YES;
}

- (void)setHighlighted:(BOOL)highlighted {
  _isHighlited = highlighted;
  [self setNeedsDisplay];
}

- (BOOL)isHighlighted {
  return _isHighlited;
}

- (void)drawRect:(CGRect)rect {
  [drawDelegate contentView:self drawRect:rect];
}

- (void)dealloc {
  [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

@end
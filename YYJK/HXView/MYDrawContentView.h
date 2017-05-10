//
//  MYDrawContentView.h
//  iddressbook
//
//  Created by 谌启亮 on 10-8-30.
//  Copyright 2010 Digisys Information. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MYDrawContentView;
@protocol MYDrawContentViewDrawDelegate
- (void)contentView:(MYDrawContentView*)view drawRect:(CGRect)rect;
@optional
- (void)contentView:(MYDrawContentView*)view touchEndAtPoint:(CGPoint)p;
- (void)contentView:(MYDrawContentView*)view touchBeginAtPoint:(CGPoint)p;
- (void)contentView:(MYDrawContentView*)view touchCancelAtPoint:(CGPoint)p;

@end


@interface MYDrawContentView : UIView <UIGestureRecognizerDelegate>{
    BOOL _isHighlited;
    id<MYDrawContentViewDrawDelegate>__weak drawDelegate;
}

@property(nonatomic,weak) id<MYDrawContentViewDrawDelegate> drawDelegate;

- (id)initWithFrame:(CGRect)frame;
- (BOOL)isHighlighted;

@end

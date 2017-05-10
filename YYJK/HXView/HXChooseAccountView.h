//
//  HXChooseAccountView.h
//  tysx
//
//  Created by zwc on 13-11-4.
//  Copyright (c) 2013年 huangjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXChooseAccountView;

@protocol HXChooseAccountViewDelegate <NSObject>

- (void)chooseAccountView:(HXChooseAccountView *)view didChoosedAccount:(NSString *)account;


@end

@interface HXChooseAccountView : UIView

@property (nonatomic, weak) id<HXChooseAccountViewDelegate> delegate;

- (id)initWithAccountArr:(NSArray *)accounts EveryCellSize:(CGSize)cellSize;

@end

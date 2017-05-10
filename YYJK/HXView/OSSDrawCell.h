//
//  OSSDrawCell.h
//  tysx
//
//  Created by zwc on 14/11/17.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OSSDrawCell;

@protocol OSSDrawCellDelegate <NSObject>

- (void)drawCell:(OSSDrawCell *)cell rect:(CGRect)rect;

@end

@interface OSSDrawCell : UITableViewCell

@property (nonatomic, weak) id<OSSDrawCellDelegate> drawDelegate;

@end

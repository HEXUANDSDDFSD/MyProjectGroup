//
//  HXBottomInfoButton.m
//  tysx
//
//  Created by zwc on 13-12-30.
//  Copyright (c) 2013年 huangjia. All rights reserved.
//

#import "HXBottomInfoButton.h"
#import "UIColor+category.h"

@implementation HXBottomInfoButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColorWithGrayDegree:211/255.0];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [[UIColor blackColor] set];
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    [attr setValue:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
    [attr setValue:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName];
    [self.title drawAtPoint:CGPointMake(13, 7) withAttributes:attr];
    [self.showDateStr drawAtPoint:CGPointMake(13, 28) withAttributes:attr];
    
    
    [attr setValue:[UIFont systemFontOfSize:10] forKey:NSFontAttributeName];
    [[NSString stringWithFormat:@"更新于%@", self.updateDateStr] drawAtPoint:CGPointMake(190, 25) withAttributes:attr];
    [self.updateTimeStr drawAtPoint:CGPointMake(190, 40) withAttributes:attr];
    
}



@end

//
//  UIImage+simple.m
//  tysx
//
//  Created by zwc on 13-11-5.
//  Copyright (c) 2013年 huangjia. All rights reserved.
//

#import "UIImage+simple.h"

@implementation UIImage (simple)

- (UIImage *)stretchableInCenter {
    return [self stretchableImageWithLeftCapWidth:self.size.width / 2.0 topCapHeight:self.size.height / 2.0];
}

@end

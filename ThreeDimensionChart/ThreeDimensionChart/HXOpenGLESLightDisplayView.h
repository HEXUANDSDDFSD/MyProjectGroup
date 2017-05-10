//
//  HXOpenGLESBaseView.h
//  ThreeDimensionChart
//
//  Created by zwc on 16/3/9.
//  Copyright © 2016年 MYSTERIOUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenGLES_C_Func.h"

@protocol HXOpenGLESLightDisplayViewDelegate <NSObject>

- (void)lightUpdate;

@end

@interface HXOpenGLESLightDisplayView : UIView

@property (nonatomic, weak) id<HXOpenGLESLightDisplayViewDelegate> delegate;

@end

//
//  TYSXDetailChartDataCtr.h
//  tysx
//
//  Created by zwc on 13-12-17.
//  Copyright (c) 2013年 huangjia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYSXDetailChartDataCtr : NSObject

@property (nonatomic, assign) NSInteger selectedSection;
@property (nonatomic, assign) NSInteger selectedRow;
@property (nonatomic, readonly) NSArray *sectionTitles;
@property (nonatomic, readonly) NSString *lastDate;
@property (nonatomic, readonly) NSArray *addTen;
@property (nonatomic, readonly) NSArray *unTen;
@property (nonatomic, readonly) NSArray *tv189;
@property (nonatomic, readonly) NSArray *gupiao;
@property (nonatomic, readonly) NSDictionary *yunying;
@property (nonatomic, readonly) NSArray *yunying1;
@property (nonatomic, readonly) NSArray *productPackage1;
@property (nonatomic, readonly) NSArray *productPackage2;
@property (nonatomic, readonly) NSArray *productPackage3;
@property (nonatomic, readonly) NSArray *summaryStrings;
@property (nonatomic, readonly) NSArray *add;
@property (nonatomic, readonly) NSArray *unadd;
@property (nonatomic, readonly) NSArray *hezuoadd;
@property (nonatomic, readonly) NSArray *hezuounadd;
@property (nonatomic, readonly) NSArray *hezuoTop;
@property (nonatomic, readonly) NSArray *pingtaiTop;
@property (nonatomic, readonly) NSArray *pingtai;
@property (nonatomic, readonly) NSArray *hezuo;
@property (nonatomic, readonly) NSArray *ziranAdd;
@property (nonatomic, readonly) NSArray *ziranUnAdd;

- (NSArray *)rowTitlesWithSection:(NSInteger)section;

- (void)updateData;

@end

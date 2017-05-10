//
//  DatabaseMa.h
//  tysx
//
//  Created by zwc on 14-8-28.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface DBField : NSObject {
    
}

@property (nonatomic, copy) NSString *fieldName;
@property (nonatomic, copy) NSString *fieldType;
@property (nonatomic, assign) BOOL isPrimaryKey;

+ (DBField *)dbFieldWithName:(NSString *)name type:(NSString *)type isPri:(BOOL)isPri;

@end

@interface DatabaseManager : NSObject

typedef void (^DatabaseOperate)(FMDatabase *database);

+ (DatabaseManager *)shareDatabase;

-(void)synchronousOperate:(DatabaseOperate)operate;

- (void)createDBTableWith:(NSString *)tableName fieldList:(NSArray *)fieldList;

@end

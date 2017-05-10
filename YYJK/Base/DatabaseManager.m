//
//  DatabaseMa.m
//  tysx
//
//  Created by zwc on 14-8-28.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "DatabaseManager.h"

@implementation DBField {

}

+ (DBField *)dbFieldWithName:(NSString *)name type:(NSString *)type isPri:(BOOL)isPri {
    DBField *dbField = [[DBField alloc] init];
    dbField.fieldName = name;
    dbField.fieldType = type;
    dbField.isPrimaryKey = isPri;
    return dbField;
}

@end

static DatabaseManager *databaseManager = nil;

@implementation DatabaseManager {
    FMDatabaseQueue* queue;
}

+ (DatabaseManager *)shareDatabase {
    static DatabaseManager *databaseManager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        databaseManager = [[self alloc] init];
    });
    return databaseManager;
}

- (void)createDBTableWith:(NSString *)tableName fieldList:(NSArray *)fieldList {
    NSMutableString *sql = [NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (", tableName];
    NSMutableArray *primaryKeyList = [NSMutableArray array];
    for (int i = 0; i < [fieldList count]; i++) {
        DBField *dbField = fieldList[i];
        if (dbField.isPrimaryKey) {
            [primaryKeyList addObject:dbField.fieldName];
        }
        [sql appendFormat:@"%@ %@,", dbField.fieldName, dbField.fieldType];
    }
    NSMutableString *primaryStr = [[NSMutableString alloc] initWithString:@"PRIMARY KEY ("];
    for (int i = 0; i < [primaryKeyList count]; i++) {
        [primaryStr appendFormat:@"%@,", primaryKeyList[i]];
        if (i == [primaryKeyList count] - 1) {
            NSRange range;
            range.location = primaryStr.length - 1;
            range.length = 1;
            [primaryStr deleteCharactersInRange:range];
        }
    }
    [primaryStr appendString:@")"];
    [sql appendFormat:@"%@)", primaryStr];
    
    FMDatabase *database = [FMDatabase databaseWithPath:[self mainDataBasePath]];
    [database executeQuery:sql];
}

- (id)init {
    if (self = [super init]) {
        queue = [FMDatabaseQueue databaseQueueWithPath:[self mainDataBasePath]];
    }
    return self;
}

- (NSString *)mainDataBasePath {
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSString *documents = [paths objectAtIndex:0];
    NSString *database_path = [KCachePath stringByAppendingPathComponent:@"chart.data"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:database_path]) {
        if (![fileManager createFileAtPath:database_path contents:nil attributes:nil]) {
            NSLog(@"数据库文件创建失败！");
            return nil;
        }
    }
    
    if (database_path != nil) {
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:NSFileProtectionComplete
                                                               forKey:NSFileProtectionKey];
        [[NSFileManager defaultManager] setAttributes:attributes
                                         ofItemAtPath:database_path
                                                error:nil];
    }
    
    return database_path;
}

-(void)synchronousOperate:(DatabaseOperate)operate {
    [queue inDatabase:^(FMDatabase *db) {
        if (operate != nil) {
            operate(db);
            [db closeOpenResultSets];
        }
    }];
}

@end

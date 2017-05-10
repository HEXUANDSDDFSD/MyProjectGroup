//
//  NSString+Encryption.m
//  tysx
//
//  Created by zwc on 14-9-24.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "NSString+Encryption.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (Encryption)

- (NSString *)md5String {
    {
        const char *cStr = [self UTF8String];
        unsigned char result[32];
        CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
        return [NSString stringWithFormat:
                
                @"%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x",
                
                result[0],result[1],result[2],result[3],
                
                result[4],result[5],result[6],result[7],
                
                result[8],result[9],result[10],result[11],
                
                result[12],result[13],result[14],result[15],
                
                result[16], result[17],result[18], result[19],
                
                result[20], result[21],result[22], result[23],
                
                result[24], result[25],result[26], result[27],
                
                result[28], result[29],result[30], result[31]];
    }

}

@end

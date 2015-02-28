//
//  AES256EncryptAndDecrypt.h
//  MGLDevelopmentKit
//
//  Created by kaxiaoer on 15/1/5.
//  Copyright (c) 2015年 miaogaoliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AES256EncryptAndDecrypt : NSObject
@end

@class NSString;

@interface NSData (Encryption)

- (NSData *)KeyForAES256;
- (NSData *)AES256EncryptWithKey:(NSData *)key;   //加密
- (NSData *)AES256DecryptWithKey:(NSData *)key;   //解密
- (NSString *)newStringInBase64FromData;            //追加64编码
+ (NSString*)base64encode:(NSString*)str;           //同上64编码

@end
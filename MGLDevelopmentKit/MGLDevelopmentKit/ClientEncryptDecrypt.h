//
//  ClientEncryptDecrypt.h
//  MGLDevelopmentKit
//
//  Created by kaxiaoer on 15/2/5.
//  Copyright (c) 2015年 miaogaoliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClientEncryptDecrypt : NSObject

+ (NSString *)encrytWithProtobuffer:(NSData *)protobuf;

+ (NSDictionary *)decryptWithData:(NSString *)dataString;

@end

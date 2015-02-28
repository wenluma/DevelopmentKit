//
//  RSAESCryptor.h
//  MGLDevelopmentKit
//
//  Created by kaxiaoer on 15/1/5.
//  Copyright (c) 2015年 miaogaoliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSAESCryptor : NSObject
+ (RSAESCryptor *)sharedCryptor;

- (void)loadPublicKey:(NSString *)keyPath;
- (NSData *)encryptData:(NSData *)content;

- (void)loadPrivateKey:(NSString *)keyPath password:(NSString *)password;
- (NSData *)decryptData:(NSData *)content;
@end

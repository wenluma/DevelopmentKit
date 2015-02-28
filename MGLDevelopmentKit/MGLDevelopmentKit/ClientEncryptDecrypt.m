//
//  ClientEncryptDecrypt.m
//  MGLDevelopmentKit
//
//  Created by kaxiaoer on 15/2/5.
//  Copyright (c) 2015年 miaogaoliang. All rights reserved.
//

#import "ClientEncryptDecrypt.h"
#import "Base64.h"
#import "AES256EncryptAndDecrypt.h"
#import "RSA.h"

static NSString *mainKey = @"";

static NSString *pathOfCert = nil;

@implementation ClientEncryptDecrypt

+ (NSString *)encrytWithProtobuffer:(NSData *)protobuf{

    NSString *aesKey = [[NSUUID UUID] UUIDString];
    NSString *source = [protobuf base64EncodedString];
    source = [source stringByAppendingString:@"RAEBEAR"];
    source = [source stringByAppendingString:mainKey];
    NSData *aeskeyData = [aesKey dataUsingEncoding:NSUTF8StringEncoding];
    NSData *AESResultData = [[source dataUsingEncoding:NSUTF8StringEncoding] AES256EncryptWithKey:aeskeyData];
   
    if (!pathOfCert) {
        NSString *pubKeyPath = [[NSBundle mainBundle] pathForResource:@"ios_cer" ofType:@"der"];
        pathOfCert = pubKeyPath;
    }
    [[RSA sharedInstance] loadPublicKey:pathOfCert];
    
    NSData *rsaEncyptData = [[RSA sharedInstance] rsaEncyptWithData:aeskeyData];
    
    NSString *result = [AESResultData base64EncodedString];
    result = [result stringByAppendingString:@"RAEBEAR"];
    result = [result stringByAppendingString:[rsaEncyptData base64EncodedString]];
    
    return result;
}

+ (NSDictionary *)decryptWithData:(NSString *)dataString{
    return nil;
}
@end

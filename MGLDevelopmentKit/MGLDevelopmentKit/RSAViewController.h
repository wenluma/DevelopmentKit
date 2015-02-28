//
//  RSAViewController.h
//  MGLDevelopmentKit
//
//  Created by kaxiaoer on 15/1/9.
//  Copyright (c) 2015年 miaogaoliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Security/Security.h>

@interface RSAViewController : UIViewController
{
    SecKeyRef publicKey;
    SecKeyRef privateKey;
    NSData *publicTag;
    NSData *privateTag;
}
- (void)encryptWithPublicKey:(uint8_t *)plainBuffer cipherBuffer:(uint8_t *)cipherBuffer;
- (void)decryptWithPrivateKey:(uint8_t *)cipherBuffer plainBuffer:(uint8_t *)plainBuffer;
- (SecKeyRef)getPublicKeyRef;
- (SecKeyRef)getPrivateKeyRef;
- (void)testAsymmetricEncryptionAndDecryption;
- (void)generateKeyPair:(NSUInteger)keySize;
@end
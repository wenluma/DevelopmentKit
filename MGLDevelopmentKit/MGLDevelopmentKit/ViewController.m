//
//  ViewController.m
//  MGLDevelopmentKit
//
//  Created by kaxiaoer on 15/1/4.
//  Copyright (c) 2015年 miaogaoliang. All rights reserved.
//

#import "ViewController.h"
#import "MGLBarChartView.h"
#import "AES256/AES256EncryptAndDecrypt.h"
#import "AES256/RSAESCryptor.h"
#import "UIVIewSpringEffect.h"
#import "RSA.h"
#import <Security/Security.h>
#import "UIView+Positioning.h"
#import "Base64.h"


NSString *const identifierCell = @"Cell";

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate, MGLBarChartViewDataSource>
@property (weak, nonatomic) UITableView *table;
@property (strong, nonatomic) NSMutableArray *listMutArray;
@property (weak, nonatomic) UIVIewSpringEffect *springView;
@end

@implementation ViewController


- (void)testAES{
    NSString *uuidString = @"~i%%E1T^3tYl#yztIJZWgRNJm$qn<_5p";
//    [[NSUUID UUID] UUIDString];
    NSData *datauuid = [uuidString dataUsingEncoding:NSUTF8StringEncoding];
//    93956ae40611a8857b460466c61c7e6fa75846cf0e752b2ca319e3c2a4b444

    NSString *path = [[NSBundle mainBundle] pathForResource:@"bin" ofType:@"txt"];
    NSString *pathDoc = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"bytes"];
    NSData *enData = [[NSData alloc] initWithContentsOfFile:path];
    NSData *result = [enData AES256DecryptWithKey:datauuid];
    [result writeToFile:pathDoc atomically:YES];
    NSString *source = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    NSLog(source,nil);
    
//    NSString *str = @"夸氪4008096566";
//    NSData *strData = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    //为了测试，这里先把密钥写死
    
    //    Byte keyByte[] = {0x08,0x08,0x04,0x0b,0x02,0x0f,0x0b,0x0c,0x01,0x03,0x09,0x07,0x0c,0x03,
    //        0x07,0x0a,0x04,0x0f,0x06,0x0f,0x0e,0x09,0x05,0x01,0x0a,0x0a,0x01,0x09,
    //        0x06,0x07,0x09,0x0d};
    
    
    
    //byte转换为NSData类型，以便下边加密方法的调用
//        NSData *keyData = [[NSData alloc] initWithBytes:keyByte length:32];
    
//    NSData *cipherTextData = [strData AES256EncryptWithKey:datauuid];
//    Byte *plainTextByte = (Byte *)[cipherTextData bytes];
//    NSLog([cipherTextData description],nil);
//    for(int i=0;i<[cipherTextData length];i++){
//        printf("%x",plainTextByte[i]);
//    }
//    NSData *data = [[NSData alloc] initWithBytes:byteR length:length];
//    
//    NSData *dataResutl = [data AES256DecryptWithKey:datauuid];
//    NSString *source = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(source,nil);
}
- (Byte )ToHex:(unichar)tmpid
{
    tmpid = tmpid+'0';
    Byte nLetterValue;
    
    switch (tmpid)
    {
        case '0':
            nLetterValue = 0x0;break;
        case '1':
            nLetterValue = 0x1;break;
        case '2':
            nLetterValue = 0x2;break;
        case '3':
            nLetterValue = 0x3;break;
        case '4':
            nLetterValue = 0x4;break;
        case '5':
            nLetterValue = 0x5;break;
        case '6':
            nLetterValue = 0x6;break;
        case '7':
            nLetterValue = 0x7;break;
        case '8':
            nLetterValue = 0x8;break;
        case '9':
            nLetterValue = 0x9;break;
        case 'a':
            nLetterValue = 0xa;break;
        case 'b':
            nLetterValue = 0xb;break;
        case 'c':
            nLetterValue = 0xc;break;
        case 'd':
            nLetterValue = 0xd;break;
        case 'e':
            nLetterValue = 0xe;break;
        case 'f':
            nLetterValue = 0xf;break;
        default:
            nLetterValue = 0;
            
    }
    
    return nLetterValue;
}
- (NSData *)dataWithBytesString:(NSString *)byteString{
    byteString = [byteString lowercaseString];
    NSUInteger length = byteString.length/2;
    Byte myByte[length];
    int j=0;
    for (int i=0; i< byteString.length; i=i+2) {
        NSString *str = [byteString substringWithRange:NSMakeRange(i, 2)];
        NSScanner *scan = [NSScanner scannerWithString:str];
        uint *result;
        [scan scanHexInt:result];
        if (*result > 0) {
            if (*result > 10) {
                myByte[j] = *result;
            }else{
                myByte[j] = [self ToHex:*result];
            }

            ++j;
            printf("%s-%x\n",[str UTF8String],*result);
        }

    }
    for (int i=0; i< length; i++) {
        printf("%x",myByte[i]);
    }
    NSData *result = [[NSData alloc] initWithBytes:myByte length:length];
    NSString *d= [result description];
    return result;
}
- (void)testRSAEN{
    
    NSString *pathDoc = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"bytes"];
    
    NSString *pubKeyPath = [[NSBundle mainBundle] pathForResource:@"target" ofType:@"der"];
    NSString *helloTest = @"hello world";
    NSData *plainData = [helloTest dataUsingEncoding:NSUTF8StringEncoding];
    RSAESCryptor *cryptor = [RSAESCryptor sharedCryptor];
    [cryptor loadPublicKey:pubKeyPath];
    NSData *encData = [cryptor encryptData:plainData];//加密
    NSUInteger length = encData.length - 127;
    Byte secBytes[length];
    [encData getBytes:secBytes range:NSMakeRange(127, length)];
    [encData writeToFile:pathDoc atomically:YES];
    
}
- (void)testRSADE{
    NSString *privateKeyPath = [[NSBundle mainBundle] pathForResource:@"keystore_api" ofType:@"cer"];
    NSString *helloTest = @"2014年岁末，iTools发布了2014年11月 iOS 手游数据报告。报告显示：以轻度为主的卡牌手游仍然占有相当部分的市场份额;另一方面";
    NSData *plainData = [helloTest dataUsingEncoding:NSUTF8StringEncoding];


    
//    NSString *priKeyPath = [[NSBundle mainBundle] pathForResource:@"privateKey" ofType:@"p12"];
    
    RSAESCryptor *cryptor = [RSAESCryptor sharedCryptor];
    [cryptor loadPrivateKey:privateKeyPath password:@"123456"];
//    NSData *decData = [cryptor decryptData:encData];
}
- (void)addBarChart{
    NSMutableArray *listArray = [[NSMutableArray alloc] initWithCapacity:1];
    MGLBarChartView *barChart = [[MGLBarChartView alloc] initWithFrame:CGRectMake(20, 100, 255+40, 76+20)];
    [self.view addSubview:barChart];
    barChart.delegate = self;

    _listMutArray = listArray;
    for (int i=0; i<21; i++) {
        long num = random()*1000.0/LONG_MAX;
        [_listMutArray addObject:@(num)];
    }
}
- (void)addTable{
    self.navigationController.navigationBar.translucent = NO;
    UITableView *table = [[UITableView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:table];
    _table = table;
    _table.delegate = self;
    _table.dataSource = self;
    [_table registerClass:[UITableViewCell class] forCellReuseIdentifier:identifierCell];
}
#pragma mark - new rsa
- (SecKeyRef)getPublicKeyRef {
    
    NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"rsaCert" ofType:@"der"];
    NSData *certData = [NSData dataWithContentsOfFile:resourcePath];
    SecCertificateRef cert = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)certData);
    SecKeyRef key = NULL;
    SecTrustRef trust = NULL;
    SecPolicyRef policy = NULL;
    
    if (cert != NULL) {
        policy = SecPolicyCreateBasicX509();
        if (policy) {
            if (SecTrustCreateWithCertificates((CFTypeRef)cert, policy, &trust) == noErr) {
                SecTrustResultType result;
                if (SecTrustEvaluate(trust, &result) == noErr) {
                    key = SecTrustCopyPublicKey(trust);
                }
            }
        }
    }
    if (policy) CFRelease(policy);
    if (trust) CFRelease(trust);
    if (cert) CFRelease(cert);
    return key;
}
SecKeyRef getPrivateKeyRef() {
    NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"rsaPrivate" ofType:@"p12"];
    NSData *p12Data = [NSData dataWithContentsOfFile:resourcePath];
    
    NSMutableDictionary * options = [[NSMutableDictionary alloc] init];
    
    SecKeyRef privateKeyRef = NULL;
    
    //change to the actual password you used here
    [options setObject:@"123456" forKey:(__bridge id)kSecImportExportPassphrase];
    
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    
    OSStatus securityError = SecPKCS12Import((__bridge CFDataRef) p12Data,
                                             (__bridge CFDictionaryRef)options, &items);
    
    if (securityError == noErr && CFArrayGetCount(items) > 0) {
        CFDictionaryRef identityDict = CFArrayGetValueAtIndex(items, 0);
        SecIdentityRef identityApp =
        (SecIdentityRef)CFDictionaryGetValue(identityDict,
                                             kSecImportItemIdentity);
        
        securityError = SecIdentityCopyPrivateKey(identityApp, &privateKeyRef);
        if (securityError != noErr) {
            privateKeyRef = NULL;
        }
    }
    CFRelease(items);
    return privateKeyRef;
}

- (void)testRSA2{
    NSString *pathDoc = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"bytes"];
    
    NSString *pubKeyPath = [[NSBundle mainBundle] pathForResource:@"ios_cer" ofType:@"der"];
//    NSString *privateKeyPath = [[NSBundle mainBundle] pathForResource:@"rsaPrivate" ofType:@"p12"];
    NSString *helloTest = @"2014年岁末，iTools发布了2014年11月 iOS 手游数据报告。报告显示：以轻度为主的卡牌手游仍然占有相当部分的市场份额;另一方面";
    NSData *plainData = [helloTest dataUsingEncoding:NSUTF8StringEncoding];
    [[RSA sharedInstance] loadPublicKey:pubKeyPath];
//    [[RSA sharedInstance] loadPrivateKey:privateKeyPath password:@"1fv00bz2g408rc9"];
    NSData *rsaEncyptData = [[RSA sharedInstance] rsaEncyptWithData:plainData];
    [rsaEncyptData writeToFile:pathDoc atomically:YES];
    NSLog(pathDoc,nil);
    
    NSError *__autoreleasing error;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"RSA_PRIV_ENCRYPT" ofType:nil];
    
    NSFileManager *fileManaer = [NSFileManager defaultManager];
    NSArray *ary = [fileManaer subpathsOfDirectoryAtPath:path error:&error];
    NSMutableArray *paths = [[NSMutableArray alloc] initWithCapacity:1];
    for (NSString *file in ary) {
        NSString *filePath = [path stringByAppendingPathComponent:file];
        NSData *enData = [NSData dataWithContentsOfFile:filePath];
        NSString *result = [[RSA sharedInstance] decryptUsingPublicKeyWithData:enData];
//        NSLog(result,nil);
//        if (result.length >) {
        NSString *log = [NSString stringWithFormat:@"%@ ---- %@",file,result];
        NSLog(log,nil);
//            break;
//        }
    }
    // kSecPaddingOAEP


    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self getPublicKeyRef];
//    getPrivateKeyRef();
    [self addBarChart];
//    [self addTable];

//    [self testAES];
//    [self testRSAEN];
//    [self testRSADE];
    [self testRSA2];
    
    UIVIewSpringEffect *springView = [[UIVIewSpringEffect alloc] initWithFrame:CGRectMake(50, 50, 2, 30)];
    [self.view addSubview:springView];
    _springView = springView;
    _springView.backgroundColor = [UIColor grayColor];
    [self performSelector:@selector(springEffect) withObject:_springView afterDelay:1];
}
- (void)springEffect{
    [_springView startSpringWithEndFrame:CGRectMake(50, 50, 2, 100)];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addData:(id)sender {
#pragma mark - 自定义动画 cell 插入执行
//    [_listMutArray addObject:[[NSDate date] description]];
//    [_table beginUpdates];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    NSArray *ary = @[indexPath];
//    [_table insertRowsAtIndexPaths:ary withRowAnimation:UITableViewRowAnimationNone];
//    [_table endUpdates];
//    UITableViewCell *cell = [_table cellForRowAtIndexPath:indexPath];
//    cell.backgroundColor = [UIColor redColor];
//    cell.transform = CGAffineTransformMakeScale(0, 0);
//    [UIView beginAnimations:@"scale" context:nil];
//    cell.transform = CGAffineTransformIdentity;
//    [UIView setAnimationDuration:0.5];
//    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:cell cache:YES];
//    [UIView commitAnimations];
#pragma mark spring effect
    _springView.frame = CGRectMake(50, 50, 2, 30);
}

#pragma mark - table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _listMutArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
    cell.textLabel.text = _listMutArray[indexPath.row];
    return cell;
}
#pragma mark - MGLBarChartViewDataSource

- (NSUInteger)numberOfRows{
    return _listMutArray.count;
}
- (NSNumber *)valueOfIndex:(NSInteger)index{
    return [_listMutArray objectAtIndex:index];
}

- (UIView *)viewOfIndex:(NSInteger)index{
    
    UIVIewSpringEffect *springView = [[UIVIewSpringEffect alloc] initWithFrame:CGRectMake(0, 0, 1, 10)];
    if (index < 10) {
        springView.backgroundColor = [UIColor redColor];
    }else if (index > 10){
        springView.backgroundColor = [UIColor greenColor];
    }else{
        springView.backgroundColor = [UIColor purpleColor];
        springView.frame = CGRectMake(0, 0, 2, 10);
    }
    return springView;
}
- (CGFloat)xCenterValueOfIndex:(NSInteger)index{
    if (index < 10) {
        return 11*(index+1);
    }else if (index == 10){
        return 11*10+ 15;
    }else if (index > 10){
        return 30 + 11*(index-10);
    }
    return 0;
}
@end

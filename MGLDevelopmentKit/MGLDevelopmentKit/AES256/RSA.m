//
//  RSA.m
//  RSA
//
//  Created by Reejo Samuel on 2/17/14.
//  Copyright (c) 2014 Clapp Inc. All rights reserved.
//

#import "RSA.h"
#import <Security/Security.h>
#import "Base64.h"

#if DEBUG
    #define LOGGING_FACILITY(X, Y)	\
    NSAssert(X, Y);

    #define LOGGING_FACILITY1(X, Y, Z)	\
    NSAssert1(X, Y, Z);
#else
    #define LOGGING_FACILITY(X, Y)	\
        if (!(X)) {			\
        NSLog(Y);		\
    }

    #define LOGGING_FACILITY1(X, Y, Z)	\
        if (!(X)) {				\
        NSLog(Y, Z);		\
    }
#endif

const size_t kSecAttrKeySizeInBitsLength = 2024;

#define KPublic_key @"MIIFKzCCBBOgAwIBAgIQNmWFB3qIZ6tY9KCU+BA3MzANBgkqhkiG9w0BAQUFADCByjELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDlZlcmlTaWduLCBJbmMuMR8wHQYDVQQLExZWZXJpU2lnbiBUcnVzdCBOZXR3b3JrMTowOAYDVQQLEzEoYykgMjAwNiBWZXJpU2lnbiwgSW5jLiAtIEZvciBhdXRob3JpemVkIHVzZSBvbmx5MUUwQwYDVQQDEzxWZXJpU2lnbiBDbGFzcyAzIFB1YmxpYyBQcmltYXJ5IENlcnRpZmljYXRpb24gQXV0aG9yaXR5IC0gRzUwHhcNMTMxMDMxMDAwMDAwWhcNMjMxMDMwMjM1OTU5WjB3MQswCQYDVQQGEwJVUzEdMBsGA1UEChMUU3ltYW50ZWMgQ29ycG9yYXRpb24xHzAdBgNVBAsTFlN5bWFudGVjIFRydXN0IE5ldHdvcmsxKDAmBgNVBAMTH1N5bWFudGVjIENsYXNzIDMgRVYgU1NMIENBIC0gRzIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDa7MVqNhGG2yAho+xMIf0PxVw6vuyibpgOgplrenrrbvIlyS1gIF3WK+bdmdnxVFx2mwv5J0IkfOrU5jwqziOf+3jJFUT0VixVzla3MPBJif4N2G4BfGHTRJlmXpZIGIcJyMNJ6TXsu0x6FZFV7WCAlQvXGPOnS+bodAwua0X0F/nLv1RW7jbUTubPrR9NfY+zVTXdYtJuVIWeRVN67mCWIn+4Gq9voA6mjhO2haHMXIyerR1xuAiU5s68ONDR6T9xQ/uXI6hs9DHcAjveKVXyoL4eIWyvGlzfajdkAprQUXGlf7ppxSyJZ3A7EwVy7SEjECsjKhquOglkI3onYhLRAgMBAAGjggFdMIIBWTAvBggrBgEFBQcBAQQjMCEwHwYIKwYBBQUHMAGGE2h0dHA6Ly9zMi5zeW1jYi5jb20wEgYDVR0TAQH/BAgwBgEB/wIBADBlBgNVHSAEXjBcMFoGBFUdIAAwUjAmBggrBgEFBQcCARYaaHR0cDovL3d3dy5zeW1hdXRoLmNvbS9jcHMwKAYIKwYBBQUHAgIwHBoaaHR0cDovL3d3dy5zeW1hdXRoLmNvbS9ycGEwMAYDVR0fBCkwJzAloCOgIYYfaHR0cDovL3MxLnN5bWNiLmNvbS9wY2EzLWc1LmNybDAOBgNVHQ8BAf8EBAMCAQYwKQYDVR0RBCIwIKQeMBwxGjAYBgNVBAMTEVN5bWFudGVjUEtJLTEtNTMyMB0GA1UdDgQWBBRL+i3k7jMy4t8NAaGG06A7OrmsrjAfBgNVHSMEGDAWgBR/02Wnwt3su/AwCfNDOfoCrzMxMzANBgkqhkiG9w0BAQUFAAOCAQEARqb1s+ikVsm4NPD3/vMsLmORYyzp1RR/E5P2TN5NgpnMa8l4YfsSLUgPcOonb3jo9wM+yrg7usnfsDri3iLQMS1m2m4RJUL1eyTC3ksSd81W2PuGgLoKU27lAQgb0cmydZ2rBics8lKPWb2uHXT648b8RE1bSmzJuDnZ91qE+aADwjhOizKlQNrCdfS8yvlX+YYHdVvudjUwhQdz0lxG7Q965X9sPTfBveaFSWC6jfnv2qxKMeFk9nlnvz9v4pVS3k+NydQ9/L07uDHw9dn1QQRU4CafmYP5BTYlccTLwSseg1CoewuMVg6qXabpL6Fn/jcgxT6d/J2sIP17u5y4IA=="

#define KPrivate_key @"MIIFjTCCBHWgAwIBAgIQSdGKTPV1h9WJYy5XNysOizANBgkqhkiG9w0BAQUFADB3MQswCQYDVQQGEwJVUzEdMBsGA1UEChMUU3ltYW50ZWMgQ29ycG9yYXRpb24xHzAdBgNVBAsTFlN5bWFudGVjIFRydXN0IE5ldHdvcmsxKDAmBgNVBAMTH1N5bWFudGVjIENsYXNzIDMgRVYgU1NMIENBIC0gRzIwHhcNMTQxMDI0MDAwMDAwWhcNMTUxMjIzMjM1OTU5WjCCAR8xEzARBgsrBgEEAYI3PAIBAxMCQ04xGTAXBgsrBgEEAYI3PAIBAhQIU2hhbmdoYWkxGTAXBgsrBgEEAYI3PAIBARQIU2hhbmdoYWkxHTAbBgNVBA8TFFByaXZhdGUgT3JnYW5pemF0aW9uMRgwFgYDVQQFEw8zMTAxMTAwMDA1NzMzOTExCzAJBgNVBAYTAkNOMREwDwYDVQQIFAhTaGFuZ2hhaTERMA8GA1UEBxQIU2hhbmdoYWkxMDAuBgNVBAoUJ1NoYW5naGFpIEt1YXJrIEZpbmFuY2UgSG9sZGluZ3MgTGltaXRlZDEaMBgGA1UECxQRS3VhcmsgRmluYW5jZSBSJkQxGDAWBgNVBAMUD2FwaS5rYXhpYW9lci5jbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAIfBzcWkTyoR53dqJkKdwpYiqybNOqUiJH0NTgf6UnlGVWm4sWnVAk8mQkN7DJPzil+hiVCgZE9vdg/h5X/ZceWbXIxaPYU3XbqMI9G01yn7TJISyqqGxinnoqkwfX18s+k/5IHulYBNprN5uZHSQzZ7bq68ziPMAaj9KKEFChFZ6J5MFRunTEOqxv1AwY0JHcg1lI81pT6h5sNwlw/iOi9unEZCCGLJ9Y9VVsj0etcikpPjFM01ie9x0BVQH7blYrNASObOCd46MivE2lYBK/j5v6AoGD+YrPUF5L2rrLCpLgpKpiQB/UVmcSmJ/BluuWT/fq/VnX2o09qWwLqjhVkCAwEAAaOCAWkwggFlMBoGA1UdEQQTMBGCD2FwaS5rYXhpYW9lci5jbjAJBgNVHRMEAjAAMA4GA1UdDwEB/wQEAwIFoDArBgNVHR8EJDAiMCCgHqAchhpodHRwOi8vc3Quc3ltY2IuY29tL3N0LmNybDBmBgNVHSAEXzBdMFsGC2CGSAGG+EUBBxcGMEwwIwYIKwYBBQUHAgEWF2h0dHBzOi8vZC5zeW1jYi5jb20vY3BzMCUGCCsGAQUFBwICMBkMF2h0dHBzOi8vZC5zeW1jYi5jb20vcnBhMB0GA1UdJQQWMBQGCCsGAQUFBwMBBggrBgEFBQcDAjAfBgNVHSMEGDAWgBRL+i3k7jMy4t8NAaGG06A7OrmsrjBXBggrBgEFBQcBAQRLMEkwHwYIKwYBBQUHMAGGE2h0dHA6Ly9zdC5zeW1jZC5jb20wJgYIKwYBBQUHMAKGGmh0dHA6Ly9zdC5zeW1jYi5jb20vc3QuY3J0MA0GCSqGSIb3DQEBBQUAA4IBAQCnVOMmeA0jVM8Xdgi5R9Bk2t6SQWKObXAewkQpSk64VkwglXeBzSj+V3XJsWSthZKajKHWdaHB/8AAXixTnZ0BDZf1qQGKc0iKaPfL6gQB/sPtKzNgu3WZfGHHC7K8tEd8SQ9L2NliXAyesJbT2CeSOxd97N0pfWEm1v16IPkUB16F5zBVA2JGUqIfKmhLO3yDGxVIXTO25xUeS5swExRKfG9GL7+QASYUqXJobzICcRsxysnKJqO1vFOc2XHQrsR2q/lb0nooCoIW/Im4Wv3vlHJQVbhWXo+thUNlxRFnAEqITGg1Lc++fRD+GR6VMe6a+dCH2HbIIp4iAFpMm5Tu"


@interface RSA (){
@private
    NSData * publicTag;
	NSData * privateTag;
    NSData * serverPublicTag;
    NSOperationQueue * cryptoQueue;
    GenerateSuccessBlock success;
}

@property (strong, nonatomic) NSString * publicIdentifier;
@property (strong, nonatomic) NSString * privateIdentifier;
@property (strong, nonatomic) NSString * serverPublicIdentifier;


@property (nonatomic,readonly) SecKeyRef publicKeyRef;
@property (nonatomic,readonly) SecKeyRef privateKeyRef;
@property (nonatomic,readonly) SecKeyRef serverPublicRef;

@property (nonatomic,readonly) NSData   * publicKeyBits;
@property (nonatomic,readonly) NSData   * privateKeyBits;

@end

@implementation RSA

@synthesize publicKeyRef, privateKeyRef, serverPublicRef;

// FIXME: Base64 encoding fix
// FIXME: storage to

#pragma mark - Instance Variables

- (id)init{
    if (self = [super init]) {
        cryptoQueue = [[NSOperationQueue alloc] init];
    }return self;
}

+ (id)sharedInstance{
    static RSA *_rsa = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _rsa = [[self alloc] init];
    });
    return _rsa;
}

#pragma mark - Set identifier strings

- (void)setIdentifierForPublicKey:(NSString *)pubIdentifier
                       privateKey:(NSString *)privIdentifier
                  serverPublicKey:(NSString *)servPublicIdentifier {
    
    self.publicIdentifier       = pubIdentifier;
    self.privateIdentifier      = privIdentifier;
    self.serverPublicIdentifier = servPublicIdentifier;
    
    // Tag data to search for keys.
    publicTag       = [self.publicIdentifier dataUsingEncoding:NSUTF8StringEncoding];
    privateTag      = [self.privateIdentifier dataUsingEncoding:NSUTF8StringEncoding];
    serverPublicTag = [self.serverPublicIdentifier dataUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark - Java Helpers

// Java helpers to remove and add extra bits needed for java based backends
// Once it’s base 64 decoded it strips the ASN.1 encoding associated with the OID
// and sequence encoding that generally prepends the RSA key data. That leaves it with just the large numbers that make up the public key.



- (NSString *)getKeyForJavaServer:(NSData*)keyBits {
    
    static const unsigned char _encodedRSAEncryptionOID[15] = {
        
        /* Sequence of length 0xd made up of OID followed by NULL */
        0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86,
        0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00
        
    };
    
    // That gives us the "BITSTRING component of a full DER
    // encoded RSA public key - We now need to build the rest
    
    unsigned char builder[15];
    NSMutableData * encKey = [[NSMutableData alloc] init];
    int bitstringEncLength;
    
    // When we get to the bitstring - how will we encode it?
    
    if  ([keyBits length ] + 1  < 128 )
        bitstringEncLength = 1 ;
    else
        bitstringEncLength = (int)(([keyBits length ] +1 ) / 256 ) + 2 ;
    
    // Overall we have a sequence of a certain length
    builder[0] = 0x30;    // ASN.1 encoding representing a SEQUENCE
    // Build up overall size made up of -
    // size of OID + size of bitstring encoding + size of actual key
    size_t i = sizeof(_encodedRSAEncryptionOID) + 2 + bitstringEncLength +
    [keyBits length];
    size_t j = encodeLength(&builder[1], i);
    [encKey appendBytes:builder length:j +1];
    
    // First part of the sequence is the OID
    [encKey appendBytes:_encodedRSAEncryptionOID
                 length:sizeof(_encodedRSAEncryptionOID)];
    
    // Now add the bitstring
    builder[0] = 0x03;
    j = encodeLength(&builder[1], [keyBits length] + 1);
    builder[j+1] = 0x00;
    [encKey appendBytes:builder length:j + 2];
    
    // Now the actual key
    [encKey appendData:keyBits];
    
    // base64 encode encKey and return
    return [encKey base64EncodedStringWithOptions:0];
    
}

size_t encodeLength(unsigned char * buf, size_t length) {
    
    // encode length in ASN.1 DER format
    if (length < 128) {
        buf[0] = length;
        return 1;
    }
    
    size_t i = (length / 256) + 1;
    buf[0] = i + 0x80;
    for (size_t j = 0 ; j < i; ++j) {
        buf[i - j] = length & 0xFF;
        length = length >> 8;
    }
    
    return i + 1;
}

- (BOOL)setPublicKeyFromJavaServer:(NSString *)keyAsBase64 {
    
    /* First decode the Base64 string */
    NSData *rawFormattedKey = [[NSData alloc] initWithBase64EncodedString:keyAsBase64 options:0];
    
    
    /* Now strip the uncessary ASN encoding guff at the start */
    unsigned char * bytes = (unsigned char *)[rawFormattedKey bytes];
    size_t bytesLen = [rawFormattedKey length];
    
    /* Strip the initial stuff */
    size_t i = 0;
    if (bytes[i++] != 0x30)
        return FALSE;
    
    /* Skip size bytes */
    if (bytes[i] > 0x80)
        i += bytes[i] - 0x80 + 1;
    else
        i++;
    
    if (i >= bytesLen)
        return FALSE;
    
    if (bytes[i] != 0x30)
        return FALSE;
    
    /* Skip OID */
    i += 15;
    
    if (i >= bytesLen - 2)
        return FALSE;
    
    if (bytes[i++] != 0x03)
        return FALSE;
    
    /* Skip length and null */
    if (bytes[i] > 0x80)
        i += bytes[i] - 0x80 + 1;
    else
        i++;
    
    if (i >= bytesLen)
        return FALSE;
    
    if (bytes[i++] != 0x00)
        return FALSE;
    
    if (i >= bytesLen)
        return FALSE;
    
    /* Here we go! */
    NSData * extractedKey = [NSData dataWithBytes:&bytes[i] length:bytesLen - i];
    
    // Base64 Encoding
    NSString *javaLessBase64String = [extractedKey base64EncodedStringWithOptions:0];
    return [self setPublicKey:javaLessBase64String];
}



#pragma mark - Key generators

- (void)generateKeyPairRSACompleteBlock:(GenerateSuccessBlock)_success {
    NSInvocationOperation * genOp = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(generateKeyPairOperation) object:nil];
    [cryptoQueue addOperation:genOp];
    
    success = _success;
}

- (void)generateKeyPairOperation{
    @autoreleasepool {
        // Generate the asymmetric key (public and private)
        [self generateKeyPairRSA];
        [self performSelectorOnMainThread:@selector(generateKeyPairCompleted) withObject:nil waitUntilDone:NO];
    }
}

- (void)generateKeyPairCompleted{
    if (success) {
        success();
    }
}

- (void)generateKeyPairRSA {
    OSStatus sanityCheck = noErr;
	publicKeyRef = NULL;
	privateKeyRef = NULL;
	
	// First delete current keys.
	[self deleteAsymmetricKeys];
	
	// Container dictionaries.
	NSMutableDictionary * privateKeyAttr = [NSMutableDictionary dictionaryWithCapacity:0];
	NSMutableDictionary * publicKeyAttr = [NSMutableDictionary dictionaryWithCapacity:0];
	NSMutableDictionary * keyPairAttr = [NSMutableDictionary dictionaryWithCapacity:0];
	
	// Set top level dictionary for the keypair.
	[keyPairAttr setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
	[keyPairAttr setObject:[NSNumber numberWithUnsignedInteger:kSecAttrKeySizeInBitsLength] forKey:(__bridge id)kSecAttrKeySizeInBits];
	
	// Set the private key dictionary.
	[privateKeyAttr setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecAttrIsPermanent];
	[privateKeyAttr setObject:privateTag forKey:(__bridge id)kSecAttrApplicationTag];
	// See SecKey.h to set other flag values.
	
	// Set the public key dictionary.
	[publicKeyAttr setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecAttrIsPermanent];
	[publicKeyAttr setObject:publicTag forKey:(__bridge id)kSecAttrApplicationTag];
	// See SecKey.h to set other flag values.
	
	// Set attributes to top level dictionary.
	[keyPairAttr setObject:privateKeyAttr forKey:(__bridge id)kSecPrivateKeyAttrs];
	[keyPairAttr setObject:publicKeyAttr forKey:(__bridge id)kSecPublicKeyAttrs];
	
	// SecKeyGeneratePair returns the SecKeyRefs just for educational purposes.
	sanityCheck = SecKeyGeneratePair((__bridge CFDictionaryRef)keyPairAttr, &publicKeyRef, &privateKeyRef);
	LOGGING_FACILITY( sanityCheck == noErr && publicKeyRef != NULL && privateKeyRef != NULL, @"Something really bad went wrong with generating the key pair." );
}

#pragma mark - Deletion

- (void)deleteAsymmetricKeys {
    
	OSStatus sanityCheck = noErr;
	NSMutableDictionary * queryPublicKey        = [NSMutableDictionary dictionaryWithCapacity:0];
	NSMutableDictionary * queryPrivateKey       = [NSMutableDictionary dictionaryWithCapacity:0];
	NSMutableDictionary * queryServPublicKey    = [NSMutableDictionary dictionaryWithCapacity:0];
    
	// Set the public key query dictionary.
	[queryPublicKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
	[queryPublicKey setObject:publicTag forKey:(__bridge id)kSecAttrApplicationTag];
	[queryPublicKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
	
	// Set the private key query dictionary.
	[queryPrivateKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
	[queryPrivateKey setObject:privateTag forKey:(__bridge id)kSecAttrApplicationTag];
	[queryPrivateKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    
    // Set the server public key query dictionary.
	[queryServPublicKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
	[queryServPublicKey setObject:serverPublicTag forKey:(__bridge id)kSecAttrApplicationTag];
	[queryServPublicKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
	
	// Delete the private key.
	sanityCheck = SecItemDelete((__bridge CFDictionaryRef)queryPrivateKey);
	LOGGING_FACILITY1( sanityCheck == noErr || sanityCheck == errSecItemNotFound, @"Error removing private key, OSStatus == %ld.", (long)sanityCheck );
	
	// Delete the public key.
	sanityCheck = SecItemDelete((__bridge CFDictionaryRef)queryPublicKey);
	LOGGING_FACILITY1( sanityCheck == noErr || sanityCheck == errSecItemNotFound, @"Error removing public key, OSStatus == %ld.", (long)sanityCheck );
    
    // Delete the server public key.
	sanityCheck = SecItemDelete((__bridge CFDictionaryRef)queryServPublicKey);
	LOGGING_FACILITY1( sanityCheck == noErr || sanityCheck == errSecItemNotFound, @"Error removing server public key, OSStatus == %ld.", (long)sanityCheck );

    
	if (publicKeyRef) CFRelease(publicKeyRef);
	if (privateKeyRef) CFRelease(privateKeyRef);
    if (serverPublicRef) CFRelease(serverPublicRef);
}

#pragma mark - Read Bits

- (NSData *)readKeyBits:(NSData *)tag keyType:(CFTypeRef)keyType {
    
    OSStatus sanityCheck = noErr;
	CFTypeRef  _publicKeyBitsReference = NULL;
	
	NSMutableDictionary * queryPublicKey = [NSMutableDictionary dictionaryWithCapacity:0];
    
	// Set the public key query dictionary.
	[queryPublicKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
	[queryPublicKey setObject:tag forKey:(__bridge id)kSecAttrApplicationTag];
	[queryPublicKey setObject:(__bridge id)keyType forKey:(__bridge id)kSecAttrKeyType];
	[queryPublicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnData];
    
	// Get the key bits.
	sanityCheck = SecItemCopyMatching((__bridge CFDictionaryRef)queryPublicKey, (CFTypeRef *)&_publicKeyBitsReference);
    
	if (sanityCheck != noErr) {
		_publicKeyBitsReference = NULL;
	}
    
    publicKeyRef = (SecKeyRef)_publicKeyBitsReference;
    
	return (__bridge NSData*)_publicKeyBitsReference;

}

- (NSData *)publicKeyBits {
    return [self readKeyBits:publicTag keyType:kSecAttrKeyTypeRSA];
}

- (NSData *)privateKeyBits {
    return [self readKeyBits:privateTag keyType:kSecAttrKeyTypeRSA];
}

- (NSData *)serverPublicBits {
    return [self readKeyBits:serverPublicTag keyType:kSecAttrKeyTypeRSA];
}


#pragma mark - Get Refs

- (void)getKeyRefFor:(NSData *)tag {
    
    OSStatus resultCode = noErr;
    
    NSMutableDictionary * queryPublicKey = [NSMutableDictionary dictionaryWithCapacity:0];
    
    // Set the public key query dictionary.
    [queryPublicKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    
    [queryPublicKey setObject:tag forKey:(__bridge id)kSecAttrApplicationTag];
    
    [queryPublicKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    
    [queryPublicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    
    // Get the key.
    resultCode = SecItemCopyMatching((__bridge CFDictionaryRef)queryPublicKey, (CFTypeRef *)&publicKeyRef);
    //NSLog(@"getPublicKey: result code: %ld", resultCode);
    
    if(resultCode != noErr)
    {
        publicKeyRef = NULL;
    }
    
    queryPublicKey =nil;
}

- (void)loadPublicKey:(NSString *)keyPath {
//    [self releaseSecVars];
    if (publicKeyRef) {
        return;
    }
    
//    NSData *certificateData = [KPublic_key base64DecodedData];
    
    
    NSData *certificateData = [NSData dataWithContentsOfFile:keyPath];
    
    SecCertificateRef certificateRef = SecCertificateCreateWithData(kCFAllocatorDefault, (__bridge CFDataRef)certificateData);
    SecPolicyRef policyRef = SecPolicyCreateBasicX509();
    SecTrustRef trustRef;
    
    OSStatus status = SecTrustCreateWithCertificates(certificateRef, policyRef, &trustRef);
    NSAssert(status == errSecSuccess, @"SecTrustCreateWithCertificates failed.");
    
    SecTrustResultType trustResult;
    status = SecTrustEvaluate(trustRef, &trustResult);
    NSAssert(status == errSecSuccess, @"SecTrustEvaluate failed.");
    
    publicKeyRef = SecTrustCopyPublicKey(trustRef);
    NSAssert(publicKeyRef != NULL, @"SecTrustCopyPublicKey failed.");
    
    if (certificateRef) CFRelease(certificateRef);
    if (policyRef) CFRelease(policyRef);
    if (trustRef) CFRelease(trustRef);
}
- (void)loadPrivateKey:(NSString *)keyPath password:(NSString *)password{
    if(privateKeyRef) return;
    
    NSData *PKCS12Data = [KPrivate_key base64DecodedData];
//    NSData *PKCS12Data = [NSData dataWithContentsOfFile:keyPath];
    
    CFDataRef inPKCS12Data = (__bridge CFDataRef)PKCS12Data;
    CFStringRef passwordRef = (__bridge CFStringRef)password;
    
    SecIdentityRef myIdentity;
    SecTrustRef myTrust;
    OSStatus status = extractIdentityAndTrust(inPKCS12Data, &myIdentity, &myTrust, passwordRef);
    NSAssert(status == noErr, @"extractIdentityAndTrust failed.");
    
    SecTrustResultType trustResult;
    status = SecTrustEvaluate(myTrust, &trustResult);
    NSAssert(status == errSecSuccess, @"SecTrustEvaluate failed.");
    
    status = SecIdentityCopyPrivateKey(myIdentity, &privateKeyRef);
    NSAssert(status == errSecSuccess, @"SecIdentityCopyPrivateKey failed.");
    
    if (myIdentity) CFRelease(myIdentity);
    if (myTrust) CFRelease(myTrust);
}

#pragma mark - Encrypt and Decrypt
- (NSData *)rsaEncyptWithData:(NSData *)data{
    SecKeyRef key = self.publicKeyRef;
    NSAssert(key, @"no publickeyRef");
    
    size_t cipherBufferSize = SecKeyGetBlockSize(key);
    uint8_t *cipherBuffer = malloc(cipherBufferSize * sizeof(uint8_t));
    memset((void *)cipherBuffer, 0*0, cipherBufferSize);
    
    NSData *plainTextBytes = data;
    size_t blockSize = cipherBufferSize - 11;
    size_t blockCount = (size_t)ceil([plainTextBytes length] / (double)blockSize);
    NSMutableData *encryptedData = [NSMutableData dataWithCapacity:0];
    
    for (int i=0; i<blockCount; i++) {
        
        int bufferSize = (int)MIN(blockSize,[plainTextBytes length] - i * blockSize);
        NSData *buffer = [plainTextBytes subdataWithRange:NSMakeRange(i * blockSize, bufferSize)];
        
        OSStatus status = SecKeyEncrypt(key,
                                        kSecPaddingNone,
                                        (const uint8_t *)[buffer bytes],
                                        [buffer length],
                                        cipherBuffer,
                                        &cipherBufferSize);
        
        if (status == noErr){
            NSData *encryptedBytes = [NSData dataWithBytes:(const void *)cipherBuffer length:cipherBufferSize];
            [encryptedData appendData:encryptedBytes];
            
        }else{
            
            if (cipherBuffer) {
                free(cipherBuffer);
            }
            return nil;
        }
    }
    if (cipherBuffer) free(cipherBuffer);
    
    return encryptedData;
}
- (NSString *)rsaDecryptWithData:(NSData *)data{
    NSData *wrappedSymmetricKey = data;
    SecKeyRef key = self.privateKeyRef;
    
    //    key = [self getPrivateKeyRef]; // reejo remove
    
    size_t cipherBufferSize = SecKeyGetBlockSize(key);
    size_t keyBufferSize = [wrappedSymmetricKey length];
    
    NSMutableData *bits = [NSMutableData dataWithLength:keyBufferSize];
    OSStatus sanityCheck = SecKeyDecrypt(key,
                                         kSecPaddingPKCS1,
                                         (const uint8_t *) [wrappedSymmetricKey bytes],
                                         cipherBufferSize,
                                         [bits mutableBytes],
                                         &keyBufferSize);
    
    if (sanityCheck != 0) {
        NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:sanityCheck userInfo:nil];
        NSLog(@"Error: %@", [error description]);
    }
    
    NSAssert(sanityCheck == noErr, @"Error decrypting, OSStatus == %ld.", (long)sanityCheck);
    
    [bits setLength:keyBufferSize];
    
    return [[NSString alloc] initWithData:bits
                                 encoding:NSUTF8StringEncoding];
}
- (NSString *)rsaEncryptWithData:(NSData*)data usingPublicKey:(BOOL)yes server:(BOOL)isServer{
    
    
    if (isServer) {
        [self getKeyRefFor:serverPublicTag];
    } else {
        if (yes) {
            [self getKeyRefFor:publicTag];
        } else {
            [self getKeyRefFor:privateTag];
        }
    }
    
    SecKeyRef key = self.publicKeyRef;

    
    size_t cipherBufferSize = SecKeyGetBlockSize(key);
    uint8_t *cipherBuffer = malloc(cipherBufferSize * sizeof(uint8_t));
    memset((void *)cipherBuffer, 0*0, cipherBufferSize);
    
    NSData *plainTextBytes = data;
    size_t blockSize = cipherBufferSize - 11;
    size_t blockCount = (size_t)ceil([plainTextBytes length] / (double)blockSize);
    NSMutableData *encryptedData = [NSMutableData dataWithCapacity:0];
    
    for (int i=0; i<blockCount; i++) {
        
        int bufferSize = (int)MIN(blockSize,[plainTextBytes length] - i * blockSize);
        NSData *buffer = [plainTextBytes subdataWithRange:NSMakeRange(i * blockSize, bufferSize)];
        
        OSStatus status = SecKeyEncrypt(key,
                                        kSecPaddingPKCS1,
                                        (const uint8_t *)[buffer bytes],
                                        [buffer length],
                                        cipherBuffer,
                                        &cipherBufferSize);
        
        if (status == noErr){
            NSData *encryptedBytes = [NSData dataWithBytes:(const void *)cipherBuffer length:cipherBufferSize];
            [encryptedData appendData:encryptedBytes];
            
        }else{
            
            if (cipherBuffer) {
                free(cipherBuffer);
            }
            return nil;
        }
    }
    if (cipherBuffer) free(cipherBuffer);

    return [encryptedData base64EncodedStringWithOptions:0];
}

- (NSString *)rsaDecryptWithData:(NSData*)data usingPublicKey:(BOOL)yes{
    NSData *wrappedSymmetricKey = data;
    SecKeyRef key = yes?self.publicKeyRef:self.privateKeyRef;
    
//    key = [self getPrivateKeyRef]; // reejo remove
   /*
//    SecKeyRef key = self.publicKeyRef;
    size_t cipherLen = [data length];
    void *cipher = malloc(cipherLen);
    [data getBytes:cipher length:cipherLen];
    size_t plainLen = SecKeyGetBlockSize(key);
    void *plain = malloc(plainLen);
    OSStatus status = SecKeyDecrypt(key, kSecPaddingOAEP, cipher, cipherLen, plain, &plainLen);
    
    if (status != noErr) {
        return nil;
    }
    
    NSData *decryptedData = [[NSData alloc] initWithBytes:(const void *)plain length:plainLen];
    
    return decryptedData;
//    */
    
    size_t cipherBufferSize = SecKeyGetBlockSize(key);
    size_t keyBufferSize =
    [wrappedSymmetricKey length];
    
    NSMutableData *bits = [NSMutableData dataWithLength:keyBufferSize];
    OSStatus sanityCheck = SecKeyDecrypt(key,
                                         kSecPaddingNone,
                                         (const uint8_t *) [wrappedSymmetricKey bytes],
                                         cipherBufferSize,
                                         [bits mutableBytes],
                                         &keyBufferSize);
    
    if (sanityCheck != 0) {
        NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:sanityCheck userInfo:nil];
        NSLog(@"Error: %@", [error description]);
    }
    
//    NSAssert(sanityCheck == noErr, @"Error decrypting, OSStatus == %ld.", (long)sanityCheck);
    
    [bits setLength:keyBufferSize];
    
//    bits

    return [[NSString alloc] initWithData:bits
                                  encoding:NSUTF8StringEncoding];
}

#pragma mark - Public Key setter

- (BOOL)setPublicKey: (NSString *)keyAsBase64 {
    
    NSData *extractedKey =
                [[NSData alloc] initWithBase64EncodedString:keyAsBase64 options:0];
    
    /* Load as a key ref */
    OSStatus error = noErr;
    CFTypeRef persistPeer = NULL;
    
    NSData * refTag = [self.serverPublicIdentifier dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary * keyAttr = [[NSMutableDictionary alloc] init];
    
    [keyAttr setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [keyAttr setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [keyAttr setObject:refTag forKey:(__bridge id)kSecAttrApplicationTag];
    
    /* First we delete any current keys */
    error = SecItemDelete((__bridge CFDictionaryRef) keyAttr);
    
    [keyAttr setObject:extractedKey forKey:(__bridge id)kSecValueData];
    [keyAttr setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnPersistentRef];
    
    error = SecItemAdd((__bridge CFDictionaryRef) keyAttr, (CFTypeRef *)&persistPeer);
    
    if (persistPeer == nil || ( error != noErr && error != errSecDuplicateItem)) {
        NSLog(@"Problem adding public key to keychain");
        return FALSE;
    }
    
    CFRelease(persistPeer);
    
    serverPublicRef = nil;
    
    /* Now we extract the real ref */
    [keyAttr removeAllObjects];
    /*
     [keyAttr setObject:(id)persistPeer forKey:(id)kSecValuePersistentRef];
     [keyAttr setObject:[NSNumber numberWithBool:YES] forKey:(id)kSecReturnRef];
     */
    [keyAttr setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [keyAttr setObject:refTag forKey:(__bridge id)kSecAttrApplicationTag];
    [keyAttr setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [keyAttr setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    
    // Get the persistent key reference.
    error = SecItemCopyMatching((__bridge CFDictionaryRef)keyAttr, (CFTypeRef *)&serverPublicRef);
    
    if (serverPublicRef == nil || ( error != noErr && error != errSecDuplicateItem)) {
        NSLog(@"Error retrieving public key reference from chain");
        return FALSE;
    }
    
    return TRUE;
}


#pragma mark - Public Key getters

- (NSString *)getPublicKeyAsBase64 {
    return [[self publicKeyBits] base64EncodedStringWithOptions:0];
}

- (NSString *)getPublicKeyAsBase64ForJavaServer {
    return [self getKeyForJavaServer:[self publicKeyBits]];
}

- (NSString *)getServerPublicKey {
    return [[self serverPublicBits] base64EncodedStringWithOptions:0];
}

#pragma mark - Encrypt helpers

- (NSString *)encryptUsingServerPublicKeyWithData:(NSData *)data {
    return [self rsaEncryptWithData:data usingPublicKey:YES server:YES];
}

- (NSString *)encryptUsingPublicKeyWithData:(NSData *)data{
    return [self rsaEncryptWithData:data usingPublicKey:YES server:NO];
}

- (NSString *)encryptUsingPrivateKeyWithData:(NSData*)data{
    return [self rsaEncryptWithData:data usingPublicKey:NO server:NO];
}

#pragma mark - Decrypt helpers

- (NSString *)decryptUsingPublicKeyWithData:(NSData *)data{
    return [self rsaDecryptWithData:data usingPublicKey:YES];
}

- (NSString *)decryptUsingPrivateKeyWithData:(NSData*)data{
    return [self rsaDecryptWithData:data usingPublicKey:NO];
}

@end

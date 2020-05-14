//
//  ZHEncryptDecryptTools.m
//  demo
//
//  Created by ZH on 2020/5/9.
//  Copyright © 2020 张豪. All rights reserved.
//



#import "ZHEncryptDecryptTools.h"

// 下面是AES加密需要的头
#import "NSData+AES256.h"

// 这里用全局变量不用属性是因为, 下面的方法都是类方法, 类方法里面不允许访问成员变量和属性,
static    SecKeyRef _publicKey;
static    SecKeyRef _privateKey;

@implementation ZHEncryptDecryptTools


#pragma mark - 下面是RSA加密的代码

/// 加密的过程
/**
通过路径生成 SecKeyRef _publicKey（即公钥）
@param derFilePath der文件的路径
*/
+ (void)loadPublicKeyWithPath:(NSString *)derFilePath {
    NSData *derData = [[NSData alloc] initWithContentsOfFile:derFilePath];
    if (derData.length > 0) {
        [self loadPublicKeyWithData:derData];
    } else {
        NSLog(@"load public key fail with path: %@", derFilePath);
    }
}
+ (void)loadPublicKeyWithData:(NSData *)derData {
    SecCertificateRef myCertificate = SecCertificateCreateWithData(kCFAllocatorDefault, (__bridge CFDataRef)derData);
    SecPolicyRef myPolicy = SecPolicyCreateBasicX509();
    SecTrustRef myTrust;
    OSStatus status = SecTrustCreateWithCertificates(myCertificate,myPolicy,&myTrust);
    SecTrustResultType trustResult;

    if (status == noErr) {
        status = SecTrustEvaluate(myTrust, &trustResult);
    }
    SecKeyRef securityKey = SecTrustCopyPublicKey(myTrust);
    CFRelease(myCertificate);
    CFRelease(myPolicy);
    CFRelease(myTrust);
    _publicKey = securityKey;
}
/**
生成密文：根据传入明文生成密文
@param text 传入需要加密的明文
@return 密文
*/
+ (NSString *)rsaEncryptText:(NSString *)text {
    NSData *encryptedData = [self rsaEncryptData:[text dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *base64EncryptedString = [encryptedData base64EncodedStringWithOptions:0];
    return base64EncryptedString;
}
+ (NSData *)rsaEncryptData:(NSData *)data {
    SecKeyRef key = _publicKey;

    size_t cipherBufferSize = SecKeyGetBlockSize(key);
    uint8_t *cipherBuffer = malloc(cipherBufferSize * sizeof(uint8_t));
    size_t blockSize = cipherBufferSize - 11;
    size_t blockCount = (size_t)ceil([data length] / (double)blockSize);

    NSMutableData *encryptedData = [[NSMutableData alloc] init] ;
    for (int i = 0; i < blockCount; i++) {
        size_t bufferSize = MIN(blockSize,[data length] - i * blockSize);
        NSData *buffer = [data subdataWithRange:NSMakeRange(i * blockSize, bufferSize)];
        OSStatus status = SecKeyEncrypt(key,
                                        kSecPaddingPKCS1,
                                        (const uint8_t *)[buffer bytes],
                                        [buffer length],
                                        cipherBuffer,
                                        &cipherBufferSize);
        if (status == noErr) {
            NSData *encryptedBytes = [[NSData alloc] initWithBytes:(const void *)cipherBuffer
                                                            length:cipherBufferSize];
            [encryptedData appendData:encryptedBytes];
        } else {
            if (cipherBuffer) {
                free(cipherBuffer);
            }

            return nil;
        }
    }

    if (cipherBuffer){
        free(cipherBuffer);
    }

    return encryptedData;
}

/// 解密的过程
/**
 通过路径生成 SecKeyRef _privateKey（即秘钥）;
 @param p12FilePath p12File的路径
 @param p12Password p12File的密码
 */
+ (void)loadPrivateKeyWithPath:(NSString *)p12FilePath password:(NSString *)p12Password {
    NSData *data = [NSData dataWithContentsOfFile:p12FilePath];

    if (data.length > 0) {
        [self loadPrivateKeyWithData:data password:p12Password];
    } else {
        NSLog(@"load private key fail with path: %@", p12FilePath);
    }
}
+ (void)loadPrivateKeyWithData:(NSData *)p12Data password:(NSString *)p12Password {
    SecKeyRef privateKeyRef = NULL;
    NSMutableDictionary * options = [[NSMutableDictionary alloc] init];

    [options setObject:p12Password forKey:(__bridge id)kSecImportExportPassphrase];

    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    OSStatus securityError = SecPKCS12Import((__bridge CFDataRef)p12Data,
                                             (__bridge CFDictionaryRef)options,
                                             &items);

    if (securityError == noErr && CFArrayGetCount(items) > 0) {
        CFDictionaryRef identityDict = CFArrayGetValueAtIndex(items, 0);
        SecIdentityRef identityApp = (SecIdentityRef)CFDictionaryGetValue(identityDict,
                                                                          kSecImportItemIdentity);
        securityError = SecIdentityCopyPrivateKey(identityApp, &privateKeyRef);

        if (securityError != noErr) {
            privateKeyRef = NULL;
        }
    }
    CFRelease(items);
    _privateKey = privateKeyRef;
}
/**
解密：根据传入的密文解密成铭文
@param text 传入需要解密的密文
@return 铭文
*/
+ (NSString *)rsaDecryptText:(NSString *)text {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:text options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *decryptData = [self rsaDecryptData:data];
    NSString *result = [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding];
    return result;
}
+ (NSData *)rsaDecryptData:(NSData *)data {
    SecKeyRef key = _privateKey;

    size_t cipherLen = [data length];
    void *cipher = malloc(cipherLen);

    [data getBytes:cipher length:cipherLen];
    size_t plainLen = SecKeyGetBlockSize(key) - 12;

    void *plain = malloc(plainLen);
    OSStatus status = SecKeyDecrypt(key, kSecPaddingPKCS1, cipher, cipherLen, plain, &plainLen);

    if (status != noErr) {
        return nil;
    }

    NSData *decryptedData = [[NSData alloc] initWithBytes:(const void *)plain length:plainLen];

    return decryptedData;
}
#pragma mark 上面是RSA加密的代码




#pragma mark - 下面是AES加密的代码
/** 加密
 str : 需要加密的明文
 key : 随便写的一个字符串, 加解密用同一个就行
 */
+ (NSString *)aesEncryptText:(NSString *)str withKey:(NSString *)key{
    const char *cstr = [str cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:str.length];
    //对数据进行加密
    NSData *result = [data aes256_encrypt:key];
    
    //转换为2进制字符串
    if (result && result.length > 0) {
        
        Byte *datas = (Byte*)[result bytes];
        NSMutableString *output = [NSMutableString stringWithCapacity:result.length * 2];
        for(int i = 0; i < result.length; i++){
            [output appendFormat:@"%02x", datas[i]];
        }
        return output;
    }

    return nil;
}
/**解密
 str : 需要解密的信息
 key : 随便写的一个字符串, 加解密用同一个就行
 */
+ (NSString *)aesDecryptText:(NSString *)str withKey:(NSString *)key{
    //转换为2进制Data
    NSMutableData *data = [NSMutableData dataWithCapacity:str.length / 2];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [str length] / 2; i++) {
        byte_chars[0] = [str characterAtIndex:i * 2];
        byte_chars[1] = [str characterAtIndex:i * 2 + 1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    //对数据进行解密
    NSData* result = [data aes256_decrypt:key];
    if (result && result.length > 0) {
        
        return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    }

    return nil;
}


#pragma mark 上面是AES加密的代码





// TODO : 其他加密方式就在下面写就行

@end

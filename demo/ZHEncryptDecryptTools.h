//
//  ZHEncryptDecryptTools.h
//  demo
//
//  Created by ZH on 2020/5/9.
//  Copyright © 2020 张豪. All rights reserved.
//

// 专门用来管理加密的工具类

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHEncryptDecryptTools : NSObject



#pragma mark - 下面是RSA加密的代码

/// ****************** 以下是加密用到的方法 ********************
/**
 通过路径生成 SecKeyRef _publicKey（即公钥）
 @param derFilePath der文件的路径
 */
+ (void)loadPublicKeyWithPath:(NSString *)derFilePath;
+ (void)loadPublicKeyWithData:(NSData *)derData;
/**
生成密文：根据传入明文生成密文
@param text 传入需要加密的明文
@return 密文
*/
+ (NSString *)rsaEncryptText:(NSString *)text;
+ (NSData *)rsaEncryptData:(NSData *)data;
/// ****************** 以上是加密用到的方法 ********************

/// ****************** 以下是解密用到的方法 ********************
/**
 通过路径生成 SecKeyRef _privateKey（即秘钥）;
 @param p12FilePath p12文件的路径
 @param p12Password p12文件的密码
 */
+ (void)loadPrivateKeyWithPath:(NSString *)p12FilePath password:(NSString *)p12Password;
+ (void)loadPrivateKeyWithData:(NSData *)p12Data password:(NSString *)p12Password;
/**
解密：根据传入的密文解密成铭文
@param text 传入需要解密的密文
@return 铭文
*/
+ (NSString *)rsaDecryptText:(NSString *)text;
+ (NSData *)rsaDecryptData:(NSData *)data;
/// ****************** 以上是解密用到的方法 ********************


#pragma mark 上面是RSA加密的代码


#pragma mark - 下面是AES加密的代码
/** 加密
 str : 需要加密的明文
 key : 随便写的一个字符串, 加解密用同一个就行
 */
+ (NSString *)aesEncryptText:(NSString *)str withKey:(NSString *)key;
/**解密
 str : 需要解密的信息
 key : 随便写的一个字符串, 加解密用同一个就行
 */
+ (NSString *)aesDecryptText:(NSString *)str withKey:(NSString *)key;

#pragma mark 上面是AES加密的代码



#pragma mark - 下面是MD5加密的代码
/** MD5加密
 str : 需要加密的字符串
 */
+ (NSString *)md5:(NSString *)str;
#pragma mark 上面是AES加密的代码





#pragma mark - 下面是xxx加密的代码

#pragma mark 上面是xxx加密的代码






// TODO : 其他加密方式就在下面写就行


@end

NS_ASSUME_NONNULL_END

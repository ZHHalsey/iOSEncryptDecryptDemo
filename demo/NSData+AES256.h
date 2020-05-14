//
//  NSData+AES256.h
//  demo
//
//  Created by ZH on 2020/5/14.
//  Copyright © 2020 张豪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>


NS_ASSUME_NONNULL_BEGIN

@interface NSData (AES256)

-(NSData *) aes256_encrypt:(NSString *)key;
-(NSData *) aes256_decrypt:(NSString *)key;


@end

NS_ASSUME_NONNULL_END

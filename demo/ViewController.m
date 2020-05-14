//
//  ViewController.m
//  demo
//
//  Created by ZH on 2020/4/14.
//  Copyright © 2020 张豪. All rights reserved.
//

#import "ViewController.h"
#import "ZHEncryptDecryptTools.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    
    
//    [self RSAEncryptDecrypt]; // RSA方式加解密
    
//    [self AESEncryptDecrypt]; // AES方式加解密
    
    [self MD5Encrypt]; //  MD5加密
    

    
    
}

/// RSA方式加解密
- (void)RSAEncryptDecrypt{
    // 1 > 获取public_key.der路径
    NSString *publicPath = [[NSBundle mainBundle] pathForResource:@"public_key.der" ofType:nil];
    NSLog(@"publicPath路径--%@", publicPath);
    
    // 2 > 通过路径生成 SecKeyRef _publicKey（即公钥）
    [ZHEncryptDecryptTools loadPublicKeyWithPath:publicPath];
    
    // 3 > 根据传入明文生成密文
    NSString *encryptString = [ZHEncryptDecryptTools rsaEncryptText:@"我是明文，把我非对称加密"];
    NSLog(@"RSA加密后的密文--%@", encryptString);
    
    
    
    // 4 > 获取private_key.p12路径
    NSString *privatePath = [[NSBundle mainBundle] pathForResource:@"private_key.p12" ofType:nil];
    NSLog(@"private_key.p12路径--%@", privatePath);
    
    // 5 > 通过路径生成SecKeyRef _privateKey（即秘钥）
    //后面的这个密码就是生成私钥文件private_key.p12时终端设置的密码, 不对的话程序就会崩溃
    [ZHEncryptDecryptTools loadPrivateKeyWithPath:privatePath password:@"asdf9999"];
    
    NSString *string = [ZHEncryptDecryptTools rsaDecryptText:encryptString];
    NSLog(@"RSA解密结果为：%@", string);

}

/// AES方式加解密
- (void)AESEncryptDecrypt{
    
    // 明文
    NSString *userName = @"userName:zhanghao";
    NSLog(@"AES加密前的明文--%@", userName);
    
    // 明文加密获得密文
    NSString *aesEncrypt_UserName = [ZHEncryptDecryptTools aesEncryptText:userName withKey:@"ddddd"];
    NSLog(@"AES加密后的字符串--%@", aesEncrypt_UserName);
    
    // 密文解密(传入的key跟上面不一样的话, 得到的结果就是 null)
    NSString *aesDecrypt_UserName = [ZHEncryptDecryptTools aesDecryptText:aesEncrypt_UserName withKey:@"ddddd"];
    NSLog(@"AES解密后的字符串--%@", aesDecrypt_UserName);
}

/// MD5加密
- (void)MD5Encrypt{
    NSString *userName = @"hahaha";
    NSLog(@"加密前的明文字符串是--%@", userName);
    
    // 加密
    NSString *md5Encrypt_UserName = [ZHEncryptDecryptTools md5:userName];
    NSLog(@"MD5加密后的字符串是--%@", md5Encrypt_UserName);
    
    /*
     因为MD5加密属于哈希算法, 这是一种单向算法, 不可逆, 可以对目标信息生成特定长度的唯一的Hash值, 但是不能通过这个Hash值重新获得目标信息, 但是网上有MD5破解的网站, 这里加密后可以去网站上试试破解后的是不是跟加密前的明文是一样的
     */
}


@end

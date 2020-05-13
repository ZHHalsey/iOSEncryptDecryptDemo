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
    
    
    [self RSAEncryptDecrypt]; // RSA方式加解密
    
    [self AESEncryptDecrypt]; // AES方式加解密
    

    
    
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
    NSLog(@"加密后的密文--%@", encryptString);
    
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
    
}




@end

# iOSEncryptDecryptDemo
iOS各种加密方式汇总demo

把类ZHEncryptDecryptTools拖入到项目中, 在需要加解密的地方import, 然后 使用类方法进行加解密就可以, 详细使用代码请看demo里面的VC控制器


## 补充说明 : 
### RSA加密方式 :  
    需要通过终端生成一些文件, 这里iOS需要的文件就是p12和der, 详情查看demo目录里面的文件
    
### AES加密方式 : 
    需要添加NSData+AES256分类
    
### base64编解码 : 
    支持NSString和UIImage两种类型的编码和解码
    

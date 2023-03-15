//
//  ZSRc4.m
//  haozhuzhushou
//
//  Created by chenhui on 2018/10/27.
//  Copyright © 2018年 chenhui. All rights reserved.
//

#define BOX_LEN 256

#import "ZSRc4.h"

@implementation ZSRc4

char* Encrypt(const char* szSource, const char* szPassWord,int szLen,int szPassLen) // 加密，返回加密结果
{
    
    if(szSource == NULL || szPassWord == NULL) return NULL;
    
    unsigned char* ret = (unsigned char*)malloc(szLen+1);
    memset(ret,0,szLen+1);
    
    int ret_len = 0;
    
    if(RC4((unsigned char*)szSource,
           szLen,
           (unsigned char*)szPassWord,
           szPassLen,
           ret,
           &ret_len) == NULL)
        return NULL;
    
    char* ret2 = ByteToHex(ret, ret_len);
    
    //delete[] ret;
    free(ret);
    ret = NULL;
    return ret2;
}

char* Decrypt(const char* szSource, const char* szPassWord,int szLen,int szPassLen) // 解密，返回解密结果
{
    if(szSource == NULL || (szLen%2 != 0) || szPassWord == NULL)
        return NULL;
    
    unsigned char* src = HexToByte(szSource,szLen);
    
    //unsigned char* ret = new unsigned char[szLen / 2 + 1];
    unsigned char* ret = (unsigned char*)malloc(szLen / 2 + 1);
    
    memset(ret,0,szLen/2+1);
    
    int ret_len = 0;
    
    if(RC4(src, szLen / 2, (unsigned char*)szPassWord, szPassLen, ret, &ret_len) == NULL)
        return NULL;
    
    //ret[ret_len] = '/0';
    
    free(src);
    src = NULL;
    
    return (char*)ret;
}

int RC4(const unsigned char* data, int data_len, const unsigned char* key, int key_len, unsigned char* out, int* out_len)
{
    
    if (data == NULL || key == NULL || out == NULL)
        return NULL;
    
    //unsigned char* mBox = new unsigned char[BOX_LEN];
    unsigned char* mBox = (unsigned char*)malloc(BOX_LEN);
    memset(mBox,0,BOX_LEN);
    
    if(GetKey(key, key_len, mBox) == NULL)
        return NULL;
    
    int i = 0;
    int x = 0;
    int y = 0;
    
    for(int k = 0; k < data_len; k++)
    {
        x = (x + 1) % BOX_LEN;
        y = (mBox[x] + y) % BOX_LEN;
        swap_byte(&mBox[x], &mBox[y]);
        out[k] = data[k] ^ mBox[(mBox[x] + mBox[y]) % BOX_LEN];
    }
    
    *out_len = data_len;
    free(mBox);
    mBox = NULL;
    return -1;
}

int GetKey(const unsigned char* pass, int pass_len, unsigned char* out)
{
    if(pass == NULL || out == NULL)
        return NULL;
    
    int i;
    
    for(i = 0; i < BOX_LEN; i++)
        out[i] = i;
    
    int j = 0;
    for(i = 0; i < BOX_LEN; i++)
    {
        j = (pass[i % pass_len] + out[i] + j) % BOX_LEN;
        swap_byte(&out[i], &out[j]);
    }
    
    return -1;
}

static void swap_byte(unsigned char* a, unsigned char* b)
{
    unsigned char swapByte;
    
    swapByte = *a;
    
    *a = *b;
    
    *b = swapByte;
}

// 把字节码转为十六进制码，一个字节两个十六进制，内部为字符串分配空间
char* ByteToHex(const unsigned char* vByte, const int vLen)
{
    
    if(!vByte)
        return NULL;
    
    //char* tmp = new char[vLen * 2 + 1]; // “ª∏ˆ◊÷Ω⁄¡Ω∏ˆ Æ¡˘Ω¯÷∆¬Î£¨◊Ó∫Û“™∂‡“ª∏ˆ'/0'
    char* tmp = (char*)malloc(vLen*2+1);
    memset(tmp,0,vLen*2+1);
    
    int tmp2;
    for (int i=0;i<vLen;i++)
    {
        tmp2 = (int)(vByte[i])/16;
        tmp[i*2] = (char)(tmp2+((tmp2>9)?'A'-10:'0'));
        tmp2 = (int)(vByte[i])%16;
        tmp[i*2+1] = (char)(tmp2+((tmp2>9)?'A'-10:'0'));
    }
    
    return tmp;
}

// 把十六进制字符串，转为字节码，每两个十六进制字符作为一个字节
unsigned char* HexToByte(const char* szHex,int nLen)
{
    if(!szHex)
        return NULL;
    
    int iLen = nLen;
    
    if (nLen <= 0 || 0 != nLen%2)
        return NULL;
    
    //unsigned char* pbBuf = new unsigned char[iLen/2+1];  //  ˝æ›ª∫≥Â«¯
    unsigned char* pbBuf = (unsigned char*)malloc(iLen/2+1);
    
    memset(pbBuf,0,iLen/2+1);
    
    int tmp1, tmp2;
    for (int i = 0;i< iLen/2;i ++)
    {
        tmp1 = (int)szHex[i*2] - (((int)szHex[i*2] >= 'A')?'A'-10:'0');
        
        if(tmp1 >= 16)
            return NULL;
        
        tmp2 = (int)szHex[i*2+1] - (((int)szHex[i*2+1] >= 'A')?'A'-10:'0');
        
        if(tmp2 >= 16)
            return NULL;
        
        pbBuf[i] = (tmp1*16+tmp2);
    }
    
    return pbBuf;
}


+ (NSString *)swRc4EncryptWithSource:(NSString *)source rc4Key:(NSString *)rc4Key {
    //source 未json 字符串
    const char * a = Encrypt([source UTF8String], [rc4Key UTF8String], strlen([source UTF8String]), rc4Key.length);
    
    if (a == NULL) {
        
        return  @"";
    }
    
//    NSLog(@"加密后的字符串%@", [NSString stringWithCString:a encoding:NSUTF8StringEncoding]);
    
    return [NSString stringWithCString:a encoding:NSUTF8StringEncoding];
}

+ (NSString *)swRc4DecryptWithSource:(NSString *)source rc4Key:(NSString *)rc4Key {
    const char * a = Decrypt([source UTF8String], [rc4Key UTF8String], strlen([source UTF8String]), rc4Key.length);
    if (a == NULL) {
        
        return  @"";
    }
    return [NSString stringWithCString:a encoding:NSUTF8StringEncoding];
}

@end

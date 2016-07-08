//
//  JJKeychain.m
//  Keychain_Joker
//
//  Created by pengshuai on 15/5/14.
//  Copyright (c) 2015年 Joker. All rights reserved.
//

#import "JJKeychain.h"

@implementation JJKeychain

/**
 *  更新服务数据(保存/更新)
 *
 *  @param serviceKey 服务Key
 *  @param value      服务值
 */
+(void)updateServiceKey:(NSString*)serviceKey value:(id)value{

    NSMutableDictionary *keychainQuery = [self getKeychainQuery:serviceKey];
    //Delete old item before add new item
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:value] forKey:(__bridge id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL);

}
/**
 *  通过服务Key获取服务value
 *
 *  @param serviceKey 服务Key
 */
+(id)valueWithServiceKey:(NSString*)serviceKey{

    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:serviceKey];
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [keychainQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", serviceKey, e);
        } @finally {
        }
    }
    if (keyData){
        CFRelease(keyData);
    }
    
    return ret;


}
/**
 *  通过服务Key删除服务value
 *
 *  @param serviceKey 服务Key
 */
+(void)deleteWithServiceKey:(NSString*)serviceKey{

    NSMutableDictionary *keychainQuery = [self getKeychainQuery:serviceKey];
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
}

#pragma mark -
#pragma mark - Private Methods
+ (NSMutableDictionary *)getKeychainQuery:(NSString *)serviceKey {
    
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge id)kSecClassGenericPassword,(__bridge id)kSecClass,
            serviceKey, (__bridge id)kSecAttrService,
            serviceKey, (__bridge id)kSecAttrAccount,
            (__bridge id)kSecAttrAccessibleAfterFirstUnlock,(__bridge id)kSecAttrAccessible,
            nil];
}

@end











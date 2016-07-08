//
//  VerifyUitl.m
//  Template_Joker
//
//  Created by  李知洋 on 16/1/19.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "VerifyUitl.h"

@implementation VerifyUitl

/*手机号码验证 MODIFIED BY HELENSONG*/
+(BOOL) isValidateMobile:(NSString *)mobile
{
    if (![mobile length]) {
        return NO;
    }
     NSString * regex     = @"^(13\\d|14[57]|15[^4,\\D]|17[678]|18\\d)\\d{8}|170[059]\\d{7}";
    NSPredicate * pred   = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject: mobile];

}
/**
 * 身份证号码验证
 */
+(BOOL) isValidateIDcard:(NSString * )  idCard
{
    
    if (![idCard length]) {
        return NO;
    }
    NSString * regex     = @"^\\d{15}|\\d{17}[0-9Xx]";
    NSPredicate * pred   = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject: idCard];

}


@end

//
//  VerifyUitl.h
//  Template_Joker
//
//  Created by  李知洋 on 16/1/19.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VerifyUitl : NSObject




/*手机号码验证 MODIFIED BY HELENSONG*/
+(BOOL) isValidateMobile:(NSString *)mobile;


/**
 * 校验身份证号码
 */
+(BOOL) isValidateIDcard:(NSString * )  idCard;


@end

//
//  PublicInputInformationViewController.h
//  Template_Joker
//
//  Created by  李知洋 on 16/1/13.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  AuthenticationViewController;

typedef  NS_ENUM(NSInteger , PublicInputInformationType){
    PublicInputInformationTypeTruthName , ///真实姓名
    PublicInputInformationTypeIDCard,  //身份证号码
    PublicInputInformationTypeCompetencyCode,  //  资格号码
    PublicInputInformationTypeBankCard, //银行账号
    PublicInputInformationTypeNickName  // 昵称
};

@protocol  PublicInputInformationViewDelegate  <NSObject>

-(void) callBackText:(NSString * )  text  type:(PublicInputInformationType ) type;

@end

/**
 *  公共view
 */
@interface PublicInputInformationViewController : JJBaseController

/**
 *  状态值
 */
@property (nonatomic , assign) PublicInputInformationType  publicInputInformationType;

@property (nonatomic , copy) NSString * text;

@property (nonatomic , weak) id  delegate;


@end

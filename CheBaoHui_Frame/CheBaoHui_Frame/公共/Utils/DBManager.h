//
//  DBManager.h
//  Template_Joker
//
//  Created by  李知洋 on 16/1/20.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Individual,DataModel,ImageDataModel,ImageData;

@interface DBManager : NSObject


+(DBManager * ) sharedInstance;


/**
 *  删除数据库
 */
-(void) deleteDataBase;

//添加
-(void)  addIndividual:(NSString *)phoneNumber   password:(NSString * ) password  data:(DataModel * )data;




//删除
-(void) deleteIndividual;
//查询
-(Individual * )  selectIndividual;

//修改
-(void)  updateIndividual:(NSString * ) phoneNumber   passwordNew:(NSString * ) passwordNew;


/**
 *
 *  修改昵称
 *  @param nickName     要修改的昵称
 *  @param phoneNumber  用来查询的参数
 */
-(void) updateNickName:(NSString * ) nickName   phoneNumber:(NSString * ) phoneNumber;

/**
 *  修改电话号码
 */
-(void) updatePhoneNumber:(NSString * ) phoneNumber   andId :(NSString * )individualId;

/**
 * 先保存主键id
 */
-(void) saveId:(NSString * )  identity;

/**
 * 增加图片
 */
-(void) addImageData:(ImageDataModel * ) imageData  phone:(NSString * ) phone;



/**
 * 在做退出的时候清空
 *清空所有数据
 */
-(void) deleteImageData ;
/**
 *查询出数据
 */
-(ImageData * ) selectImageData;




@end

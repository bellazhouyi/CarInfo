//
//  DBManager.m
//  Template_Joker
//
//  Created by  李知洋 on 16/1/20.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "DBManager.h"
#import "Individual.h"
#import "DataModel.h"
#import "ImageDataModel.h"
#import "ImageData.h"

@interface DBManager()

@end


@implementation DBManager

static  DBManager *  sharedSingleton = nil;


+(DBManager * ) sharedInstance
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedSingleton = [[DBManager alloc] init];
    });
    
    return sharedSingleton;
}

/**
 *  删除
 */
-(void)deleteDataBase
{
    
}

/**
 *  保存
 *
 *  @param phoneNumber  电话号码
 *  @param verifyNumber 验证码
 *  @param password     密码
 */
-(void)  addIndividual:(NSString *)phoneNumber   password:(NSString * ) password  data:(DataModel * )data
{
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Individual" inManagedObjectContext:APPDELEGATE.managedObjectContext];
    
    
    Individual  * individual = [[Individual alloc]initWithEntity:entity insertIntoManagedObjectContext:APPDELEGATE.managedObjectContext];;
    
    individual.phoneNumber =  phoneNumber;
    individual.validateMsg =   data.ValidateMsg;
    individual.mobilePhone =  data.MobilePhone;
    individual.photoUrl =  data.PhotoUrl;
    individual.individualId =  data.Id;
    individual.nickName = data.NickName;
    individual.name =  data.Name;
    individual.areaName =  data.AreaName;
    individual.password = password;
    individual.status = data.Status;
    individual.statusName = data.StatusName;
    individual.idCardNoPhoto1  = data.IdCardNoPhoto1;
    individual.idCardNoPhoto2 = data.IdCardNoPhoto2;
    individual.idCardNoPhoto1Url = data.IdCardNoPhoto1Url;
    individual.idCardNoPhoto2Url = data.IdCardNoPhoto2Url;
    individual.qCertificatePhoto = data.QCertificatePhoto;
    individual.qCertificatePhotoUrl = data.QCertificatePhotoUrl;
    [APPDELEGATE saveContext];
}


/**
 *  删除
 */
-(void) deleteIndividual
{
    //查询
    NSFetchRequest *  request = [NSFetchRequest  fetchRequestWithEntityName:@"Individual"];
    //4.执行请求
    NSError * error  =  nil;
    
    NSArray *individuals = [APPDELEGATE.managedObjectContext executeFetchRequest: request error:&error];
   
    if(error){
        NSLog(@"%@",error);
    }
    /**
     *遍历出数据 删除
     */
    if(individuals.count  !=0){
        for(Individual * individual  in individuals  ){
            //删除
            [APPDELEGATE.managedObjectContext deleteObject:individual];
        }
    }
    [APPDELEGATE saveContext];
}


/**
 *
 * 查询
 *  @return Individual
 */
-(Individual *)selectIndividual
{
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Individual"];
    NSError * error = nil;
    NSArray *  individuals = [APPDELEGATE.managedObjectContext  executeFetchRequest: request error:&error];
    if(error){
        NSLog(@"%@",error);
    }
    if(individuals.count !=0){
        Individual * individual=  [individuals lastObject];
        return  individual;
    }
    return  nil;
}


-(void)  updateIndividual:(NSString * ) phoneNumber   passwordNew:(NSString * ) passwordNew
{
    NSFetchRequest * request = [NSFetchRequest  fetchRequestWithEntityName:@"Individual"];
    //查找
    NSPredicate *  pre  = [NSPredicate  predicateWithFormat: @"phoneNumber=%@",phoneNumber];
    
    request.predicate = pre;
    //执行
    NSArray *  individuals = [APPDELEGATE.managedObjectContext  executeFetchRequest:request  error:nil];
    for(Individual * indiv in   individuals){
        indiv.password = passwordNew;
    }
    [APPDELEGATE saveContext];
}


/**
 * 修改
 */
-(void) updatePhoneNumber:(NSString *)phoneNumber andId:(NSString *)individualId
{
    
    NSFetchRequest *  request = [NSFetchRequest fetchRequestWithEntityName:@"Individual"];
    //查找
    NSPredicate * pre = [NSPredicate  predicateWithFormat:@"individualId=%@",individualId];
    
    request.predicate = pre;
    
    NSArray * individuals = [APPDELEGATE.managedObjectContext  executeFetchRequest: request error:nil];
    
    for(Individual * indiv in   individuals){
        indiv.phoneNumber = phoneNumber;
    }

    [APPDELEGATE saveContext];
    
}

-(void) updateNickName:(NSString * ) nickName   phoneNumber:(NSString * ) phoneNumber
{
    
    NSFetchRequest *  request = [NSFetchRequest fetchRequestWithEntityName:@"Individual"];
    //查找
    NSPredicate * pre = [NSPredicate  predicateWithFormat:@"phoneNumber=%@",phoneNumber];
    
    request.predicate = pre;
    
    NSArray * individuals = [APPDELEGATE.managedObjectContext  executeFetchRequest: request error:nil];
    
    for(Individual * indiv in   individuals){
        indiv.nickName = nickName;
    }
    
    [APPDELEGATE saveContext];
}

/**
 *  保存
 *
 *  @param identity
 */
#pragma mark - 保存
-(void) saveId:(NSString *)identity
{
    ImageData  *  imageData = [NSEntityDescription insertNewObjectForEntityForName:@"ImageData" inManagedObjectContext:APPDELEGATE.managedObjectContext];
    imageData.identityID = identity;
    NSError *  error   = nil;
    [APPDELEGATE saveContext];
    if(error){
        NSLog(@"%@",error);
    }
}

/**
 * 增加图片
 */
#pragma mark - 增加图片
-(void) addImageData:(ImageDataModel * ) imageData  phone:(NSString * ) phone
{
    NSFetchRequest * request = [NSFetchRequest  fetchRequestWithEntityName:@"ImageData"];
    //查找
    NSPredicate *  pre  = [NSPredicate  predicateWithFormat: @"identityID=%@",phone];
    
    request.predicate = pre;
    
    NSArray * imageDatas = [APPDELEGATE.managedObjectContext  executeFetchRequest: request error:nil];
    for(ImageData * image in   imageDatas){
        if(imageData.identityCardFront ){
            image.identityCardFront = imageData.identityCardFront;
            image.identityCardFrontId = imageData.identityCardFrontId;
            
        }
        
        if(imageData.identityCardVerso){
            image.identityCardVerso = imageData.identityCardVerso;
            image.identityCardVersoId = imageData.identityCardVersoId;
            
        }
    
        if(imageData.competencyPage){
            image.competencyPage = imageData.competencyPage;
            image.competencyPageId = imageData.competencyPageId;
        }
    }
     [APPDELEGATE saveContext];
}


/**
 *  清空
 */
#pragma mark - 清空
-(void) deleteImageData
{
    //查询
    NSFetchRequest *  request = [NSFetchRequest  fetchRequestWithEntityName:@"ImageData"];
    //4.执行请求
    NSError * error  =  nil;
    
    NSArray * imageDatas = [APPDELEGATE.managedObjectContext executeFetchRequest: request error:&error];
    
    if(error){
        NSLog(@"%@",error);
    }
    /**
     *遍历出数据 删除
     */
    if(imageDatas.count  !=0){
        for(ImageData *imageData  in imageDatas  ){
            //删除
            [APPDELEGATE.managedObjectContext deleteObject:imageData];
        }
    }

    [APPDELEGATE saveContext];
    
}

/**
 *查询数据
 */
#pragma mark - 查询数据
-(ImageData *)selectImageData
{
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"ImageData"];
    NSError * error = nil;
    NSArray *  imageDatas = [APPDELEGATE.managedObjectContext  executeFetchRequest: request error:&error];
    if(error){
        NSLog(@"%@",error);
    }
    
    if(imageDatas.count !=0){
       ImageData * imagedata =  [imageDatas lastObject];
        return  imagedata;
    }
    return  nil;
}

@end

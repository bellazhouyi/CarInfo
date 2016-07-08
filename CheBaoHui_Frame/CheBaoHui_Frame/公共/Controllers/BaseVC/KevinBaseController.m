//
//  JKViewController.m
//  Template_Joker
//
//  Created by  李知洋 on 16/1/22.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "KevinBaseController.h"
#import "UploadClient.h"
#import "UpLoadFile.h"
#import "ResultModel.h"
#import "DataModel.h"
#import "UIImage+Extension.h"

@interface KevinBaseController ()<UIAlertViewDelegate,UIImagePickerControllerDelegate>

@end

@implementation KevinBaseController



#pragma mark -- 关于牌照/相册 公用
-(void)callCameraOrPhotoLibary{
    
    UIAlertController * alertContrller = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertContrller addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        /**
         * 执行拍照
         */
        UIImagePickerController *imagePicker = [UIImagePickerController new];
        if ([UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = sourceType;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }else{
            NSLog(@"不支持照相机");
            [super showToastHUD:@"不支持相机" hideTime:0.4];
        }
        
    }]];
    
    [alertContrller  addAction:[UIAlertAction  actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePicker = [UIImagePickerController new];
        //从相册选取相片
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
            
            imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
           
            imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:imagePicker.sourceType];
        }
        
        imagePicker.delegate = self;
        
        imagePicker.allowsEditing = NO;
        
        [self presentViewController:imagePicker animated:YES completion:nil];
    }]];
    
    [alertContrller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel  handler:^(UIAlertAction * _Nonnull action) {
        //用block
        if(self.removeKevinBaseView){
            self.removeKevinBaseView();
        }
        
    }]];
    
    [self presentViewController:alertContrller animated:YES completion:nil];
    
}


#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
  
    UIImage * image = (UIImage * ) [info objectForKey:UIImagePickerControllerOriginalImage];
    
    UploadModel * uploadModel = [[UploadModel alloc] init];
    uploadModel.fileName= @"fileName.png";
    uploadModel.fileData = UIImageJPEGRepresentation( image, 0.1);
    uploadModel.mimeType = @"image/jpeg";
    uploadModel.name = @"file";
    NSArray * fileArray = @[uploadModel];
    
    UpLoadFile *upLoadFileInstance = [UpLoadFile sharedUpLoadFile];
    
    //调用 UpLoadFile 上传文件接口
    [upLoadFileInstance UpLoadFileWithType:self.baseType andfileArray:fileArray];
    
    /**
     *  如果头像类型 就对头像进行压缩
     */
    if(self.baseType == KevinBaseTypePortrait){
        image = [image imageByScalingAndCroppingForSize:CGSizeMake(HEADPORTAIT_WIDTH, HEADPORTAIT_HEIGHT)];
    }
    
    //上传成功
    upLoadFileInstance.passSuccessObjectOfUpLoadFile = ^(NSString *msg,ResultModel *responseData){
        /**
         *  得到data模型,  获取里面的id
         */
        DataModel * dataModel= [responseData data];
        
        //执行选中照片之后的操作
        [picker  dismissViewControllerAnimated:YES completion:^{
            
            if(self.imageFromType == ImageFromTypeAuthentication){//图片来自认证
                
                //把照片通过代理的方式发送
                if([self.delegate  respondsToSelector:@selector(callback:type:baseType:photoId:)]){
                    //通过代理吧图片返回
                    [self.delegate  callback:image type:self.photoType  baseType:self.baseType  photoId: dataModel.Id];
                }
            }else  if (self.imageFromType == ImageFromTypePortrait){  //图片来自上传头像
                //把照片通过代理的方式发送
                if([self.delegate  respondsToSelector:@selector(callback:type:baseType:photoId:)]){
                    //通过代理吧图片返回
                    [self.delegate  callback:image type:self.photoType  baseType:self.baseType  photoId: dataModel.Id];
                }
            } else if(self.imageFromType == ImageFromTypeConfirmList){ //图片来自确认保单
                /*
                 保单确认
                 */
                if(self.carOwnerWithComplainateType == CarOwnerType){
                    if(self.confirmListCallBlock){
                        /*
                         确认保单时候  区分  是被保人即车主 还是 投保人即被保人
                         url:图片的url
                         type: 是车主还是被保人
                         photoType:证件反面和正面
                         photoId: 相册的id
                         */
                        self.confirmListCallBlock(dataModel.Url,self.carOwnerWithComplainateType,self.photoType, dataModel.Id);
                        
                    }
                    return;
                }else if(self.carOwnerWithComplainateType == ComplainantType){
                    if(self.confirmListCallBlock){
                        /*
                         确认保单时候  区分  是被保人即车主 还是 投保人即被保人
                         url:图片的url
                         type: 是车主还是被保人
                         photoType:证件反面和正面
                         photoId: 相册的id
                         */
                        self.confirmListCallBlock(dataModel.Url,self.carOwnerWithComplainateType,self.photoType, dataModel.Id);
                    }
                    return;
                }
                
            }else if ( self.imageFromType == ImageFromTypeAddCar){ //图片来自车辆信息添加
                //身份证类型 代理
                if(self.baseType == KevinBaseTypeIDCard){
                    if([self.delegate  respondsToSelector:@selector(idCardCallback:type:photoId:)]){
                        //回传 图片 和 图片正反的type
                        [self.delegate idCardCallback: dataModel.Url type:self.prTtype photoId:dataModel.Id];
                    }
                    return ;
                }
                
                //行驶证类型 代理
                if(self.baseType==KevinBaseTypeDrivingLicense){
                    if([self.delegate  respondsToSelector:@selector(dlCallback:type:photoId:)]){
                        [self.delegate  dlCallback:dataModel.Url type:self.prTtype photoId:dataModel.Id];
                    }
                    return;
                }
            }  else if(self.imageFromType == ImageFromTypeCarInfo){
                if(self.addCarInfoCallBlock){
                    
                    self.addCarInfoCallBlock(dataModel.Url, self.prTtype , self.baseType , dataModel.Id);
                }
                
                return;
            }
            
        }];

    };
    
    
    //上传失败
    upLoadFileInstance.passFailureOfUpLoadFile = ^(NSString *msg,MessageStatus messageStatus){
        [super showFailureHUD:FailureToUpLoadFile hideTime:ToastHideTime];
    };
   
    
    
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    
    
    [picker dismissViewControllerAnimated:YES  completion:^{
        //用block
        if(self.removeKevinBaseView){
            self.removeKevinBaseView();
        }
    }];
}




@end

//
//  UpLoadFile.m
//  CheBaoHui_Frame
//
//  Created by Bella on 16/3/17.
//  Copyright © 2016年 huirui.zhouyi. All rights reserved.
//

#import "UpLoadFile.h"
#import "UploadClient.h"
@class ResultModel;

@interface UpLoadFile ()

@property(nonatomic,strong) UploadClient *client;

@end

static UpLoadFile *upLoadFileInstance = nil;
@implementation UpLoadFile

#pragma mark - 单例
+(UpLoadFile *)sharedUpLoadFile{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        upLoadFileInstance = [UpLoadFile new];
    });
    
    return upLoadFileInstance;
}


#pragma mark - 上传文件
/**
 *  证件类型,1-头像，2-身份证，3-资格证，4-行驶证，5-车辆信息，6-其他
 */
-(void)UpLoadFileWithType:(KevinBaseType )type andfileArray:(NSArray *)fileArray{
    NSString *relativePath = [NSString stringWithFormat:@"%@/UpLoadFile?type=%@",RELATIVE_PATH,@(type)];
    
    [self.client uploadFileWithRelativePath:relativePath baseUrl:BASE_URL parameters:nil fileArray:fileArray progress:nil successBlock:^(NSString *msg, ResultModel * responseData) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.passSuccessObjectOfUpLoadFile(msg,responseData);
        });
    } failureBlock:^(NSString *msg, MessageStatus messageStatus) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.passFailureOfUpLoadFile(msg,messageStatus);
        });
    }];
}


#pragma mark - 懒加载
-(UploadClient *)client{
    if (nil == _client) {
        _client = [UploadClient sharedInstance];
    }
    return _client;
}


@end

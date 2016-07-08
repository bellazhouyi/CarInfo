//
//  JJHttpClient.h
//  Demo_joker
//
//  Created by pengshuai on 15/5/29.
//  Copyright (c) 2015年 Joker. All rights reserved.
//


/**
 *  消息提示类型
 */
typedef NS_ENUM(NSInteger, MessageStatus){
    /**
     *  正常
     */
    Message_Stauts_Normal = 0,
    /**
     *  取消
     */
    Message_Stauts_Cancel = -999,
    /**
     *  没有数据
     */
    Message_Stauts_No_Data = -1000,
    /**
     *  没有网络
     */
    Message_Stauts_No_Network = -1001,
    /**
     *  错误
     */
    Message_Stauts_Error = -1002,
    /**
     *  失败
     */
    Message_Stauts_Failure = -1003,
    
    
};

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

/**
 *  请求成功回调方法
 *
 *  @param msg         描述
 *  @param requestData 响应数据
 */
typedef void (^JJResponseDataSuccessBlock)(NSString *msg,id responseData);

/**
 *  请求成功回调方法
 *
 *  @param msg             描述
 *  @param responseData    当前返回的数组数据
 *  @param hasNext         是否还有数据-(YES:有数据;NO:没有数据)
 */
typedef void (^JJResponseDataSuccessHasNextBlock)(NSString *msg,id responseData,BOOL hasNext);

/**
 *  请求失败回调方法
 *
 *  @param errorCode 错误状态码
 *  @param msg       错误描述
 *  @param error     错误信息
 */
typedef void (^JJResponseDataFailureBlock)(NSString *msg,MessageStatus messageStatus);

/**
 *  上传文件对象
 */
@interface UploadModel : NSObject

/**
 *  服务器name
 */
@property (nonatomic,strong) NSString *name;
/**
 *  文件名称
 */
@property (nonatomic,strong) NSString *fileName;
/**
 *  文件类型
 */
@property (nonatomic,strong) NSString *mimeType;
/**
 *  文件Data数据
 */
@property (nonatomic,strong) NSData *fileData;

@end
/**
 *  网络请求管理类(必须重写该子类)
 *  必须通过子类重写以下方法才会返回数据
 *      handleResponseObject:successBlock:failureBlock:
 *      handleRequestFailure:failureBlock:
 */

@interface JJHttpClient : NSObject

#pragma mark -
#pragma mark - NSURLSession
/**
 *  POST请求
 *
 *  @param relativePath 请求相对路径地址
 *  @param baseUrl      服务器地址
 *  @param parameters   请求参数
 *  @param successBlock 请求成功回调方法
 *  @param failureBlock 请求失败回调方法
 *
 *  @return NSURLSessionDataTask
 */
- (NSURLSessionDataTask*)requestPOSTWithRelativePath:(NSString *)relativePath
                            baseUrl:(NSString*)baseUrl
                         parameters:(NSDictionary *)parameters
                       successBlock:(JJResponseDataSuccessBlock)successBlock
                       failureBlock:(JJResponseDataFailureBlock)failureBlock;


/**
 *  GET请求
 *
 *  @param relativePath 请求相对路径地址
 *  @param baseUrl      服务器地址
 *  @param parameters   请求参数
 *  @param successBlock 请求成功回调方法
 *  @param failureBlock 请求失败回调方法
 *
 *  @return NSURLSessionDataTask
 */
- (NSURLSessionDataTask*)requestGETWithRelativePath:(NSString *)relativePath
                           baseUrl:(NSString*)baseUrl
                        parameters:(NSDictionary *)parameters
                      successBlock:(JJResponseDataSuccessBlock)successBlock
                      failureBlock:(JJResponseDataFailureBlock)failureBlock;


/**
 *  下载文件
 *
 *  @param downloadPath 文件下载路径
 *  @param savePath     文件保存路径
 *  @param progress     NSProgress 下载进度
 *  @param successBlock 下载成功回调方法
 *  @param failureBlock 下载失败回调方法
 *
 *  @return NSURLSessionDownloadTask
 */
-(NSURLSessionDownloadTask*)downloadFileWithPath:(NSString*)downloadPath
                                        savePath:(NSURL*)savePath
                                        progress:(NSProgress**)progress
                                    successBlock:(JJResponseDataSuccessBlock)successBlock
                                    failureBlock:(JJResponseDataFailureBlock)failureBlock;



/**
 *  上传文件(一个或多个)
 *
 *  @param relativePath 上传服务器地址
 *  @param parameters   请求参数
 *  @param fileArray    UploadModel 数组对象
 *  @param progress     NSProgress 上传进度
 *  @param successBlock 上传成功回调方法
 *  @param failureBlock 上传失败回调方法
 *
 *  @return NSURLSessionUploadTask
 */

-(NSURLSessionUploadTask*)uploadFileWithRelativePath:(NSString *)relativePath
                                             baseUrl:(NSString*)baseUrl
                                          parameters:(NSDictionary *)parameters
                                           fileArray:(NSArray*)fileArray
                                            progress:(NSProgress**)progress
                                        successBlock:(JJResponseDataSuccessBlock)successBlock
                                        failureBlock:(JJResponseDataFailureBlock)failureBlock;


#pragma mark -
#pragma mark - 子类通过重写该方法实现处理返回数据
/**
 *  为所有请求设置http headers(默认传递了版本号和当前ios)
 *
 *  @return NSDictionary
 */
+(NSDictionary*)sessionConfigurationHTTPAdditionalHeaders;

/**
 *  设置请求超时时间(默认30s)
 *
 *  @return 请求超时时间
 */
+(CGFloat)httpTimeoutInterval;

/**
 *  处理请求参数(对参数加密等,默认没有做任何处理)
 *
 *  @param Parameters 请求参数
 *
 *  @return 处理后参数
 */
+(NSDictionary*)handleRequestParameters:(NSDictionary*)parameters;

/**
 *  处理请求成功后返回的结果
 *
 *  @param responseObject 请求响应数据
 *  @param successBlock   如果返回的数据正常,执行方法
 *  @param failureBlock   如果返回的数据异常,执行方法
 */
-(void)handleResponseObject:(id)responseObject
               successBlock:(JJResponseDataSuccessBlock)successBlock
               failureBlock:(JJResponseDataFailureBlock)failureBlock;

/**
 *  处理请求发送失败
 *
 *  @param error        错误信息
 *  @param failureBlock 请求失败执行的方法
 */
-(void)handleRequestFailure:(NSError*)error failureBlock:(JJResponseDataFailureBlock)failureBlock;

@end













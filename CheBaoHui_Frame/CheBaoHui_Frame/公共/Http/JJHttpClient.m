//
//  JJHttpClient.m
//  Demo_joker
//
//  Created by pengshuai on 15/5/29.
//  Copyright (c) 2015年 Joker. All rights reserved.
//

#ifdef DEBUG
#define HTTP_NSLog(format, ...) NSLog((format), ## __VA_ARGS__)
#else
#define HTTP_NSLog(format, ...)
#endif
#import "JJHttpClient.h"

@implementation UploadModel

@end

@implementation JJHttpClient

#pragma mark -
#pragma mark - Public Methods
-(instancetype)init{
    if (self = [super init]) {
        
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        /*================缓存策略===============*/
        /*
         1、NSURLRequestUseProtocolCachePolicy:默认的cache policy，使用Protocol协议定义。
         2、NSURLRequestReloadIgnoringCacheData:忽略缓存直接从原始地址下载。
         3、NSURLRequestReturnCacheDataElseLoad:只有在cache中不存在data时才从原始地址下载。
         4、NSURLRequestReturnCacheDataDontLoad:只使用cache数据，如果不存在cache，请求失败；用于没有建立网络连接离线模式；
         5、NSURLRequestReloadIgnoringLocalAndRemoteCacheData:忽略本地和远程的缓存数据，直接从原始地址下载，与NSURLRequestReloadIgnoringCacheData类似。
         6、NSURLRequestReloadRevalidatingCacheData:验证本地数据与远程数据是否相同，如果不同则下载远程数据，否则使用本地数据。
         */
        [sessionConfiguration setRequestCachePolicy:NSURLRequestUseProtocolCachePolicy];
        //设置我们的缓存大小 其中内存缓存大小设置10M,磁盘缓存100M
        NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:10 * 1024 * 1024
                                                          diskCapacity:50 * 1024 * 1024
                                                              diskPath:nil];
        
        [sessionConfiguration setURLCache:cache];

        //设置请求超时时间
        sessionConfiguration.timeoutIntervalForRequest = [[self class] httpTimeoutInterval];
        //设置请求headers
        sessionConfiguration.HTTPAdditionalHeaders = [[self class] sessionConfigurationHTTPAdditionalHeaders];
    }
    return self;
}

#pragma mark -
#pragma mark - Private Methods
/**
 *  @param baseUrl 服务器地址
 *
 *  @return AFHTTPSessionManager
 */
-(AFHTTPSessionManager*)__httpSessionManagerWithBaseUrl:(NSString*)baseUrl{
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseUrl] sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    //设置请求数据格式(默认二进制)
    //manager.requestSerializer = [AFHTTPRequestSerializer serializer];//(二进制)
    //manager.requestSerializer = [AFJSONRequestSerializer serializer];//(JSON)
    //manager.requestSerializer = [AFPropertyListRequestSerializer serializer];//(plist)
    
    //设置响应的数据格式(默认JSON);响应者的MIMEType不正确,就要修改acceptableContentTypes
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];//(二进制)
    //manager.responseSerializer = [AFJSONResponseSerializer serializer];//(JSON)
    //manager.responseSerializer = [AFPropertyListResponseSerializer serializer];//(plist)
    //manager.responseSerializer = [AFXMLParserResponseSerializer serializer];//(XML)
    //manager.responseSerializer = [AFImageResponseSerializer serializer];//(Image)
    //manager.responseSerializer = [AFCompoundResponseSerializer serializer];//(组合的)
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"application/json",
                                                         @"text/json",
                                                         @"text/javascript",
                                                         @"text/html",
                                                         @"text/plain", nil];
    
    
    return manager;
}

#pragma mark -
#pragma mark - Public Methods
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
                       failureBlock:(JJResponseDataFailureBlock)failureBlock{

    NSDictionary *params = [[self class] handleRequestParameters:parameters];
    HTTP_NSLog(@"【%@%@】【RequestParameters】:%@",baseUrl,relativePath,parameters);
    AFHTTPSessionManager *manager = [self __httpSessionManagerWithBaseUrl:baseUrl];
    NSURLSessionDataTask *dataTask = [manager POST:relativePath parameters:params success:^(NSURLSessionDataTask *task, id responseObject)
                                      
    {
        [self handleResponseObject:responseObject successBlock:successBlock failureBlock:failureBlock];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self handleRequestFailure:error failureBlock:failureBlock];
        
    }];
    return dataTask;
}



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
                      failureBlock:(JJResponseDataFailureBlock)failureBlock{

    NSDictionary *params = [[self class] handleRequestParameters:parameters];
    HTTP_NSLog(@"【RequestParameters】:%@",parameters);
    //打印请求url,方便调试
#ifdef DEBUG
    [self printRequest:BASE_URL relativePath:relativePath rarameters:parameters];
#endif
    
    
    AFHTTPSessionManager *manager = [self __httpSessionManagerWithBaseUrl:baseUrl];

    NSURLSessionDataTask *dataTask = [manager GET:relativePath parameters:params success:^(NSURLSessionDataTask *task, id responseObject)
    {
        [self handleResponseObject:responseObject successBlock:successBlock failureBlock:failureBlock];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self handleRequestFailure:error failureBlock:failureBlock];
    }];
    
    return dataTask;
    
}

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
                                    failureBlock:(JJResponseDataFailureBlock)failureBlock{
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:sessionConfiguration];
    
    NSString *urlString = [downloadPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    //修改后
    NSURLSessionDownloadTask *dataTask_0 = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        return savePath;
                    
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (!error) {
            
            [self handleResponseObject:response successBlock:successBlock failureBlock:failureBlock];
            
        }else{
            
            [self handleRequestFailure:error failureBlock:failureBlock];
        }

    }] ;
    
    
    
    /*
    NSURLSessionDownloadTask *dataTask = [manager downloadTaskWithRequest:request progress:progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {

        return savePath;

    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        if (!error) {
            
            [self handleResponseObject:response successBlock:successBlock failureBlock:failureBlock];
            
        }else{
        
            [self handleRequestFailure:error failureBlock:failureBlock];
        }
        
    }];
     
     */
    return dataTask_0;
}


/**
 *  上传文件(一个或多个)
 *
 *  @param relativePath 上传服务器地址
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
                                        failureBlock:(JJResponseDataFailureBlock)failureBlock;{

    NSDictionary *params = [[self class] handleRequestParameters:parameters];
    HTTP_NSLog(@"fff%s-【RequestParameters】:%@",__FUNCTION__,parameters);
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer]
                                    multipartFormRequestWithMethod:@"POST"
                                    URLString:[BASE_URL stringByAppendingString:relativePath]
                                    parameters:params
                                    constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                    
    {
        for (UploadModel *model in fileArray) {
            
            [formData appendPartWithFileData:model.fileData
                                        name:model.name
                                    fileName:model.fileName
                                    mimeType:model.mimeType];
        }
    } error:nil];

    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [(AFHTTPResponseSerializer*)manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:
                                                                                      @"application/json",
                                                                                      @"text/json",
                                                                                      @"text/javascript",
                                                                                      @"text/html",
                                                                                      @"text/plain", nil]] ;
    
    //修改后
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request
                                                                       progress:^(NSProgress * _Nonnull downloadProgress) {
                                                                           
                                                                       }
                                                              completionHandler:^(NSURLResponse *response, id responseObject, NSError *error)
    {
        if (!error) {
            [self handleResponseObject:responseObject successBlock:successBlock failureBlock:failureBlock];
        } else {
            [self handleRequestFailure:error failureBlock:failureBlock];
        }
    }];
    
    [uploadTask resume];
    return uploadTask;
}

#pragma mark -
#pragma mark - 子类通过重写该方法实现处理返回数据
/**
 *  为所有请求设置http headers
 *
 *  @return NSDictionary
 */
+(NSDictionary*)sessionConfigurationHTTPAdditionalHeaders{
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];

    return @{@"source":@"ios",
             @"version":currentVersion};
}
/**
 *  设置请求超时时间(默认30s)
 *
 *  @return 请求超时时间
 */
+(CGFloat)httpTimeoutInterval{
    return 30.0f;
}

/**
 *  处理请求参数(对参数加密等)
 *
 *  @param Parameters 请求参数
 *
 *  @return 处理后参数
 */
+(NSDictionary*)handleRequestParameters:(NSDictionary*)parameters{
    return parameters;
}
/**
 *  处理请求成功后返回的结果
 *
 *  @param responseObject 请求响应数据
 *  @param successBlock   如果返回的数据正常,执行方法
 *  @param failureBlock   如果返回的数据异常,执行方法
 */
-(void)handleResponseObject:(id)responseObject
               successBlock:(JJResponseDataSuccessBlock)successBlock
               failureBlock:(JJResponseDataFailureBlock)failureBlock{

    HTTP_NSLog(@"【DEBUG-JJHttpClient-SUCCESS】:%@",responseObject);
    
}

/**
 *  处理请求发送失败
 *
 *  @param error        错误信息
 *  @param failureBlock 请求失败执行的方法
 */
-(void)handleRequestFailure:(NSError*)error failureBlock:(JJResponseDataFailureBlock)failureBlock{
    
    HTTP_NSLog(@"【DEBUG-JJHttpClient-ERROR】:%@",error);
}

-(void)printRequest:(NSString*)baseurl relativePath:(NSString *)relativePath rarameters:(NSDictionary*)parameters{

    NSMutableString *requestURL = [[NSMutableString alloc] initWithFormat:@"%@%@",BASE_URL,relativePath];
    
    for (NSString *key in parameters.allKeys) {
        NSString *value = parameters[key];
        [requestURL appendFormat:@"&%@=%@",key,value];
    }
    HTTP_NSLog(@"【%@】",requestURL);
}
@end





























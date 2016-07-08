//
//  UpLoadFile.h
//  CheBaoHui_Frame
//
//  Created by Bella on 16/3/17.
//  Copyright © 2016年 huirui.zhouyi. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - 定义 block
/**
 *  成功
 *
 *  @param message        <#message description#>
 *  @param responseObject <#responseObject description#>
 */
typedef void(^passSuccessObjectOfUpLoadFile)(NSString *message,id responseObject);

typedef void(^passFailureOfUpLoadFile)(NSString *msg, MessageStatus messageStatus);

@interface UpLoadFile : NSObject



#pragma mark - 声明 block
@property(nonatomic,copy) passSuccessObjectOfUpLoadFile passSuccessObjectOfUpLoadFile;
@property(nonatomic,copy) passFailureOfUpLoadFile passFailureOfUpLoadFile;

#pragma mark - 单例
+(UpLoadFile *)sharedUpLoadFile;

#pragma mark - 上传文件
-(void)UpLoadFileWithType:(KevinBaseType )type andfileArray:(NSArray *)fileArray;


@end

//
//  MineHeaderView.m
//  Template_Joker
//
//  Created by  李知洋 on 16/1/12.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "MineHeaderView.h"
#import "DBManager.h"
#import "Individual.h"
#import "ResultModel.h"
#import "DataModel.h"
#import "MJExtension.h"
#import "UIImage+Extension.h"
#import "RegisterViewController.h"

@interface MineHeaderView()
@property (weak, nonatomic) IBOutlet UIButton *headPortraitButton;
@property (weak, nonatomic) IBOutlet UILabel *nickName;

@property(nonatomic,strong) HTTPManagerOfMine *HTTPManagerInstance;

@end

@implementation MineHeaderView


#pragma mark - 初始化头视图
-(void) initMineHeaderView
{
    [self.headPortraitButton  setImage:[UIImage  imageNamed:@"header_image"] forState:UIControlStateNormal];
    self.headPortraitButton.layer.masksToBounds = YES;
    self.headPortraitButton.layer.cornerRadius =self.headPortraitButton.frame.size.width  / 2;
    
    DBManager *dbManager = [DBManager sharedInstance];
    Individual *  indivudual = [dbManager selectIndividual];
    
    //调用接口
    [self.HTTPManagerInstance GetBusinessUserByIdWithId:indivudual.individualId];
    
    __weak typeof(self) temp = self;
    //成功 获得数据
    _HTTPManagerInstance.passResponseObjectOfGetBusinessUserById = ^(id responseObject){
        ResultModel * result =  [ResultModel  mj_objectWithKeyValues: responseObject];
        DataModel *  data = [result data];
        
        if(data.PhotoUrl!=nil || data.NickName!=nil){
            NSURL * url = [NSURL  URLWithString: data.PhotoUrl];
            //下载图片
            [[SDWebImageManager  sharedManager] downloadImageWithURL: url  options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                UIImage * imageNew = [image imageByScalingAndCroppingForSize:CGSizeMake(HEADPORTAIT_WIDTH, HEADPORTAIT_HEIGHT)];
                [temp.headPortraitButton  setImage:  imageNew   forState:UIControlStateNormal];
            }];
            temp.nickName.text = data.NickName;
        }else{
            [temp.headPortraitButton  setImage:[UIImage  imageNamed:@"header_image"] forState:UIControlStateNormal];
            temp.nickName.text = @"请设置昵称";
        }
    };
    
    //失败
    _HTTPManagerInstance.passErrorOfGetBusinessUserById = ^(NSError *error){
        
    };
    
    
}


#pragma mark - 响应事件
-(void)addTarget:(id)target action:(SEL)action
{
    [self.headPortraitButton addTarget: target action:action forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - 懒加载
-(HTTPManagerOfMine *)HTTPManagerInstance{
    if (_HTTPManagerInstance == nil) {
        _HTTPManagerInstance = [HTTPManagerOfMine sharedHTTPManagerOfMine];
    }
    return _HTTPManagerInstance;
}


@end

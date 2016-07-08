//
//  InsurePayWayUIView.m
//  Template_Joker
//
//  Created by  李知洋 on 16/2/4.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "InsurePayWayUIView.h"


@interface  InsurePayWayUIView()

@property (weak, nonatomic) IBOutlet UIImageView *erWeiMaImgView;

@property (weak, nonatomic) IBOutlet UIButton *payWayButton;

- (IBAction)confirm:(UIButton *)sender;

- (IBAction)payWay:(UIButton *)sender;

@end

@implementation InsurePayWayUIView

////调用支付宝支付
//-(void)initInsurePayWayName:(NSString *)name orImage:(NSString *)image
//{
//    if(self.payType==PayWayTypeWeixinChat){//微信
//        self.payWayButton.titleLabel.text  =  name;
//    }else if(self.payType == PayWayTypeAlipay){ //支付宝
//        self.payWayButton.titleLabel.text =  name;
//    }
//}


//设置二维码地址
-(void)setErweimaUrl:(NSString *)erweimaUrl
{
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];

    [filter setDefaults];
    
    NSString *dataString = erweimaUrl;
    
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    
    [filter setValue:data forKey:@"inputMessage"];

    CIImage *outImg = [filter outputImage];
    
    CIImage *img = (CIImage *)[UIImage imageWithCIImage:outImg];
    
    self.erWeiMaImgView.image = (UIImage *)img;

}

//支付
- (IBAction)payWay:(UIButton *)sender {
    if([self.delegate  respondsToSelector:@selector(insurePayWayType:)]){
        [self.delegate  insurePayWayType:self.payType];
    }
}

//确定
- (IBAction)confirm:(UIButton *)sender {
    
    self.erWeiMaImgView.image = nil;
    if([self.delegate  respondsToSelector:@selector(insurePayWayCallBackColsePop)]){
        [self.delegate  insurePayWayCallBackColsePop];
    }
}

@end

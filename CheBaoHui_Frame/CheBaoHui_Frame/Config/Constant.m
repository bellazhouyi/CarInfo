
#import "Constant.h"

@implementation Constant

//http://192.168.1.222:8081
//http://api-service.hrnpfs.cn:8081
NSString * const BASE_URL = @"http://api-service.hrnpfs.cn:8081";

NSString * const RELATIVE_PATH = @"/api/Business";

NSString * const PRICE_PATH = @"/api/Policy";

NSString * const WEIXIN_PAY_UNIFIEDORDER = @"https://api.mch.weixin.qq.com/pay/unifiedorder";

NSInteger const kPAGE_SIZE = 10;

BOOL isShowWithInsurance = NO;

NSMutableDictionary *cntrId_AmountDict  ;

NSString * PathNameAboutGetCntr_ClInfo = @"";

@end

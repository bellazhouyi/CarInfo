
#import <Foundation/Foundation.h>

/**
 *  全局相关常量
 */
@interface Constant : NSObject

/**
 *  请求BASE_URL
 */
extern NSString * const BASE_URL;
/**
 *  相对路径
 */
extern NSString * const RELATIVE_PATH;

/**
 *  比价相对路径
 */
extern NSString * const PRICE_PATH;



/**
 *  分页数量
 */
extern NSInteger const kPAGE_SIZE;


/**
 *  全局变量,投保方案中cell上是否显示险种的详细
 */
extern BOOL isShowWithInsurance;

extern NSMutableDictionary *cntrId_AmountDict;


extern NSString * PathNameAboutGetCntr_ClInfo;


@end

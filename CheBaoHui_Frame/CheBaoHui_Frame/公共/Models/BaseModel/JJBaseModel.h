//
//  BaseModel.h
//
//  Created by pengshuai on 14/11/11.
//  Copyright (c) 2014年 pengshuai. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface JJBaseModel : MTLModel<MTLJSONSerializing>

/**
 *  MTLModel转化为Dictionary
 *
 *  @return Dictionary,当属性为nil时,为属性赋值为""
 */
-(NSDictionary*)toDictionary;

@end

//
//  InsureHolderModel.h
//  Template_Joker
//
//  Created by  李知洋 on 16/2/1.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  持有人模型
 */
@interface InsureHolderWithInsuredModel : NSObject

@property (nonatomic ,copy) NSString *  cust_id;

@property (nonatomic , copy) NSString *  name;

@property (nonatomic , copy)  NSString * bthday;

@property (nonatomic , copy) NSString * id_no;

@property (nonatomic , copy) NSString * mob1;

@property (nonatomic , copy)  NSString * sfz1_path;

@property (nonatomic, copy) NSString * sfz1_pathUrl;

@property(nonatomic ,copy)NSString *  sfz2_path;

@property (nonatomic , copy) NSString * sfz2_pathUrl;
      
@end

//
//  Area.h
//  CheBaoHui_Frame
//
//  Created by Bella on 16/3/16.
//  Copyright © 2016年 huirui.zhouyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Area : NSObject

@property(nonatomic,copy) NSString *AreaName;

@property(nonatomic,copy) NSString *ShortName;

@property(nonatomic,copy) NSString *PCode;

@property(nonatomic,copy) NSString *AreaCode;

@property(nonatomic,copy) NSString *SubArea;

/**

 {
	AreaName = 重庆市;
	ShortName = 渝;
	PCode = -1;
	AreaCode = 500000;
	SubArea = (
	{
	AreaName = 市辖区;
	ShortName = ;
	PCode = 500000;
	AreaCode = 500100;
	SubArea = (
	{
	AreaName = 万州区;
	ShortName = ;
	PCode = 500100;
	AreaCode = 500101;
	SubArea = (
 );
	Id = 2218;
 }
 ,
	{
	AreaName = 涪陵区;
	ShortName = ;
	PCode = 500100;
	AreaCode = 500102;
	SubArea = (
 );
	Id = 2219;
 }
 
 
 
 */

@end

//
//  JJTools.h
//  JJTools
//
//  Created by pengshuai on 15/3/24.
//  Copyright (c) 2015年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  回调方法
 */
typedef void (^JJCallbackResultBlock)(id object);

//! Project version number for JJTools.
FOUNDATION_EXPORT double JJToolsVersionNumber;

//! Project version string for JJTools.
FOUNDATION_EXPORT const unsigned char JJToolsVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <JJTools/PublicHeader.h>

/*!
 *  Foundation Additions
 */
#import "NSArray+Joker.h"
#import "NSDate+Joker.h"
#import "NSFileManager+Joker.h"
#import "NSMutableArray+Joker.h"
#import "NSString+Joker.h"
#import "NSData+Joker.h"
#import "JJKeychain.h"

/*!
 *  UIKit Additions
 */
#import "UIAlertView+Joker.h"
#import "UIButton+Joker.h"
#import "UIColor+Joker.h"
#import "UIDevice+Joker.h"
#import "UIFont+Joker.h"
#import "JJTextField.h"
#import "UIView+Joker.h"
#import "UIWebView+Joker.h"
#import "UIWindow+Joker.h"
#import "UILabel+Joker.h"
#import "UITableView+Joker.h"
#import "UIImage+Joker.h"

/*!
 *  UIKit Macro
 */
#import "UtilsMacro.h"

//
//  UITableView+Joker.m
//  CQFishForIOS
//
//  Created by pengshuai on 15/7/25.
//  Copyright (c) 2015年 Joker. All rights reserved.
//

#import "UITableView+Joker.h"

@implementation UITableView (Joker)


- (void)hiddenExtraCellLine{
    self.tableFooterView = [[UIView alloc]init];
}
@end

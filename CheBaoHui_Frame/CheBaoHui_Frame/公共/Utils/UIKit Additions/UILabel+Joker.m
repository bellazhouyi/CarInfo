//
//  UILabel+StringFrame.m
//  HighlyDynamic_PS
//
//  Created by pengshuai on 14/12/23.
//  Copyright (c) 2014年 pengshuai. All rights reserved.
//

#import "UILabel+Joker.h"

@implementation UILabel (Joker)

- (CGSize)boundingRectWithSize:(CGSize)size
{
    NSDictionary *attributes = @{NSFontAttributeName:self.font};
    
    CGSize retSize = [self.text boundingRectWithSize:size
                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attributes
                                             context:nil].size;
    
    return CGSizeMake(retSize.width+1, retSize.height+1);
}


@end

//
//  IdCardWithDrvingLicenseCell.m
//  Template_Joker
//
//  Created by  李知洋 on 16/2/20.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "IdCardWithDrvingLicenseCell.h"

@implementation IdCardWithDrvingLicenseCell

+ (instancetype)cellWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath withIdentifier:(NSString *)ID
{
    
    IdCardWithDrvingLicenseCell * cell = [tableView  dequeueReusableCellWithIdentifier:ID];
    if (nil == cell) {
        NSLog(@"111");
        cell = [[IdCardWithDrvingLicenseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;

}

-(void) setCornerRadius:(CGFloat)  cornerRadius  isToBounds:(BOOL) isToBounds labelText:(NSString *)labelText
{
    
    [self.positiveUIButton.layer setMasksToBounds:isToBounds];
    [self.positiveUIButton.layer  setCornerRadius:cornerRadius];
    [self.reverseButton.layer setMasksToBounds:isToBounds];
    [self.reverseButton.layer  setCornerRadius:cornerRadius];
    self.leftLabel.text = labelText;
    
}

@end

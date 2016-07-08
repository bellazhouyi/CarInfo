//
//  IdCardWithDrvingLicenseCell.h
//  Template_Joker
//
//  Created by  李知洋 on 16/2/20.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IdCardWithDrvingLicenseCell : UITableViewCell

/** 提供一个类方法，k快速创建 Cell */
+ (instancetype)cellWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath withIdentifier:(NSString *)ID;

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

@property (weak, nonatomic) IBOutlet UILabel * particularLabel;

/**
 *  正面
 */
@property (weak, nonatomic) IBOutlet UIButton *positiveUIButton;
/**
 *  反面
 */

@property (weak, nonatomic) IBOutlet UIButton *reverseButton;

//用来判断是身份证还是其他
@property (nonatomic , assign) NSInteger  flag;


-(void) setCornerRadius:(CGFloat)  cornerRadius  isToBounds:(BOOL) isToBounds labelText:(NSString *) labelText;



@end

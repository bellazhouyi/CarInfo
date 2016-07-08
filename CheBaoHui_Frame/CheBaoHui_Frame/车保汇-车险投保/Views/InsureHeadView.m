//
//  InsureHeadView.m
//  Template_Joker
//
//  Created by  李知洋 on 16/1/15.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "InsureHeadView.h"
#import "WarrantyViewCell.h"
#import "WarrantyModel.h"
#import "UIView+Extension.h"
#import "UITableView+FDTemplateLayoutCell.h"



static NSString * ID  = @"ID";

@interface  InsureHeadView()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *lineImageView;

@property (weak, nonatomic) IBOutlet UIView *warrantybgView;

/**
 *  保单状态的tableview
 */
@property (nonatomic , strong) IBOutlet UITableView * warantyStatusTableView;

@end

@implementation InsureHeadView

-(void) setData:(NSArray *)data
{
    _data = data;
    self.warantyStatusTableView.delegate = self;
    self.warantyStatusTableView.dataSource = self;
    self.warantyStatusTableView.scrollEnabled = NO;
    self.warantyStatusTableView.separatorStyle = NO;
    self.warantyStatusTableView.backgroundColor =ColorFromRGB(247, 243, 234) ;
    [self.warantyStatusTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.warrantybgView addSubview: self.warantyStatusTableView];
    self.warrantybgView.width = self.warantyStatusTableView.width;
    [self.warantyStatusTableView  reloadData];
    //得到cell个数*30的高度
    //self.warantyStatusTableView.height = 2* 30;
    // NSLog(@"%f",self.warantyStatusTableView.height);
    //CGFloat   height= self.height - (data.count * 30);
    self.height = data.count * 30+30;
}

#pragma  mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WarrantyViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    WarrantyModel * warranty = self.data[indexPath.row];
    if(cell == nil){
        cell = [[WarrantyViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.warranty = warranty;
    return  cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  30;
}






@end

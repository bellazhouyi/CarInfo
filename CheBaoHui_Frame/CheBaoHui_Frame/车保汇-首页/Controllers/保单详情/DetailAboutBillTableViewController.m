//
//  DetailAboutBillTableViewController.m
//  Template_Joker
//
//  Created by Bella on 16/1/15.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "DetailAboutBillTableViewController.h"

//引入投保方案模型头文件
#import "Insurance.h"

#import "TwoLabelCell.h"


@interface DetailAboutBillTableViewController ()

/**
 *  投保方案情况的暂存值
 */
@property(nonatomic,strong) NSArray *tempArrayAboutInsuranceInfo;

/**
 *  基本险的数组
 */
@property(nonatomic,strong) NSMutableArray *basicInsuranceArray;

/**
 *  附加险的数组
 */
@property(nonatomic,strong) NSMutableArray *extraInsuranceArray;

/**
 *  不计免赔的数组
 */
@property(nonatomic,strong) NSMutableArray *notDutyArray;

/**
 *  保单详细字典信息
 */
@property(nonatomic,strong) NSDictionary *noteInfo;

/**
 *  暂存之
 */
@property(nonatomic,strong) NSString *tempCntr_id;
@property(nonatomic,strong) NSString *tempCompanyName;
@property(nonatomic,assign) CGFloat tempTotalPrice;
@property(nonatomic,strong) NSString *tempPolicyHolder;
@property(nonatomic,strong) NSString *tempInsuredPerson;

@end

/**
 *  cell 重用标识符
 */
static NSString *cellIdentifier = @"cell";
static NSString *noColorAndTwoLabelIdentifier = @"noColorAndTwoLabelCell";
static NSString *colorAndTwoLabelIdentifier = @"colorTwoLabelCell";

@implementation DetailAboutBillTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    //注册cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"TwoLabelCell" bundle:nil] forCellReuseIdentifier:colorAndTwoLabelIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"TwoLabelCell" bundle:nil] forCellReuseIdentifier:noColorAndTwoLabelIdentifier];
    
    
    //禁止回弹
    self.tableView.bounces = NO;
    
}


#pragma mark -- 加载数据
-(void)loadData{
    
    //基本险数组
    for (Insurance *item in [self.tempArrayAboutInsuranceInfo objectAtIndex:0]) {
        if (YES == item.isSelectedInsuranceFlag) {
            [self.basicInsuranceArray addObject:item];
        }
    }
    //附加险数组
    for (Insurance *item in [self.tempArrayAboutInsuranceInfo objectAtIndex:1]) {
        if (YES == item.isSelectedInsuranceFlag) {
            [self.extraInsuranceArray addObject:item];
        }
    }
    
    
    //不计免赔数组
    for (NSArray *sonArray in self.tempArrayAboutInsuranceInfo) {
        for (Insurance *itemInsurance in sonArray) {
            if (YES == itemInsurance.notDutyFlag) {
                [self.notDutyArray addObject:itemInsurance];
            }
        }
    }
    
    //保单详细
    NSString *price = [NSString stringWithFormat:@"%.2f",self.tempTotalPrice];
    self.noteInfo = @{
                      //                      @"保单号":self.tempCntr_id,
                      @"保险金额":price,
                      @"保险公司":self.tempCompanyName,
                      };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (1 == section) {
        if (0 == self.basicInsuranceArray.count) {
            return 0;
        }else{
            return 1 + self.basicInsuranceArray.count;
        }
    }else if (2 == section){
        if (0 == self.extraInsuranceArray.count) {
            return 0;
        }else{
            return 1 + self.extraInsuranceArray.count;
        }
    }else if (3 == section){
        if (0 == self.notDutyArray.count) {
            return 0;
        }else{
            return 1 + self.notDutyArray.count;
        }
    }else{
        return 1 + [self.noteInfo allKeys].count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self customCellWithTableView:tableView andIndexPath:indexPath];
}

#pragma mark -- cell内容分配
-(UITableViewCell *)customCellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath{
    
    if (0 == indexPath.section) {
        if (0 == indexPath.row) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            cell.textLabel.text = @"保单信息";
            cell.textLabel.textColor = [UIColor blueColor];
            
            return cell;
        }else{
            TwoLabelCell *twoLabelCell = [tableView dequeueReusableCellWithIdentifier:noColorAndTwoLabelIdentifier forIndexPath:indexPath];
            
            NSInteger index = indexPath.row - 1;
            NSString *insuranceName = [NSString stringWithFormat:@"%@",[[self.noteInfo allKeys] objectAtIndex:index]];
            NSString *detail = [NSString stringWithFormat:@"%@",[[self.noteInfo allValues] objectAtIndex:index]];
            
            twoLabelCell.insuranceNameLabel.text = insuranceName;
            twoLabelCell.insurancePriceLabel.text = detail;
            twoLabelCell.insurancePriceLabel.backgroundColor = [UIColor whiteColor];
            twoLabelCell.insuranceNameLabel.backgroundColor = [UIColor whiteColor];
            twoLabelCell.insuranceNameLabel.textColor = [UIColor blackColor];
            twoLabelCell.insurancePriceLabel.textColor = [UIColor blackColor];
            
            return twoLabelCell;
        }
    }else if (1 == indexPath.section){
        if (0 == indexPath.row) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            cell.textLabel.text = @"基本险";
            cell.textLabel.textColor = [UIColor blueColor];
            
            return cell;
        }else{
            Insurance *insurance = [self.basicInsuranceArray objectAtIndex:(indexPath.row - 1)];
            TwoLabelCell *twoLabelCell = [tableView dequeueReusableCellWithIdentifier:colorAndTwoLabelIdentifier forIndexPath:indexPath];
            twoLabelCell.insuranceNameLabel.text = insurance.insuranceName;
            if (nil != insurance.InsurancePrice) {
                if ([insurance.insuranceName isEqualToString:@"乘客责任险"]) {
                    twoLabelCell.insurancePriceLabel.text = [NSString stringWithFormat:@"%@/万/座",insurance.InsurancePrice];
                }else{
                    twoLabelCell.insurancePriceLabel.text = [NSString stringWithFormat:@"%@/万",insurance.InsurancePrice];
                }
            }else{
                twoLabelCell.insurancePriceLabel.backgroundColor = [UIColor whiteColor];
            }
            
            return twoLabelCell;
        }
    }else if (2 == indexPath.section){
        if (0 == indexPath.row) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            cell.textLabel.text = @"附加险";
            cell.textLabel.textColor = [UIColor blueColor];
            
            return cell;
        }else{
            Insurance *insurance = [self.extraInsuranceArray objectAtIndex:(indexPath.row - 1)];
            TwoLabelCell *twoLabelCell = [tableView dequeueReusableCellWithIdentifier:colorAndTwoLabelIdentifier forIndexPath:indexPath];
            twoLabelCell.insuranceNameLabel.text = insurance.insuranceName;
            if (nil != insurance.InsurancePrice) {
                
                twoLabelCell.insurancePriceLabel.text = [NSString stringWithFormat:@"%@/万",insurance.InsurancePrice];
                
            }else{
                twoLabelCell.insurancePriceLabel.backgroundColor = [UIColor whiteColor];
            }
            
            return twoLabelCell;
        }
    }else{
        if (0 == indexPath.row) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            cell.textLabel.text = @"不计免赔";
            cell.textLabel.textColor = [UIColor blueColor];
            
            return cell;
        }else{
            Insurance *insurance = [self.notDutyArray objectAtIndex:(indexPath.row - 1)];
            TwoLabelCell *twoLabelCell = [tableView dequeueReusableCellWithIdentifier:colorAndTwoLabelIdentifier forIndexPath:indexPath];
            twoLabelCell.insuranceNameLabel.text = insurance.insuranceName;
            if (nil != insurance.InsurancePrice) {
                if ([insurance.insuranceName isEqualToString:@"乘客责任险"]) {
                    twoLabelCell.insurancePriceLabel.text = [NSString stringWithFormat:@"%@/万/座",insurance.InsurancePrice];
                }else{
                    twoLabelCell.insurancePriceLabel.text = [NSString stringWithFormat:@"%@/万",insurance.InsurancePrice];
                }
            }else{
                twoLabelCell.insurancePriceLabel.backgroundColor = [UIColor whiteColor];
            }
            
            return twoLabelCell;
        }
    }
}


#pragma mark -- 懒加载
-(NSMutableArray *)basicInsuranceArray{
    if (nil == _basicInsuranceArray) {
        _basicInsuranceArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _basicInsuranceArray;
}

-(NSMutableArray *)extraInsuranceArray{
    if (nil == _extraInsuranceArray) {
        _extraInsuranceArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _extraInsuranceArray;
}

-(NSMutableArray *)notDutyArray{
    if (nil == _notDutyArray) {
        _notDutyArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _notDutyArray;
}



#pragma mark -- 投保方案情况
-(void)setArrayAboutInsuranceInfo:(NSArray *)arrayAboutInsuranceInfo{
    self.tempArrayAboutInsuranceInfo = arrayAboutInsuranceInfo;
}

-(void)setCntr_id:(NSString *)cntr_id{
    self.tempCntr_id = cntr_id == nil ? @"" : cntr_id;
}

-(void)setCompanyName:(NSString *)companyName{
    self.tempCompanyName = companyName == nil ? @"" : companyName;
}

-(void)setTotalPrice:(CGFloat)totalPrice{
    self.tempTotalPrice = totalPrice ;
}

-(void)setPolicyHolder:(NSString *)policyHolder{
    self.tempPolicyHolder = policyHolder == nil ? @"" : policyHolder;
}

-(void)setInsuredPerson:(NSString *)insuredPerson{
    self.tempInsuredPerson = insuredPerson == nil ? @"" : insuredPerson;
}


#pragma mark - viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //加载数据
    [self loadData];
}

@end

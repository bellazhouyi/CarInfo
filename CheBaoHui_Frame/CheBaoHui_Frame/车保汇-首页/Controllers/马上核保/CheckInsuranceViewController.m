//
//  CheckInsuranceViewController.m
//  Template_Joker
//
//  Created by Bella on 16/1/13.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "CheckInsuranceViewController.h"

@interface CheckInsuranceViewController ()<UITableViewDataSource,UITableViewDelegate>

/**
 *  tableView
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;



@end


/**
 *  cell重用标识符
 */
static NSString *cellIdentifier = @"cell";


@implementation CheckInsuranceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //注册
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
}


#pragma mark -- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = @"测试";
  
    return cell;
}

#pragma mark -- 处理内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

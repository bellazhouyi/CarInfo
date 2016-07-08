//
//  ExtraInfoTableViewController.m
//  Template_Joker
//
//  Created by Bella on 16/1/14.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "ExtraInfoTableViewController.h"

#import "PhotoCell.h"

#import "ConfirmNoteTableViewController.h"

@interface ExtraInfoTableViewController ()


/**
 *  存放证件名数组
 */
@property(nonatomic,strong) NSMutableArray *mutableArray_licenseName;

/**
 *  存放注释数组
 */
@property(nonatomic,strong) NSMutableArray *mutableArray_explainDetail;

@end

/**
 *  cell重用标识符
 */
static NSString *photoCellIdentifier = @"photoCell";


@implementation ExtraInfoTableViewController

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:@"PhotoCell" bundle:nil] forCellReuseIdentifier:photoCellIdentifier];
    
    self.title = @"补充信息";
    //右侧item
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(confirm:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --提交按钮
-(void)confirm:(UIBarButtonItem *)sender{
    ConfirmNoteTableViewController *confirmNoteTVC = [ConfirmNoteTableViewController new];
    confirmNoteTVC.view.backgroundColor = [UIColor whiteColor];
    confirmNoteTVC.companyName = self.companyName;
    
    pushToViewControllerAndTarget(self, ConfirmNoteTableViewController, confirmNoteTVC);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.mutableArray_explainDetail.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoCell *photoCell = [tableView dequeueReusableCellWithIdentifier:photoCellIdentifier forIndexPath:indexPath];
    
    photoCell.licenseNameLabel.text = self.mutableArray_licenseName[indexPath.section];
    photoCell.explainNameLabel.text = self.mutableArray_explainDetail[indexPath.section];
    
    return photoCell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 144;
}


#pragma mark -- 懒加载
-(NSMutableArray *)mutableArray_licenseName{
    if (nil == _mutableArray_licenseName) {
        _mutableArray_licenseName = [NSMutableArray arrayWithCapacity:10];
    }
    return _mutableArray_licenseName;
}

-(NSMutableArray *)mutableArray_explainDetail{
    if (nil == _mutableArray_explainDetail) {
        _mutableArray_explainDetail = [NSMutableArray arrayWithCapacity:10];
    }
    return _mutableArray_explainDetail;
}


#pragma mark - viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //填充数据
    [self.mutableArray_licenseName addObject:@"车主身份证"];
    [self.mutableArray_licenseName addObject:@"车辆行驶证"];
    [self.mutableArray_licenseName addObject:@"车辆照片"];
    
    [self.mutableArray_explainDetail addObject:@"请按照提示上传身份证"];
    [self.mutableArray_explainDetail addObject:@"请按照提示上传行驶证"];
    [self.mutableArray_explainDetail addObject:@"请按照提示上传照片"];
}


@end

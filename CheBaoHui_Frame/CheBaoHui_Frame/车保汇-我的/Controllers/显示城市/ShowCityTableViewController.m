//
//  ShowCityTableViewController.m
//  CheBaoHui_Frame
//
//  Created by Bella on 16/3/16.
//  Copyright © 2016年 huirui.zhouyi. All rights reserved.
//

#import "ShowCityTableViewController.h"
#import "ShortNameForCity.h"

@interface ShowCityTableViewController ()<UITableViewDataSource,UITableViewDelegate>

/**
 *  城市名数容
 */
@property(nonatomic,strong) NSMutableArray *cityMutableArray;


@property(nonatomic,copy) NSMutableString *cityStr;

@end


static NSString *cellIndentifier = @"cell";

@implementation ShowCityTableViewController

#pragma mark - 视图加载完成
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIndentifier];
    
    [self gainCityData];
}

#pragma mark - receiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"%s,%d,收到内存警告",__func__,__LINE__);
    // Dispose of any resources that can be recreated.
}

#pragma mark - dealloc
-(void)dealloc{
    
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    self.cityMutableArray = nil;
    self.view = nil;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cityMutableArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [[self.cityMutableArray objectAtIndex:indexPath.row] AreaName];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:100];
    [tempArray addObjectsFromArray:self.cityMutableArray];
    
    //移除容器类里的内容
    self.cityMutableArray = nil;
    
    NSArray *sonItem = [[tempArray objectAtIndex:indexPath.row] SubArea];
    
    for (NSDictionary *sonDict in sonItem) {
        ShortNameForCity *sonCity = [ShortNameForCity new];
        
        [sonCity setValuesForKeysWithDictionary:sonDict];
        
        [self.cityMutableArray addObject:sonCity];
    }
    
    ShortNameForCity *cityName = [tempArray objectAtIndex:indexPath.row];
    
    if ([cityName.AreaName isEqualToString:@"市"] || [cityName.AreaName isEqualToString:@"县"] || [cityName.AreaName isEqualToString:@"市辖区"]) {
    }else{
        [self.cityStr appendString:cityName.AreaName];
    }
    if (sonItem.count == 0) {
        NSLog(@"%@",self.cityStr);
        self.passCityName(_cityStr,cityName.AreaCode);
        
        
        
        [self.navigationController popViewControllerAnimated:YES];
        self.cityStr = nil;
    }
    
    [self.tableView reloadData];
}


#pragma mark - responseObject的setter方法
-(void)setResponseObject:(id)responseObject{
   //第一层数据
    NSArray *firstDataArray = responseObject[@"data"];
    for (NSDictionary *item  in firstDataArray) {
        
        ShortNameForCity *city = [ShortNameForCity new];
        
        //KVC进行封装
        [city setValuesForKeysWithDictionary:item];
        
        [self.cityMutableArray addObject:city];
        
    }
}


#pragma mark - 懒加载
-(NSMutableArray *)cityMutableArray{
    if (_cityMutableArray == nil) {
        _cityMutableArray = [[NSMutableArray alloc]init];
    }
    return _cityMutableArray;
}

-(NSMutableString *)cityStr{
    if (_cityStr == nil) {
        _cityStr = [[NSMutableString alloc] init];
    }
    return _cityStr;
}


#pragma mark - viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}



#pragma mark - 获得城市接口
-(void)gainCityData{
    HTTPManagerOfMine *HTTPManager = [HTTPManagerOfMine sharedHTTPManagerOfMine];
    
    //调用 GetArea 获取所有区域 接口
    [HTTPManager GetArea];
    
    __weak typeof(self) temp = self;
    //成功 获得数据
    HTTPManager.passResponseObjectOfGetArea = ^(id responseObject){
        //传值
        temp.responseObject = responseObject;
        
        [temp.tableView reloadData];
    };
    
    //失败
    HTTPManager.passErrorOfGetArea = ^(NSError *error){
        [GiFHUD showWithMessage:FailureAboutRequestData];
    };
}

@end

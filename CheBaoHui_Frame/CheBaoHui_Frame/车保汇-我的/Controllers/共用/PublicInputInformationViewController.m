//
//  PublicInputInformationViewController.m
//  Template_Joker
//
//  Created by  李知洋 on 16/1/13.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "PublicInputInformationViewController.h"
#import "VerifyUitl.h"

@interface PublicInputInformationViewController ()

@property (weak, nonatomic) IBOutlet UITextField *publicTextInput;

/**
 *  右侧bar
 */
@property (nonatomic , strong) UIBarButtonItem * rightItemBar;


@end

@implementation PublicInputInformationViewController

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
}



#pragma  mark 初始化 右上角的按钮和输入内容的校验
-(void) initRightButtonWithInputverify
{
    self.navigationItem.rightBarButtonItem = self.rightItemBar;
    
    switch (self.publicInputInformationType) {
        case PublicInputInformationTypeTruthName :{
            [self setRightItemEnbledWithAddtarget];
        }
            break;
        case  PublicInputInformationTypeIDCard:{
            //身份证号码
            [self setRightItemEnbledWithAddtarget];
        }
            break;
        case  PublicInputInformationTypeCompetencyCode:{
            //资格证号码
            [self setRightItemEnbledWithAddtarget];
        }
            break;
        case  PublicInputInformationTypeBankCard:{
            [self setRightItemEnbledWithAddtarget];
            
        }break;
           case  PublicInputInformationTypeNickName:
            [self  setRightItemEnbledWithAddtarget];
            break;
            
        default:
            break;
    }
}


/**
 *  设置初始状态是否可以点击
 */
-(void)setRightItemEnbledWithAddtarget
{
    if(self.publicTextInput.text.length ==0){
        self.rightItemBar.enabled = NO;
    }
    [self.publicTextInput  addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
}


/**
 *检查输入内容
 */
-(void) textDidChange:(UITextField * ) textFiled
{
    switch (self.publicInputInformationType) {
        case PublicInputInformationTypeTruthName:
            [self  setRightItemEnbled];
            break;
        case  PublicInputInformationTypeIDCard:
            [self setRightItemEnbled];
            break;
        case  PublicInputInformationTypeCompetencyCode:
            [self  setRightItemEnbled];
            break;
            case PublicInputInformationTypeBankCard:
            [self  setRightItemEnbled];
            break;
            case  PublicInputInformationTypeNickName:
            [self setRightItemEnbled];
            break;
            
    }
}


-(void)setRightItemEnbled
{
    if(self.publicTextInput.text.length >0){
        self.rightItemBar.enabled = YES;
        return;
    }
    self.rightItemBar.enabled = NO;
    
}


/**
 *  确定
 */
-(void) confirm
{
    switch (self.publicInputInformationType) {
        case PublicInputInformationTypeTruthName:
            [self text:self.publicTextInput.text type:PublicInputInformationTypeTruthName];
         break;
        case PublicInputInformationTypeIDCard:
                [self text:self.publicTextInput.text type:PublicInputInformationTypeIDCard];
            break;
        case PublicInputInformationTypeCompetencyCode:
            [self text:self.publicTextInput.text type:PublicInputInformationTypeCompetencyCode];
            break;
    case  PublicInputInformationTypeBankCard:
            [self  text:self.publicTextInput.text type:PublicInputInformationTypeBankCard];
            break;
       case PublicInputInformationTypeNickName:
            [self  text:self.publicTextInput.text type:PublicInputInformationTypeNickName];
            break;
    }
}

-(void)text:(NSString * ) text    type:(PublicInputInformationType)  type
{
    if([self.delegate  respondsToSelector:@selector(callBackText:type:)]){
        [self.delegate  callBackText: text type: type];
    }
}


#pragma  mark 懒加载 右上角按钮
-(UIBarButtonItem *)rightItemBar
{
    if(!_rightItemBar){
        UIBarButtonItem * rightItemBar = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirm)];
        rightItemBar.tintColor = [UIColor  whiteColor];
        
        self.rightItemBar = rightItemBar;
    }
    return  _rightItemBar;
}

#pragma mark - receiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.publicTextInput setText: self.text];
    /**
     初始化 右上角的按钮和输入内容的校验
     */
    [self initRightButtonWithInputverify];
}

@end

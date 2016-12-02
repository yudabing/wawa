//
//  LonginViewController.m
//  文怡家常菜
//
//  Created by qf on 16/7/27.
//  Copyright © 2016年 qf. All rights reserved.
//

#import "LonginViewController.h"
#import "registerController.h"
@interface LonginViewController ()<UITextFieldDelegate>{
    UITextField * tf1;
    UITextField * tf2;
    UIButton * longinBtn;
    UIButton * registerBtn;
}
@property (nonatomic,retain) UIButton * leftButton;

@end

@implementation LonginViewController
-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.hidesBackButton = YES;
    _leftButton.hidden =NO;
    registerBtn.hidden =NO;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    //_leftButton.hidden = YES;
    registerBtn.hidden = YES;
    
}
-(void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"secondBack@2x.png"]];
    _leftButton =[UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.frame =CGRectMake(20,30,40,30);
    [_leftButton setBackgroundImage:[UIImage imageNamed:@"C555@2x.png"] forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(leftBtonAtion) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:_leftButton];
    [self initUI];
    
    
    
}
-(void)leftBtonAtion{
    [self.navigationController popViewControllerAnimated:YES];
    _leftButton.hidden = YES;
}
-(void)initUI{
     registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     registerBtn.frame = CGRectMake(WIDHR-60,25,50,30);
    [registerBtn setBackgroundImage:[UIImage imageNamed:@"C165@2x.png"] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerBtnAtion) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:registerBtn];
    UIImage * tfbg=[UIImage imageNamed:@"textfield@2x.png"];
    tfbg=[tfbg resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    tf1 =[[UITextField alloc] initWithFrame:CGRectMake(20,50,WIDHR-40,60)];
    UILabel * leftView1=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    tf1.leftView=leftView1;
    tf1.placeholder = @" 请输入邮箱";
    tf1.leftViewMode =UITextFieldViewModeAlways;
    [tf1 setBackground:tfbg];
    tf1.delegate =self;
    [self.view addSubview:tf1];
    
    tf2 =[[UITextField alloc] initWithFrame:CGRectMake(20,130,WIDHR-40,60)];
    UILabel * leftView2=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    tf2.leftView=leftView2;
    tf2.placeholder = @" 请输入密码";
    tf2.leftViewMode =UITextFieldViewModeAlways;
    tf2.delegate =self;
    [tf2 setBackground:tfbg];
    [self.view addSubview:tf2];
    
    longinBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    longinBtn.frame=CGRectMake((WIDHR-80)/2,200,80,30);
    [longinBtn setBackgroundImage:[UIImage imageNamed:@"C104@2x.png"] forState:UIControlStateNormal];
    [longinBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:longinBtn];
    
}
-(void)registerBtnAtion{
    registerController * rvc = [registerController new];
    [self.navigationController pushViewController:rvc animated:YES];
    _leftButton.hidden =NO;
    
}
-(void)loginAction{
   
   // longinBtn.enabled=NO;
    if(tf1.text.length==0){
        [self showMessage:@"请输入邮箱!"];
        longinBtn.enabled=YES;
        //跳出方法体(不写return,如果用户名 密码都为空,会连续跳出两个警告视图)
        return;
    }
    if(tf2.text.length==0){
        [self showMessage:@"请输入密码!"];
        longinBtn.enabled=YES;
        return;
    }
    //===登录方法
    AFHTTPRequestOperationManager * manager=[AFHTTPRequestOperationManager manager];
    NSDictionary * param=@{@"action":@"login",@"email":tf1.text,@"password":tf2.text};
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [manager POST:@"http://wenyijcc.com/services/wenyiapp/passporthandler.ashx" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
       if ([responseObject[@"_message"] isEqualToString:@"登录成功"]) {
        [_delegate massageBack:responseObject];
        [self.navigationController popViewControllerAnimated:YES];
           _leftButton.hidden = YES;
           NSString * email = tf1.text;
           NSString * password =tf2.text;
           NSString * userguid =responseObject[@"_userguid"];
           NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
           [user setObject:email forKey:@"userEmail"];
           [user setObject:password forKey:@"userPassword"];
           [user setObject:userguid forKey:@"userguid"];
       }else{
           [self showMessage:@"用户名与密码不对"];
       }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"失败");
    }];
    
}
/**
 封装一个警告视图来做提示窗口
 */
-(void)showMessage:(NSString*)msg{
    UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"警告" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField==tf1){
        [tf1 resignFirstResponder];
        [tf2 becomeFirstResponder];
    }else{
        [tf2 resignFirstResponder];
    }
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

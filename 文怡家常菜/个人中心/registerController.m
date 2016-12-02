//
//  registerController.m
//  文怡家常菜
//
//  Created by qf on 16/7/29.
//  Copyright © 2016年 qf. All rights reserved.
//

#import "registerController.h"


@interface registerController ()<UITextFieldDelegate>{
    UITextField * tf1;
    UITextField * tf2;
    UITextField * tf3;
    UIButton * registerBtn;
    UIButton * submitBtn;
    BOOL flag;
}

@end

@implementation registerController
-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.hidesBackButton =YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    submitBtn.hidden =YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
     self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"secondBack@2x.png"]];
    [self initUI];
}
-(void)initUI{
    submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(WIDHR-60,25,50,30);
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"C127@2x.png"] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitBtnAtion) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:submitBtn];
    UIImage * tfbg=[UIImage imageNamed:@"textfield@2x.png"];
    tfbg=[tfbg resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    tf1 =[[UITextField alloc] initWithFrame:CGRectMake(20,50,WIDHR-40,60)];
    UILabel * leftView1=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    tf1.leftView=leftView1;
    tf1.placeholder = @" 请输入呢称";
    tf1.leftViewMode =UITextFieldViewModeAlways;
    [tf1 setBackground:tfbg];
    tf1.delegate =self;
    [self.view addSubview:tf1];
    
    tf2 =[[UITextField alloc] initWithFrame:CGRectMake(20,130,WIDHR-40,60)];
    UILabel * leftView2=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    tf2.leftView=leftView2;
    tf2.placeholder = @" 请输入邮箱";
    tf2.leftViewMode =UITextFieldViewModeAlways;
    tf2.delegate =self;
    [tf2 setBackground:tfbg];
    [self.view addSubview:tf2];
    
    tf3 = [[UITextField alloc] initWithFrame:CGRectMake(20, 210,WIDHR-40,60)];
    UILabel * leftView3=[[UILabel alloc]initWithFrame:CGRectMake(0,0,20,20)];
    tf3.leftView =leftView3;
    tf3.placeholder = @"请输入密码";
    tf3.leftViewMode =UITextFieldViewModeAlways;
    tf3.delegate = self;
    [tf3 setBackground:tfbg];
    [self.view addSubview:tf3];
    
}


/*
-(void)submitBtnAtion{
    if (tf1.text.length==0) {
        [self showMessage:@"请输入昵称"];
        return;
    }if (tf2.text.length==0) {
        [self showMessage:@"请输入邮箱"];
        return;
    }if (tf3.text.length==0) {
        [self showMessage:@"请输入密码"];
        return;
    }
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    NSDictionary * paramester = @{@"action":@"new",@"email":tf2.text,@"nickname":tf1.text,@"password":tf3.text};
    [manager POST:@"http://wenyijcc.com/services/wenyiapp/passporthandler.ashx" parameters:paramester success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject[@"_message"]);
        if ([responseObject[@"_message"] isEqualToString:@"用户注册成功"]) {
            NSString * email = tf2.text;
            NSString * password =tf3.text;
            NSString * userguid =responseObject[@"_userguid"];
            NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
            [user setObject:email forKey:@"userEmail"];
            [user setObject:password forKey:@"userPassword"];
            [user setObject:userguid forKey:@"userguid"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else if([responseObject[@"_message"] isEqualToString:@"昵称已存在"]){
            [self showMessage:@"昵称已存在"];
        }else{
            [self showMessage:@"账户已存在"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
 */

-(void)showMessage:(NSString*)msg{
    UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"警告" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}

//-(BOOL)textFieldShouldReturn:(UITextField *)textField{
//    if(textField==tf1){
//        [tf1 resignFirstResponder];
//        [tf2 becomeFirstResponder];
//    }else if(textField==tf2){
//        [tf2 resignFirstResponder];
//        [tf3 becomeFirstResponder];
//    }else{
//        [tf3 resignFirstResponder];
//    }
//    return YES;
//}

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

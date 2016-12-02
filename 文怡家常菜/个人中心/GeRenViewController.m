//
//  GeRenViewController.m
//  文怡家常菜
//
//  Created by qf on 16/7/5.
//  Copyright (c) 2016年 qf. All rights reserved.
//

#import "GeRenViewController.h"
#import "GRCell.h"
#import "LonginViewController.h"
#import "GRModel.h"
#import "FatherController.h"
#import "LonginViewController.h"
#import "registerController.h"

@interface GeRenViewController ()<UITableViewDataSource,UITableViewDelegate,massageBack>
@property (nonatomic,retain) UITableView * tableView;
@property (nonatomic,retain) NSArray * picArray;
@property (nonatomic,retain) NSArray * nameArray;
@property (nonatomic,retain) NSMutableArray * dataArray;
@property (nonatomic,retain)  LonginViewController * lvc ;
@property (nonatomic,retain) UIButton * rightButton;
@property (nonatomic,retain) NSString * email;
@property (nonatomic,retain) NSString * password;
@end

@implementation GeRenViewController

-(void)viewWillAppear:(BOOL)animated{
//    _rightButton.hidden = NO;
//    [self longin];
//    [self getData];
//    [self.delegate showButton];
    
}
-(void)viewWillDisappear:(BOOL)animated{
   // _rightButton.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc] init];
    self.title = @"个人中心";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_navi.png"] forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"secondBack@2x.png"]];
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(WIDHR-60,25,50,30);
    [_rightButton setBackgroundImage:[UIImage imageNamed:@"C105@2x.png"] forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(cancelBtonAtion) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:_rightButton];
    [self createTableView];
    [self longin];
    [self getData];
    
    
}

-(void)cancelBtonAtion{
    [_dataArray removeAllObjects];
    [_tableView reloadData];
    NSString * appDomain = [[NSBundle mainBundle]bundleIdentifier];
   [[NSUserDefaults standardUserDefaults]removePersistentDomainForName:appDomain];


}

-(void)longin{
    NSUserDefaults * user =[NSUserDefaults standardUserDefaults];
    NSString * email = [user objectForKey:@"userEmail"];
    NSString * password =[user objectForKey:@"userPassword"];
    if (password!=nil) {
    AFHTTPRequestOperationManager * manager=[AFHTTPRequestOperationManager manager];
    NSDictionary * param=@{@"action":@"login",@"email":email,@"password":password};
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [manager POST:@"http://wenyijcc.com/services/wenyiapp/passporthandler.ashx" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"_message"] isEqualToString:@"登录成功"]) {
            [self massageBack:responseObject];
           // [self.navigationController popViewControllerAnimated:YES];
        }else{
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    }else{
    }
    
}
-(void)massageBack:(NSDictionary *)dict{
    GRModel * model = [GRModel new];
    model._userguid = dict[@"_userguid"];
    model._nickname =dict[@"_nickname"];
    model._level =dict[@"_level"];
    model._exp =dict[@"_exp"];
    model._uimage30=dict[@"_uimage30"];
    model._password =dict[@"_password"];
    [_dataArray addObject:model];
    [_tableView reloadData];
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    [user setObject:model._userguid forKey:@"userguid"];
    [user setObject:model._password forKey:@"pwd"];
}

-(void)getData{
    
    _picArray = @[@"ico-Favicon@2x.png",@"cio-homework@2x.png",@"ico-question@2x.png",@"ico-comment@2x.png",@"ico-private@2x.png"];
    
    _nameArray = @[@"我的收藏",@"我的作业",@"我的提问",@"我的评论",@"私人厨房"];
    
}
-(void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10,0,WIDHR-20,HEIGHT) style:UITableViewStyleGrouped];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    [_tableView registerNib:[UINib nibWithNibName:@"GRCell" bundle:nil] forCellReuseIdentifier:@"GRCell"];
    _tableView.scrollEnabled = NO;
    _tableView.backgroundView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"secondBack@2x.png"]];
    [self.view addSubview:_tableView];
    
}
-(void)loginbuttonAtion{
    _lvc = [LonginViewController new];
    _lvc.delegate = self;
    [self.navigationController pushViewController:_lvc animated:YES];
    [self.delegate hiddenButton];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        GRCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GRCell"];
        if (cell==nil) {
            cell = [[GRCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"GRCell"];
        }
        if (_dataArray.count==0) {
        cell.userImg.image = [UIImage imageNamed:@"X01.png"];
        [cell.loginButton setTitle:@"点击登录" forState:UIControlStateNormal];
            cell.loginButton.enabled =YES;
        [cell.loginButton addTarget:self action:@selector(loginbuttonAtion) forControlEvents:UIControlEventTouchUpInside];
        [cell.loginButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        cell.levelLabel.text = @"等级:厨房小毛猴";
        cell.expLabel.text = @"经验:20/1000";
        }else{
            GRModel * model =_dataArray[0];
            [cell.userImg setImageWithURL:[NSURL URLWithString:model._uimage30]];
            [cell.loginButton setTitle:model._nickname forState:UIControlStateNormal];
            cell.loginButton.enabled =NO;
            cell.levelLabel.text =[NSString stringWithFormat:@"等级:%@",model._level];
            cell.expLabel.text =[NSString stringWithFormat:@"经验:%@",model._exp];
            
        }
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"category_food_select.png"]];
        cell.backgroundView.alpha =0.7;
        return cell;
    }else {
        static NSString * cellID = @"cell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
            UIImageView * imageView1 =[[UIImageView alloc] initWithFrame:CGRectMake(15, 10,30, 30)];
            imageView1.tag =101;
            [cell.contentView addSubview:imageView1];
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(50,15,WIDHR-50, 30)];
            label.tag = 102;
            [cell.contentView addSubview:label];
            UIImageView * imageView2 =[[UIImageView alloc] initWithFrame:CGRectMake(WIDHR-50,20, 7, 15)];
            imageView2.tag = 103;
            [cell.contentView addSubview:imageView2];
        }
        UIImageView * imageView1 = (UIImageView*)[cell.contentView viewWithTag:101];
        UIImageView * imageView2 = (UIImageView*)[cell.contentView viewWithTag:103];
        imageView2.image =[UIImage imageNamed:@"ico_next_new@2x.png"];
        UILabel * label = (UILabel*)[cell.contentView viewWithTag:102];
        if (indexPath.section==1) {
        imageView1.image = [UIImage imageNamed:_picArray[indexPath.row]];
        label.text = _nameArray[indexPath.row];
        }else{
            imageView1.image = [UIImage imageNamed:_picArray[_picArray.count-1]];
            label.text = _nameArray[_nameArray.count-1];
            
        }
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"category_food_select.png"]];
        cell.backgroundView.alpha =0.7;
        return cell;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUserDefaults * user =[NSUserDefaults standardUserDefaults];
    NSString * userEmail  = [user objectForKey:@"userEmail"];
    if (indexPath.section==1) {
        if (userEmail) {
            FatherController * fvc = [FatherController new];
            fvc.row =(int)indexPath.row;
            [self.navigationController pushViewController:fvc animated:YES];
            [self.delegate hiddenButton];
        }else{
             _lvc = [LonginViewController new];
            [self.navigationController pushViewController:_lvc animated:YES];
            [self.delegate hiddenButton];
            
        }
            }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else if (section==1){
        
        return 4;
    }else{
        
        return 1;
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 106;
    }else{
        return 50;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
    //0.1为最小
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
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

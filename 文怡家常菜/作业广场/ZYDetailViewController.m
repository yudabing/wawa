//
//  ZYDetailViewController.m
//  文怡家常菜
//
//  Created by qf on 16/7/14.
//  Copyright © 2016年 qf. All rights reserved.
//

#import "ZYDetailViewController.h"
#import "DetailViewController.h"
#import "ZYDetailModel.h"
@interface ZYDetailViewController ()
@property (nonatomic,retain) NSMutableArray * dataArray;
@property (nonatomic,retain) UIButton * leftButton;
@end

@implementation ZYDetailViewController
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationItem setHidesBackButton:YES];
    _leftButton.hidden =NO;
}
-(void)viewWillDisappear:(BOOL)animated{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"作业广场";
    _leftButton =[UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.frame =CGRectMake(20,30,40,30);
    [_leftButton setBackgroundImage:[UIImage imageNamed:@"C555@2x.png"] forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(leftBtonAtion) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:_leftButton];
        _dataArray = [[NSMutableArray alloc] init];
    self.textField.enabled = NO;
    [self getData];
    
    
    
}
-(void)leftBtonAtion{
    [self.navigationController popViewControllerAnimated:YES];
     _leftButton.hidden =YES;
    
}
-(void)getData{
    NSString * url=[NSString stringWithFormat:@"http://wenyijcc.com/services/wenyiapp/submithandler.ashx?action=get&submitguid=%@",self.Guid];
    NSLog(@"%@",url);
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray * arr =responseObject[@"data"];
        for (NSDictionary * dict in arr) {
            ZYDetailModel * model = [ZYDetailModel new];
            model.RecipeGuid =dict[@"RecipeGuid"];
            model.RecipeName =dict[@"RecipeName"];
            model.NickName =dict[@"NickName"];
            model.Description =dict[@"Description"];
            model.Good =dict[@"Good"];
            model.UserImageUrl =dict[@"UserImageUrl"];
            model.LastUpdTime =dict[@"LastUpdTime"];
            model.ImageUrl =dict[@"ImageUrl"];
            model.UserLevel =dict[@"UserEntity"][@"UserLevel"];
            model.comListArray =dict[@"CommentList"];
            
            [_dataArray addObject:model];
            [self scrollViewContent];
           
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
}
-(void)scrollViewContent{
    _scrollView.showsVerticalScrollIndicator = NO;
    ZYDetailModel * model =_dataArray[0];
    [_imageView1 setImageWithURL:[NSURL URLWithString:model.ImageUrl]];
    [_imageView2 setImageWithURL:[NSURL URLWithString:model.UserImageUrl]];
    _label1.text =model.NickName;
    _label2.text =[NSString stringWithFormat:@"等级:%@",model.UserLevel];
    NSRange range = NSMakeRange(5,5);
    NSString *str = [model.LastUpdTime substringWithRange:range];
    _label3.text  = [NSString stringWithFormat:@"%@ 发布",str];
    _label4.text  = [NSString stringWithFormat:@"%d",[model.Good intValue]];
    CGSize contenSize1=[model.Description boundingRectWithSize:CGSizeMake(WIDHR, 1000)options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
    UILabel * label =[[UILabel alloc] initWithFrame:CGRectMake(15,_imageView1.frame.size.height+_imageView2.frame.size.height+22,WIDHR-30,contenSize1.height)];
    label.text =model.Description;
    label.textColor =[UIColor grayColor];
    label.numberOfLines =0;
    label.font =[UIFont systemFontOfSize:14];
    label.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_tab.png"]];
    [_scrollView addSubview:label];
    UIImageView * imageView =[[UIImageView alloc] initWithFrame:CGRectMake(70,_imageView1.frame.size.height+_imageView2.frame.size.height+contenSize1.height+30,WIDHR-140,20)];
    imageView.userInteractionEnabled =YES;
    imageView.image = [UIImage imageNamed:@"category_food_select.png"];
    [_scrollView addSubview:imageView];
    UILabel * label1= [[UILabel alloc] initWithFrame:CGRectMake(20,0,WIDHR-160,20)];
    label1.text = [NSString stringWithFormat:@"%@ 原菜谱>",model.RecipeName];
    label1.textColor =[UIColor whiteColor];
    label1.font = [UIFont systemFontOfSize:14];
    [imageView addSubview:label1];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAtion)];
    [imageView addGestureRecognizer:tap];
    for (int i=0;i<model.comListArray.count;i++) {
        UIView * commentView =[[UIView alloc] initWithFrame:CGRectMake(15,_imageView1.frame.size.height+_imageView2.frame.size.height+contenSize1.height+65+65*i,WIDHR-30,60)];
        commentView.backgroundColor = [UIColor brownColor];
        [_scrollView addSubview:commentView];
        NSDictionary * dict =model.comListArray[i];
        UIImageView * imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(5,5,50, 50)];
        [imageView1 setImageWithURL:[NSURL URLWithString:dict[@"UserImage"]]];
        [commentView addSubview:imageView1];
        UILabel * label2 = [[UILabel alloc] initWithFrame:CGRectMake(60,5,WIDHR-220,20)];
        label2.text =dict[@"NickName"];
        label2.textColor = [UIColor grayColor];
        label2.font = [UIFont systemFontOfSize:13];
        [commentView addSubview:label2];
        UILabel * label3 =[[UILabel alloc] initWithFrame:CGRectMake(60,30,WIDHR-120,25)];
        label3.text = dict[@"CommentContent"];
        [commentView addSubview:label3];
        UILabel * label4 = [[UILabel alloc] initWithFrame:CGRectMake(WIDHR-120,5,120,20)];
        NSString * str = [dict[@"DateCreated"] substringToIndex:10];
        label4.textColor =[UIColor grayColor];
        label4.font =[UIFont systemFontOfSize:13];
        label4.text =str;
        [commentView addSubview:label4];
        
        }
    _scrollView.contentSize =CGSizeMake(320,_imageView1.frame.size.height+_imageView2.frame.size.height+contenSize1.height+90+model.comListArray.count*60);
    
    
    
}
-(void)tapAtion{
    DetailViewController *dvc =[DetailViewController new];
    ZYDetailModel * model =_dataArray[0];
    dvc.RecipeGuid = model.RecipeGuid;
    [self.navigationController pushViewController:dvc animated:YES];
    _leftButton.hidden =YES;
    
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

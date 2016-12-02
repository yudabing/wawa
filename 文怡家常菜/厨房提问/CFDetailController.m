//
//  CFDetailController.m
//  文怡家常菜
//
//  Created by qf on 16/7/22.
//  Copyright © 2016年 qf. All rights reserved.
//

#import "CFDetailController.h"
#import "CFDetailModel.h"
@interface CFDetailController ()
@property (nonatomic,retain) NSMutableArray * dataArray;
@property (nonatomic,retain) UILabel *label;
@property (nonatomic,retain) UIButton * leftButton;
@end

@implementation CFDetailController
-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.hidesBackButton = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    _leftButton.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"secondBack@2x.png"]];
    self.title =@"问题详情";
    _leftButton =[UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.frame =CGRectMake(20,30,40,30);
    [_leftButton setBackgroundImage:[UIImage imageNamed:@"C555@2x.png"] forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(leftBtonAtion) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:_leftButton];
    [self getData];
    }
-(void)leftBtonAtion{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getData{
    _dataArray = [[NSMutableArray alloc] init];
    NSString * url =[NSString stringWithFormat:@"http://wenyijcc.com/services/wenyiapp/topichandler.ashx?action=topic&tgid=%@&pi=1",self.Guid];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [manager GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray * array = responseObject[@"data"];
        for (NSDictionary * dict in array) {
            CFDetailModel * model = [CFDetailModel new];
            model.NickName = dict[@"NickName"];
            model.MainContent = dict[@"MainContent"];
            model.TimeLine = dict[@"TimeLine"];
            model.ImageUrl = dict[@"ImageUrl"];
            model.comArray = dict[@"CommentList"];
          
            [_dataArray addObject:model];
            [self initView];

        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
   
    
}
-(void)initView{
   
    CFDetailModel * model = _dataArray[0];
    UIImageView * imageView = [[UIImageView alloc] init];
    [imageView setImageWithURL:[NSURL URLWithString:model.ImageUrl]];
    
    UILabel * label1 = [[UILabel alloc] init];
    label1.font = [UIFont systemFontOfSize:12];
    label1.textColor = [UIColor grayColor];
    label1.text = model.NickName;
    
    UILabel * label2 = [[UILabel alloc] init];
    label2.font = [UIFont systemFontOfSize:12];
    label2.textColor = [UIColor grayColor];
    NSRange range = NSMakeRange(5,5);
    NSString * str = [model.TimeLine substringWithRange:range];
    label2.text = str;
    
    UILabel * label3 = [[UILabel alloc] init];
    label3.font = [UIFont systemFontOfSize:14];
    label3.text = model.MainContent;
 
    int i=0;
    [self.view sd_addSubviews:@[imageView,label1,label2,label3]];
    for (NSDictionary * dict1 in model.comArray) {
        model.NickName1 = dict1[@"NickName"];
        model.Comment = dict1[@"Comment"];
        UILabel * label =[UILabel new];
        [self.view sd_addSubviews:@[imageView,label1,label2,label3,label]];
        label.font = [UIFont systemFontOfSize:13];
        label.text = [NSString stringWithFormat:@"%@: %@",model.NickName1,model.Comment];
        label.sd_layout
        .topSpaceToView(imageView,30*i)
        .leftSpaceToView(self.view,10)
        .rightSpaceToView(self.view,10)
        .heightIs(50);
        i++;
    }
    imageView.sd_layout
    .widthIs(50)
    .heightIs(50)
    .topSpaceToView (self.view,10)
    .leftSpaceToView(self.view,10);
    label1.sd_layout
    .topEqualToView(imageView)
    .leftSpaceToView(imageView,5)
    .heightRatioToView(imageView,0.4)
    .rightSpaceToView(self.view,150);
    label2.sd_layout
    .topEqualToView(imageView)
    .rightSpaceToView(self.view,0)
    .heightRatioToView(label1,1)
    .widthIs(50);
    label3.sd_layout
    .topSpaceToView(label2,0)
    .leftEqualToView(label1)
    .rightSpaceToView(self.view,10)
    .autoHeightRatio(0);
    
    
    
    
    
    

    
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

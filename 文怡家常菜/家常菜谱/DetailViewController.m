//
//  DetailViewController.m
//  文怡家常菜
//
//  Created by qf on 16/7/6.
//  Copyright (c) 2016年 qf. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailModel.h"
#import "LearnViewController.h"
#import "ComListController.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "TencentOpenAPI/QQApiInterface.h"
#import "TencentOpenAPI/TencentOAuth.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "LonginViewController.h"
#import "GRModel.h"
#import "DataBaseManager.h"
#import "LonginViewController.h"
#import "CollectModel.h"

@interface DetailViewController ()<UITextFieldDelegate,massageBack>
@property (nonatomic,retain) NSMutableArray * dataArray;
@property (nonatomic,assign) int l;
@property (nonatomic,assign) int b;
@property (nonatomic,retain) UIScrollView *scrollView;
@property (nonatomic,retain) UIImageView * imageView1;
@property (nonatomic,retain) UILabel * Titlelabel;
@property (nonatomic,retain) UITextField * textField;
@property (nonatomic,retain) UIImageView * imageView ;
@property (nonatomic,retain) UIButton * leftButton;
@property (nonatomic,retain) UIButton * shareButton;
@property (nonatomic,retain) NSString * picUrl;
@property (nonatomic,retain) UIView * bigView;
@property (nonatomic,retain) UIButton * collectButton;
@property (nonatomic,assign) BOOL flag;
@property (nonatomic,retain) NSString * userguid;
@property (nonatomic,retain) DataBaseManager * manager;
@property (nonatomic,retain) NSMutableArray * marr;
@end

@implementation DetailViewController
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationItem setHidesBackButton:YES];
    _leftButton.hidden = NO;
    _shareButton.hidden = NO;
    _collectButton.hidden = NO;
    
}
-(void)viewWillDisappear:(BOOL)animated{
     _shareButton.hidden = YES;
     _collectButton.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"菜谱详情";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"secondBack@2x.png"]];
    _leftButton =[UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.frame =CGRectMake(25,30,40,30);
    [_leftButton setBackgroundImage:[UIImage imageNamed:@"C555@2x.png"] forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(leftBtonAtion) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:_leftButton];
    _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _shareButton.frame = CGRectMake(WIDHR-60,30,25,25);
    [_shareButton setBackgroundImage:[UIImage imageNamed:@"C53@2x.png"] forState:UIControlStateNormal];
    [_shareButton addTarget:self action:@selector(shareBtonAtion) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:_shareButton];
    
    _collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _collectButton.frame =CGRectMake(WIDHR-100,30,25,25);
    [_collectButton addTarget:self action:@selector(collectAtion) forControlEvents:UIControlEventTouchUpInside];
    _marr = [[NSMutableArray alloc] init];
    [self getComment];
    if (_marr.count==0) {
        [_collectButton setBackgroundImage:[UIImage imageNamed:@"C71@2x.png"] forState:UIControlStateNormal];
        _flag = NO;
    }else{
        for (int i =0;i<_marr.count;i++) {
            NSString * RecipeGuid = _marr[i];
            if ([self.RecipeGuid isEqualToString:RecipeGuid]) {
                
                [_collectButton setBackgroundImage:[UIImage imageNamed:@"C124@2x.png"] forState:UIControlStateNormal];
                _flag = YES;
                break;
            }else
            {
                [_collectButton setBackgroundImage:[UIImage imageNamed:@"C71@2x.png"] forState:UIControlStateNormal];
                _flag = NO;
            }
        }
    }

    [self.navigationController.view addSubview:_collectButton];


    _imageView =[[UIImageView alloc] initWithFrame:CGRectMake(0,HEIGHT-110,WIDHR,49)];
    _imageView.image = [UIImage imageNamed:@"bg_tab.png"];
    _imageView.userInteractionEnabled =YES;
    [self.view addSubview:_imageView];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(WIDHR-80,5,80,30);
    [button setBackgroundImage:[UIImage imageNamed:@"C999.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(commentAtion) forControlEvents:UIControlEventTouchUpInside];
    [_imageView addSubview:button];
    
    _textField =[[UITextField alloc] initWithFrame:CGRectMake(20,5,WIDHR-120, 30)];
    _textField.placeholder =@"我要评一嘴";
    _textField.delegate =self;
    _textField.borderStyle =UITextBorderStyleRoundedRect;
    [_imageView addSubview:_textField];
    
    UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAtion:)];
    [self.view addGestureRecognizer:tap];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArray = [[NSMutableArray alloc] init];
    [self getData];
   
    
}
-(void)getComment{
    
    NSUserDefaults * user =[NSUserDefaults standardUserDefaults];
    _userguid  = [user objectForKey:@"userguid"];
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    NSString * str = [NSString stringWithFormat:@"http://wenyijcc.com/services/wenyiapp/collecthandler.ashx?action=list&userguid=%@&op=0",_userguid];
    [manager GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray * array = responseObject[@"datas"];
        if (![array isKindOfClass:[NSString class]]) {
            for (NSDictionary * dict in array) {
                CollectModel * model = [CollectModel new];
                [model setValuesForKeysWithDictionary:dict];
                [_marr addObject:model.RecipeGuid];
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    }];
    
    
}
#pragma mark 返回上一视图
-(void)leftBtonAtion{
    [self.navigationController popViewControllerAnimated:YES];
    _leftButton.hidden =YES;
    
}
-(void)collectAtion{
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载";
    NSUserDefaults * user =[NSUserDefaults standardUserDefaults];
    _userguid  = [user objectForKey:@"userguid"];
    if (_userguid) {
    if (_flag==YES) {
        
  [_collectButton setBackgroundImage:[UIImage imageNamed:@"C71@2x.png"] forState:UIControlStateNormal];
    AFHTTPRequestOperationManager * manager=[AFHTTPRequestOperationManager manager];
        NSDictionary *param=@{@"action":@"cancel",@"recipeguid":self.RecipeGuid,@"userguid":_userguid};
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        [manager GET:@"http://wenyijcc.com/services/wenyiapp/collecthandler.ashx" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            _flag =NO;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }else{
    [_collectButton setBackgroundImage:[UIImage imageNamed:@"C124@2x.png"] forState:UIControlStateNormal];
    AFHTTPRequestOperationManager * manager=[AFHTTPRequestOperationManager manager];
    NSDictionary *param=@{@"action":@"collect",@"recipeguid":self.RecipeGuid,@"userguid":_userguid};
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [manager GET:@"http://wenyijcc.com/services/wenyiapp/collecthandler.ashx" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _flag =YES;
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
        
    }else{
        LonginViewController * lvc =[LonginViewController new];
        lvc.delegate = self;
        [self.navigationController pushViewController:lvc animated:YES];
        _leftButton.hidden =YES;
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
    

-(void)shareBtonAtion{
    NSString * str = self.RecipeGuid;
    NSArray * arr = [str componentsSeparatedByString:@"-"];
    NSMutableString * mstr = [[NSMutableString alloc] init];
    for (int i=0;i<arr.count;i++) {
        [mstr appendString:arr[i]];
        
    }
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:_picUrl];
    NSLog(@"%@",_picUrl);
    [UMSocialData defaultData].extConfig.title = @"分享的title";
    [UMSocialData defaultData].extConfig.qqData.url = @"http://baidu.com";
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"507fcab25270157b37000010"
                                     shareText:[NSString stringWithFormat:@"%@http://wenyijcc.com/jcc/%@",self.RecipeName,mstr]
                                     shareImage:[UIImage imageNamed:@"1"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,nil]
                                       delegate:nil];
   
}
#pragma mark 键盘弹出
-(void)massageBack:(NSDictionary *)dict{
        GRModel * model = [GRModel new];
        model._userguid = dict[@"_userguid"];
        NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
        [user setObject:model._userguid forKey:@"userguid"];
        
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSUserDefaults * user =[NSUserDefaults standardUserDefaults];
    NSString * userEmail  = [user objectForKey:@"userEmail"];
    if (userEmail) {
        [textField resignFirstResponder];
        return YES;
    }else{
        LonginViewController * lvc = [LonginViewController new];
        lvc.delegate =self;
        [self.navigationController pushViewController:lvc animated:YES];
        _leftButton.hidden =YES;
        return NO;

    }
}
-(void)tapAtion:(UITapGestureRecognizer*)tap{
    [_textField resignFirstResponder];
    
}
#pragma mark 输入框开始编辑时
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.imageView.frame =CGRectMake(0,HEIGHT-360,WIDHR,49);
    _scrollView.scrollEnabled=NO;
    [self.view addSubview:self.imageView];
}
#pragma mark 输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.imageView.frame =CGRectMake(0,HEIGHT-110,WIDHR,49);
    _scrollView.scrollEnabled =YES;
    [self.view addSubview:self.imageView];
}
-(void)commentAtion{
    if(_textField.text.length!=0) {
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在上传";
    NSUserDefaults * user =[NSUserDefaults standardUserDefaults];
    _userguid  = [user objectForKey:@"userguid"];
    AFHTTPRequestOperationManager * manager=[AFHTTPRequestOperationManager manager];
    NSDictionary *param=@{@"action":@"comment",@"recipeguid":self.RecipeGuid,@"userguid":_userguid,@"comment":_textField.text};
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [manager POST:@"http://wenyijcc.com/services/wenyiapp/recipecommenthandler.ashx" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [_dataArray removeAllObjects];
        [self getData];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    _textField.text=nil;
    
        
}
-(void)getData{
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载";
    NetWorkingManager * manager = [NetWorkingManager shareManager];
    NSString * url =[NSString stringWithFormat:@"http://wenyijcc.com/services/wenyiapp/recipehandler.ashx?action=detail&recipeguid=%@",self.RecipeGuid];
   [manager getDetailData:url AndSuccess:^(id object) {
       dispatch_async(dispatch_get_main_queue(), ^{
           [self scrollViewinit:object];
       });
       
        } AndFailure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
-(void)scrollViewinit:(NSMutableArray *)marray{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,WIDHR,HEIGHT-110)];
    _scrollView.userInteractionEnabled =YES;
    _scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"secondBack@2x.png"]];
    [self.view addSubview:_scrollView];
    self.imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(40,55,WIDHR-80,240)];
    [_scrollView addSubview:self.imageView1];
    _dataArray =marray;
    DetailModel * model =_dataArray[0];
    [self.imageView1 setImageWithURL:[NSURL URLWithString:model.ThumbnailUrl]];
    _picUrl = model.ThumbnailUrl;
    self.imageView1.userInteractionEnabled =YES;
    UITapGestureRecognizer * bigTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bigPicAtion:)];
    [self.imageView1 addGestureRecognizer:bigTap];
     self.Titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(70,10,WIDHR-140,30)];
    self.Titlelabel.text =model.RecipeName;
    self.Titlelabel.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:self.Titlelabel];
    UIImageView * imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0,300,50, 15)];
    imageView2.image = [UIImage imageNamed:@"C72.png"];
    [_scrollView addSubview:imageView2];
    CGSize contenSize1=[model.Ingredients boundingRectWithSize:CGSizeMake(320, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10,315,WIDHR-10,contenSize1.height)];
    label.text = model.Ingredients;
    label.numberOfLines =0;
    label.font = [UIFont systemFontOfSize:15];
    [_scrollView addSubview:label];
    UIImageView * imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(0,315+contenSize1.height,50, 15)];
    imageView3.image = [UIImage imageNamed:@"C73.png"];
    [_scrollView addSubview:imageView3];
    CGSize contenSize2=[model.Seasoning boundingRectWithSize:CGSizeMake(WIDHR, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
    UILabel * label2 = [[UILabel alloc] initWithFrame:CGRectMake(10,330+contenSize1.height,WIDHR-10,contenSize2.height+10)];
    label2.text =model.Seasoning;
    label2.numberOfLines =0;
    label2.font = [UIFont systemFontOfSize:15];
    [_scrollView addSubview:label2];
    UIImageView * imageView4 = [[UIImageView alloc] initWithFrame:CGRectMake(0,340+contenSize1.height+contenSize2.height,50, 15)];
    imageView4.image = [UIImage imageNamed:@"C74.png"];
    [_scrollView addSubview:imageView4];
    CGSize contenSize3=[model.RecipeContent boundingRectWithSize:CGSizeMake(WIDHR, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
    UILabel * label3 = [[UILabel alloc] initWithFrame:CGRectMake(10,355+contenSize1.height+contenSize2.height,WIDHR-10,contenSize3.height+10)];
    label3.text =model.RecipeContent;
    label3.numberOfLines =0;
    label3.font = [UIFont systemFontOfSize:15];
    [_scrollView addSubview:label3];
    UIImageView * imageView5 = [[UIImageView alloc] initWithFrame:CGRectMake(0,340+contenSize1.height+contenSize2.height+contenSize3.height,50, 15)];
    imageView5.image = [UIImage imageNamed:@"wenyiNotes.png"];
    [_scrollView addSubview:imageView5];
    CGSize contenSize4=[model.RecipeNotes boundingRectWithSize:CGSizeMake(WIDHR, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
    UILabel * label4 = [[UILabel alloc] initWithFrame:CGRectMake(10,330+contenSize1.height+contenSize2.height+contenSize3.height,WIDHR-10,contenSize4.height)];
    label4.text =model.RecipeNotes;
    label4.numberOfLines =0;
    label4.font = [UIFont systemFontOfSize:15];
    [_scrollView addSubview:label4];
    
    if (model.StepGraph) {
        UIImageView * imageView6 = [[UIImageView alloc] initWithFrame:CGRectMake(20,350+contenSize1.height+contenSize2.height+contenSize4.height+contenSize3.height,WIDHR-40,360)];
        [imageView6 setImageWithURL:[NSURL URLWithString:model.StepGraph]];
        [_scrollView addSubview:imageView6];
        _l=360;
    }
    UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(0,350+contenSize1.height+contenSize2.height+contenSize4.height+contenSize3.height+_l,WIDHR,30)];
    view1.backgroundColor = [UIColor lightGrayColor];
    view1.alpha =0.5;
    [_scrollView addSubview:view1];
    UIImageView * imageView7 = [[UIImageView alloc] initWithFrame:CGRectMake(10,5,5,20)];
    imageView7.image =[UIImage imageNamed:@"C77.png"];
    [view1 addSubview:imageView7];
    UILabel *label5 =[[UILabel alloc] initWithFrame:CGRectMake(60,0,WIDHR-220,30)];
    label5.text =@"我要评一嘴";
    [view1 addSubview:label5];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame =CGRectMake(WIDHR-70,0,70, 30);
    [button setBackgroundImage:[UIImage imageNamed:@"C78.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAtion) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:button];
    for (int i =0;i<model.rcArray.count;i++) {
        NSDictionary * dict = model.rcArray[i];
        UIView * view =[[UIView alloc] initWithFrame:CGRectMake(0,350+contenSize1.height+contenSize2.height+contenSize4.height+contenSize3.height+30+70*i+_l,WIDHR,70)];
        [_scrollView addSubview:view];
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15,10,70, 60)];
        [imageView setImageWithURL:[NSURL URLWithString:dict[@"UserSmallImg"]] placeholderImage:[UIImage imageNamed:@"X01.png"]];
        [view addSubview:imageView];
        UILabel * label1 = [[UILabel alloc] initWithFrame:CGRectMake(85,10,WIDHR-205,30)];
        label1.text =dict[@"NickName"];
        label1.textColor =[UIColor grayColor];
        [view addSubview:label1];
        UILabel * label2 = [[UILabel alloc] initWithFrame:CGRectMake(85,50,WIDHR-85,20)];
        label2.text =dict[@"CommentContent"];
        label2.font =[UIFont systemFontOfSize:13];
        [view addSubview:label2];
        UILabel * label3 = [[UILabel alloc] initWithFrame:CGRectMake(WIDHR-120,10,120,20)];
        label3.font =[UIFont systemFontOfSize:13];
        label3.textColor =[UIColor grayColor];
        NSString * str = dict[@"DateCreated"];;
        NSArray * array = [str componentsSeparatedByString:@"T"];
        NSString * str1 =[array[1] substringToIndex:5];
        label3.text = [NSString stringWithFormat:@"%@ %@",array[0],str1];
        [view addSubview:label3];
    }
    UIView * view2 = [[UIView alloc] initWithFrame:CGRectMake(0,350+contenSize1.height+contenSize2.height+contenSize4.height+contenSize3.height+model.rcArray.count*70+_l+40,WIDHR,30)];
    view2.backgroundColor = [UIColor lightGrayColor];
    view2.alpha =0.5;
    [_scrollView addSubview:view2];
    UIImageView * imageView8 = [[UIImageView alloc] initWithFrame:CGRectMake(10,5,5,20)];
    imageView8.image =[UIImage imageNamed:@"C77.png"];
    [view2 addSubview:imageView8];
    UILabel *label6 =[[UILabel alloc] initWithFrame:CGRectMake(60,0,WIDHR-220, 30)];
    label6.text =@"交作业";
    [view2 addSubview:label6];
    UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame =CGRectMake(WIDHR-70,0, 70, 30);
    [button1 setBackgroundImage:[UIImage imageNamed:@"C75.png"] forState:UIControlStateNormal];
    [view2 addSubview:button1];
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(40,350+contenSize1.height+contenSize2.height+contenSize4.height+contenSize3.height+_l+40+model.rcArray.count*70+50,WIDHR-80,200)];
    scrollView.contentSize = CGSizeMake((WIDHR-80)*model.hwArray.count,200);
    scrollView.pagingEnabled =YES;
    [_scrollView addSubview:scrollView];
    UIImageView * imageView =[[UIImageView alloc] initWithFrame:CGRectMake(40,350+contenSize1.height+contenSize2.height+contenSize4.height+contenSize3.height+_l+40+model.rcArray.count*70+50,WIDHR-80, 200)];
    imageView.image =[UIImage imageNamed:@"X03.png"];
    [_scrollView addSubview:imageView];
    for (int i=0;i<model.hwArray.count; i++) {
        imageView.hidden =YES;
        NSDictionary * dict =model.hwArray[i];
        UIImageView * imageView =[[UIImageView alloc] initWithFrame:CGRectMake((WIDHR-80)*i,0,WIDHR-80, 200)];
        imageView.userInteractionEnabled =YES;
        [imageView setImageWithURL:[NSURL URLWithString:dict[@"ImageUrl"]] placeholderImage:[UIImage imageNamed:@"X03.png"]];
        [scrollView addSubview:imageView];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAtion1)];
        [imageView addGestureRecognizer:tap];
        scrollView.showsHorizontalScrollIndicator = NO;
        
    }
    _scrollView.contentSize =CGSizeMake(320,470+contenSize1.height+contenSize2.height+contenSize3.height+contenSize4.height+390+70*model.rcArray.count-210+_l);
    
}
#pragma mark 大图
-(void)bigPicAtion:(UITapGestureRecognizer*)tap{
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    _bigView = [[UIView alloc] initWithFrame:CGRectMake(0,0,WIDHR,HEIGHT)];
    [_bigView setBackgroundColor:[UIColor colorWithRed:0.3
                                               green:0.3
                                                blue:0.3
                                               alpha:0.5]];
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20,64,WIDHR-40, HEIGHT-250)];
    [imageView setImageWithURL:[NSURL URLWithString:_picUrl]];
    [_bigView addSubview:imageView];
    UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
    
    [currentWindow addSubview:_bigView];
    UITapGestureRecognizer * smallPic = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(smallPicAtion:)];
    [_bigView addGestureRecognizer:smallPic];
    
}
-(void)smallPicAtion:(UITapGestureRecognizer*)tap{
    _bigView.hidden =YES;
    
}

-(void)tapAtion1{
    LearnViewController  * lvc = [LearnViewController new];
    DetailModel * model =_dataArray[0];
    lvc.array = model.hwArray;
    [self.navigationController pushViewController:lvc animated:YES];
    
}
-(void)buttonAtion{
    ComListController * comVC = [ComListController new];
    comVC.recipeguid = self.RecipeGuid;
    [self.navigationController pushViewController:comVC animated:YES];
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

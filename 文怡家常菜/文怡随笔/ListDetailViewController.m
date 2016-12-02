//
//  ListDetailViewController.m
//  文怡家常菜
//
//  Created by qf on 16/7/14.
//  Copyright © 2016年 qf. All rights reserved.
//

#import "ListDetailViewController.h"
#import "ListDetailModel.h"
#import "CommentCell.h"
#import "ComModel.h"
#import "LonginViewController.h"

//#import "UIImageView+WebCache.h"
@interface ListDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic,retain) NSMutableArray * dataArray;
@property (nonatomic,retain) NSMutableArray * comArray;
@property (nonatomic,retain) UITableView * tableView;
@property (nonatomic,retain) UIButton * rightButton;
@property (nonatomic,retain) UITextField * textField;
@property (nonatomic,retain) UIImageView * imageView;
@property (nonatomic,assign) int page;
@end

@implementation ListDetailViewController
-(void)viewWillDisappear:(BOOL)animated{
    _rightButton.hidden =YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",self.Guid);
    self.navigationItem.hidesBackButton = YES;
    _dataArray = [[NSMutableArray alloc] init];
    _comArray = [[NSMutableArray alloc] init];
    //消除底部视图一段空白
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"secondBack@2x.png"]];
    
    _imageView =[[UIImageView alloc] initWithFrame:CGRectMake(0,HEIGHT-110,WIDHR,50)];
    _imageView.image = [UIImage imageNamed:@"secondBack@2x.png"];
    _imageView.userInteractionEnabled =YES;
    [self.view addSubview:_imageView];

    _textField = [[UITextField alloc]initWithFrame:CGRectMake(10,5,WIDHR-90,35)];
    _textField.background = [UIImage imageNamed:@"textfield@2x.png"];
    _textField.delegate =self;
    _textField.placeholder = @"我要评论";
    UILabel * leftView2=[[UILabel alloc]initWithFrame:CGRectMake(0,0,10,10)];
    _textField.leftView=leftView2;
    _textField.leftViewMode =UITextFieldViewModeAlways;
    _textField.borderStyle =UITextBorderStyleRoundedRect;
    [_imageView addSubview:_textField];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAtion:)];
    [self.view addGestureRecognizer:tap];
    
    UIButton * setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    setBtn.frame = CGRectMake(WIDHR-70,10,60, 30);
    [setBtn setBackgroundImage:[UIImage imageNamed:@"C999.png"] forState:UIControlStateNormal];
    [setBtn addTarget:self action:@selector(setBtnAtion) forControlEvents:UIControlEventTouchUpInside];
    [_imageView addSubview:setBtn];

    _page = 1;
    [self getData];
    [self createTableView];
    

    
}
-(void)setBtnAtion{
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText =@"正在上传";
    if (!_textField.text.length==0) {
    NSUserDefaults * user =[NSUserDefaults standardUserDefaults];
    NSString * userguid = [user objectForKey:@"userguid"];
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    NSDictionary * param = @{@"action":@"new",@"ngid":self.Guid,@"ugid":userguid,@"content":_textField.text};
    [manager POST:@"http://wenyijcc.com/services/wenyiapp/notecommenthandler.ashx" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _textField.text =nil;
        [_dataArray removeLastObject];
        [self getData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [_textField resignFirstResponder];
    
    
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSUserDefaults * user =[NSUserDefaults standardUserDefaults];
    NSString * userEmail  = [user objectForKey:@"userEmail"];
    if (userEmail) {
        [textField resignFirstResponder];
        return YES;
    }else{
        LonginViewController * lvc = [LonginViewController new];
        [self.navigationController pushViewController:lvc animated:YES];
        return NO;
        
    }
}
#pragma mark 输入框开始编辑时
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.imageView.frame =CGRectMake(0,HEIGHT-360,WIDHR,50);
    _tableView.scrollEnabled=NO;
    [self.view addSubview:self.imageView];
}
#pragma mark 输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.imageView.frame =CGRectMake(0,HEIGHT-110,WIDHR,50);
    _tableView.scrollEnabled =YES;
    [self.view addSubview:self.imageView];
}
-(void)tapAtion:(UITapGestureRecognizer*)tap{
    [_textField resignFirstResponder];
    
}


-(void)getData{
    MBProgressHUD * hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText =@"拼命加载中";
    NetWorkingManager * manager = [NetWorkingManager shareManager];
    NSString * str =@"http://wenyijcc.com/services/wenyiapp/noteshandler.ashx?action=note&ngid=";
    NSString * url =[NSString stringWithFormat:@"%@%@",str,self.Guid];
    [manager getWYDetailData:url AndSuccess:^(id object) {
            _dataArray = object;
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
            
        });
        
        } AndFailure:^(NSError *error) {
        }];
    //一秒后自动开启新线程
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), queue, ^{
        NSString * url1;
        if (_page==1) {
            url1 =[NSString stringWithFormat:@"http://wenyijcc.com/services/wenyiapp/notecommenthandler.ashx?action=list&ngid=%@&psize=10&op=%d",self.Guid,_page];
        }else{
            url1 =[NSString stringWithFormat:@"http://wenyijcc.com/services/wenyiapp/notecommenthandler.ashx?action=list&ngid=%@&psize=10&op=0&timeline=%@",self.Guid,self.TimeLine];
            
        }
        [manager getCommentData:url1 AndSuccess:^(id object) {
            if (_page==1) {
                [_comArray removeAllObjects];
            }
            for (ComModel * model in object) {
                [_comArray addObject:model];
                self.TimeLine = model.TimeLine;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView reloadData];
                
            });
            [_tableView headerEndRefreshing];
            [_tableView footerEndRefreshing];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } AndFailure:^(NSError *error) {
            
        }];
           });
    
    
    
}


-(void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,WIDHR,HEIGHT-110) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    //去掉横线
    _tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    [_tableView addHeaderWithTarget:self action:@selector(heardRefresh)];
    [_tableView addFooterWithTarget:self action:@selector(footRefresh)];
    [_tableView registerClass:[CommentCell class] forCellReuseIdentifier:@"CommentCell"];
    [self.view addSubview:_tableView];
    
    
}
-(void)heardRefresh{
    _page =1;
    [self getData];
}
-(void)footRefresh{
    _page ++;
    [self getData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.section==0) {
    static NSString * cellID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
     if (cell==nil) {
        cell = [[UITableViewCell alloc] init];
        UIImageView * imageView = [[UIImageView alloc] init];
        imageView.tag =1001;
        [cell.contentView addSubview:imageView];
        UILabel * label = [[UILabel alloc] init];
        label.tag =101;
        [cell.contentView addSubview:label];
       
    }
      ListDetailModel * LDmodel = _dataArray[indexPath.row];
        if([LDmodel.NoteType isEqualToString:@"title"])
       {
        CGSize contenSize=[LDmodel.NoteContent boundingRectWithSize:CGSizeMake(WIDHR, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20]} context:nil].size;
        cell.textLabel.frame = CGRectMake(30,0,WIDHR-60, contenSize.height);
        UILabel * label = (UILabel *)[cell.contentView viewWithTag:101];
        label.frame=CGRectMake(30,15,WIDHR-60, contenSize.height);
        label.numberOfLines = 0;
        label.textColor =[UIColor grayColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:20];
        label.text = LDmodel.NoteContent;
        }
        else if ([LDmodel.NoteType isEqualToString:@"image"]){
         
            UIImageView * imageView1 = (UIImageView*)[cell.contentView viewWithTag:1001];
                CGFloat num = [LDmodel.Width intValue]/(WIDHR-40);
                CGFloat height = [LDmodel.Height intValue]/num;
             imageView1.frame = CGRectMake(20,0,WIDHR-40, height);
               [imageView1 setImageWithURL:[NSURL URLWithString:LDmodel.NoteContent]];
            

        }
        else if ([LDmodel.NoteType isEqualToString:@"paragraph"])
        {
            
            CGSize contenSize=[LDmodel.NoteContent boundingRectWithSize:CGSizeMake(WIDHR, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
            UILabel * label = (UILabel *)[cell.contentView viewWithTag:101];
            label.frame = CGRectMake(30,0,WIDHR-60, contenSize.height);
            label.numberOfLines = 0;
            label.textColor =[UIColor grayColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = LDmodel.NoteContent;
            
        }else {
            
            CGSize contenSize=[LDmodel.NoteContent boundingRectWithSize:CGSizeMake(WIDHR, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
            UILabel * label = (UILabel *)[cell.contentView viewWithTag:101];
            label.frame = CGRectMake(30,0,WIDHR-60, contenSize.height);
            label.numberOfLines = 0;
            label.textColor =[UIColor grayColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = LDmodel.NoteContent;
            
            
        }
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"secondBack@2x.png"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    else {
        CommentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
        cell.model = [_comArray objectAtIndex:indexPath.row];
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"secondBack@2x.png"]];
        
        return cell;
    }
 
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
    ListDetailModel * LDmodel = _dataArray[indexPath.row];
    if ([LDmodel.NoteType isEqualToString:@"image"]) {
        UIImageView * imageView = (UIImageView *)[self.view viewWithTag:1001];
        return imageView.frame.size.height+20;
    }else if([LDmodel.NoteType isEqualToString:@"title"]){
        UILabel * label = (UILabel*)[self.view viewWithTag:101];
        return  label.frame.size.height+20;
    }else if ([LDmodel.NoteType isEqualToString:@"paragraph"]){
        UILabel * label = (UILabel*)[self.view viewWithTag:101];
        return  label.frame.size.height+20;

    }else {
        UILabel * label = (UILabel*)[self.view viewWithTag:101];
        return  label.frame.size.height+20;

    }
    }else{
        // >>>>>>>>>>>>>>>>>>>>> * cell自适应步骤2 * >>>>>>>>>>>>>>>>>>>>>>>>
        /* model 为模型实例， keyPath 为 model 的属性名，通过 kvc 统一赋值接口 */
        return [self.tableView cellHeightForIndexPath:indexPath model:_comArray[indexPath.row] keyPath:@"model" cellClass:[CommentCell class] contentViewWidth:[self cellContentViewWith]];
    }
}

- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    //适配ios7
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return _dataArray.count;
    }else {
        return _comArray.count;
    }
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

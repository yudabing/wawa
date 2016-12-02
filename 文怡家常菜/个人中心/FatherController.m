//
//  FatherController.m
//  文怡家常菜
//
//  Created by qf on 16/7/28.
//  Copyright © 2016年 qf. All rights reserved.
//

#import "FatherController.h"
#import "CollectModel.h"
#import "ComModel.h"
#import "CommentCell.h"
#import "DetailViewController.h"
#import "ListDetailViewController.h"
@interface FatherController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain) NSMutableArray * collectArray;
@property (nonatomic,retain) NSMutableArray * commentArray;
@property (nonatomic,retain) UIButton * leftButton;
@property (nonatomic,retain) UITableView * tableView;
@end


@implementation FatherController
-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.hidesBackButton = YES;
    _leftButton.hidden =NO;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _collectArray = [[NSMutableArray alloc] init];
    _commentArray = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"secondBack@2x.png"]];
    _leftButton =[UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.frame =CGRectMake(20,30,40,30);
    [_leftButton setBackgroundImage:[UIImage imageNamed:@"C555@2x.png"] forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(leftBtonAtion) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:_leftButton];
    [self getData];
    
}
-(void)getData{
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    NSString * userguid= [user objectForKey:@"userguid"];
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    NSString * str ;
    if (self.row ==0) {
     str = [NSString stringWithFormat:@"http://wenyijcc.com/services/wenyiapp/collecthandler.ashx?action=list&userguid=%@&op=0",userguid];
        
        [manager GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSArray * array = responseObject[@"datas"];
            if (![array isKindOfClass:[NSString class]]) {
            for (NSDictionary * dict in array) {
                CollectModel * model = [CollectModel new];
                [model setValuesForKeysWithDictionary:dict];
                [_collectArray addObject:model];
            }
            }
                [_tableView reloadData];
                [self initUI];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            }];
    }else if (self.row==1){
        [self initUI];
        
    }else if (self.row==2){
        [self initUI];
        
    }else {
        str = [NSString stringWithFormat:@"http://wenyijcc.com/services/wenyiapp/commenthandler.ashx?action=senlist&pagesize=10&ugid=%@&op=1",userguid];
        NSLog(@"%@",str);
        [manager GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSArray * array = responseObject[@"datas"];
            if (![array isKindOfClass:[NSString class]]) {
                for (NSDictionary * dict in array) {
                    ComModel * model = [ComModel new];
                    model.NickName = dict[@"NickName"];
                    model.TimeLine = dict[@"Timeline"];
                    model.ImageUrl = dict[@"ImageUrl"];
                    model.Comment = dict[@"OContent"];
                    model.RecipeGuid = dict[@"TopGuid"];
                    model.OType = dict[@"OType"];
                    model.OGuid = dict[@"OGuid"];
                    [_commentArray addObject:model];
                }
            }
            [_tableView reloadData];
            [self initUI];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
        
 
    }
}

-(void)initUI{
    UILabel * label = [[UILabel alloc]init];
    label.frame = CGRectMake(10,HEIGHT/2-100,WIDHR-20,60);
    label.textColor = [UIColor grayColor];
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    if (self.row==0) {
        self.title =@"我的收藏";
        if (_collectArray.count==0) {
        label.text =@"去收藏些我的菜谱，慢慢研究吧~";
        }else{
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,WIDHR, HEIGHT) style:UITableViewStylePlain];
            _tableView.delegate = self;
            _tableView.dataSource = self;
            _tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
            _tableView.backgroundView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"secondBack@2x.png"]];
           [self.view addSubview:_tableView];
        }
    }else if (self.row==1){
        self.title = @"我的作业";
        label.text =@"上交你的作业，馋死我吧";
    }else if (self.row==2){
        self.title =@"我的提问";
        label.text =@"有困难就大声！说！出！来！";
    }else{
        self.title =@"我的评论";
        if (_commentArray.count==0) {
            label.text =@"没事来聊两句呗~";
        }else{
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,WIDHR, HEIGHT-60) style:UITableViewStylePlain];
            _tableView.delegate = self;
            _tableView.dataSource = self;
            _tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
            _tableView.backgroundView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"secondBack@2x.png"]];
            [_tableView registerClass:[CommentCell class] forCellReuseIdentifier:@"CommentCell"];
            [self.view addSubview:_tableView];
        }
        
        
    }
  
}
-(void)leftBtonAtion{
    [self.navigationController popViewControllerAnimated:YES];
    _leftButton.hidden = YES;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.row==0) {
    static NSString * cellID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,5,80,80)];
        imageView.layer.cornerRadius = 10;
        imageView.clipsToBounds = YES;
        imageView.tag =101;
        [cell.contentView addSubview:imageView];
        UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(100,10,WIDHR-95,30)];
        nameLabel.tag =102;
        [cell.contentView addSubview:nameLabel];
        UILabel * tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(105,45,WIDHR-95,30)];
        tagLabel.tag =103;
        tagLabel.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:tagLabel];
    }
    CollectModel * model = _collectArray[indexPath.row];
    UIImageView  * imageView = (UIImageView*)[cell.contentView viewWithTag:101];
    imageView.image = [UIImage imageNamed:@"72.png"];
    UILabel * nameLabel =(UILabel*)[cell.contentView viewWithTag:102];
    nameLabel.text = model.RecipeName;
    UILabel * tagLabel = (UILabel*)[cell.contentView viewWithTag:103];
    tagLabel.text = model.RecipeTag;
    cell.backgroundView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"C85.png"]];
    return cell;
    }else {
        CommentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
        if (!cell) {
            cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CommentCell"];
        }
        
        cell.model = _commentArray[indexPath.row];
        cell.backgroundView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"C85.png"]];
        return cell;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.row==0) {
       
    return _collectArray.count;
    }else{
    return  _commentArray.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.row==0) {
        return 90;
    }else{
        // >>>>>>>>>>>>>>>>>>>>> * cell自适应步骤2 * >>>>>>>>>>>>>>>>>>>>>>>>
        /* model 为模型实例， keyPath 为 model 的属性名，通过 kvc 统一赋值接口 */
    return [self.tableView cellHeightForIndexPath:indexPath model:_commentArray[indexPath.row] keyPath:@"model" cellClass:[CommentCell class] contentViewWidth:[self cellContentViewWith]];
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.row==0) {
        DetailViewController * dvc = [DetailViewController new];
        CollectModel * model = _collectArray[indexPath.row];
        dvc.RecipeGuid = model.RecipeGuid;
        [self.navigationController pushViewController:dvc animated:YES];
        _leftButton.hidden =YES;
        
        
    }else{
        ListDetailViewController * lvc = [ListDetailViewController new];
        DetailViewController * dvc = [DetailViewController new];
        ComModel * model = _commentArray[indexPath.row];
        dvc.RecipeGuid =model.RecipeGuid;
        lvc.Guid = model.RecipeGuid;
        if ([model.OType isEqualToString:@"recipe"]) {
            [self.navigationController pushViewController:dvc animated:YES];
            _leftButton.hidden =YES;
        }else{
            [self.navigationController pushViewController:lvc animated:YES];
        }
        
    }
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.row==0) {
        [self deleteCollect:indexPath.row];
        [_collectArray removeObjectAtIndex:indexPath.row];
    }else{
    [self deleteComment:indexPath.row];
    [_commentArray removeObjectAtIndex:indexPath.row];
    }
    [_tableView reloadData];
    
    
}
-(void)deleteCollect:(NSInteger)index{
    NSUserDefaults * user =[NSUserDefaults standardUserDefaults];
    NSString * userguid  = [user objectForKey:@"userguid"];
     ComModel * model = _collectArray[index];
    AFHTTPRequestOperationManager * manager=[AFHTTPRequestOperationManager manager];
    NSDictionary *param=@{@"action":@"cancel",@"recipeguid":model.RecipeGuid,@"userguid":userguid};
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [manager GET:@"http://wenyijcc.com/services/wenyiapp/collecthandler.ashx" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
-(void)deleteComment:(NSInteger)index{
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    NSString * pwd = [user objectForKey:@"pwd"];
    NSString * ugid = [user objectForKey:@"userguid"];
    ComModel * model = _commentArray[index];
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObject:@"text/plain"];
    NSDictionary * param = @{@"action":@"del",@"pwd":pwd,@"cgid":model.OGuid,@"ugid":ugid};
    [manager GET:@"http://wenyijcc.com/services/wenyiapp/notecommenthandler.ashx" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject[@"msg"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败");
    }];
   
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

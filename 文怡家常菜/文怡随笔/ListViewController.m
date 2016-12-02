//
//  ListViewController.m
//  文怡家常菜
//
//  Created by qf on 16/7/13.
//  Copyright © 2016年 qf. All rights reserved.
//

#import "ListViewController.h"
#import "ListTableViewCell.h"
#import "ListModel.h"
#import "ListDetailViewController.h"
@interface ListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain) UITableView * tableView;
@property (nonatomic,retain) NSMutableArray * dataArray;
@property (nonatomic,retain) NSString * url;
@property (nonatomic,assign) int page;
@property (nonatomic,retain) UIButton * leftButton;
@end

@implementation ListViewController
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationItem setHidesBackButton:YES];
    self.leftButton.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.automaticallyAdjustsScrollViewInsets = NO;
    _leftButton =[UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.frame =CGRectMake(20,30,40,30);
    [_leftButton setBackgroundImage:[UIImage imageNamed:@"C555@2x.png"] forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(leftBtonAtion) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:_leftButton];
    self.title =self.titleStr;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,WIDHR,HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    _tableView.rowHeight =100;
    _tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    _tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"secondBack@2x.png"]];
    _page=1;
    [_tableView addHeaderWithTarget:self action:@selector(ation1)];
    [_tableView addFooterWithTarget:self action:@selector(ation2)];
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"ListTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    _dataArray =[[NSMutableArray alloc] init];
    [self getData];
}

-(void)leftBtonAtion{
    [self.navigationController popViewControllerAnimated:YES];
    _leftButton.hidden =YES;
}
-(void)ation1{
    _page=1;
    [self getData];
}
-(void)ation2{
    _page++;
    
    [self getData];
}
-(void)getData{
    
    if (_page==1) {

           _url =[NSString stringWithFormat:@"http://wenyijcc.com/services/wenyiapp/noteshandler.ashx?action=list&cgid=%@&op=%d",self.CatalogGuid,_page];
    }else{
        if (![self.CatalogGuid isEqualToString:@"2c82efc9-b1cc-4387-a7cc-f1353e2ee2e8"]) {
            NSLog(@"%@",self.CatalogGuid);
          _url=[NSString stringWithFormat:@"http://wenyijcc.com/services/wenyiapp/noteshandler.ashx?action=list&cgid=%@&op=0&timeline=%@",self.CatalogGuid,self.TimeLine];
       
        }
    }
    if (_url!=nil) {
    AFHTTPRequestOperationManager * manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.responseSerializer.acceptableContentTypes= [NSSet setWithObject:@"text/plain"];
    [manager GET:_url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (_page==1) {
            [_dataArray removeAllObjects];
        }
            [self parseDataWithDict:responseObject];
            [_tableView reloadData];
        
            
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    }
    [_tableView headerEndRefreshing];
    [_tableView footerEndRefreshing];
    _tableView.footerRefreshingText =@"没有更多数据了";
    _url =nil;
}
-(void)parseDataWithDict:(NSDictionary*)dict{
    
     NSArray * arr= dict[@"datas"];
    if (![arr isKindOfClass:[NSString class]]) {
    for (NSDictionary * dict1 in arr) {
        ListModel * model =[ListModel new];
        model.IConUrl = dict1[@"IConUrl"];
        model.TimeLine = dict1[@"TimeLine"];
        model.NoteContent = dict1[@"NoteContent"];
        model.Guid = dict1[@"Guid"];
        [_dataArray addObject:model];
        self.TimeLine =model.TimeLine;
    }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    ListModel * model =_dataArray[indexPath.row];
    [cell.imageView1 setImageWithURL:[NSURL URLWithString:model.IConUrl] placeholderImage:[UIImage imageNamed:@"X01.png"]];
    NSString * str = model.TimeLine;
    NSArray * array = [str componentsSeparatedByString:@"T"];
    NSString * str1 =[array[1] substringToIndex:5];
    cell.label1.text = [NSString stringWithFormat:@"%@ %@",array[0],str1];
    cell.label2.text =model.NoteContent;
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"C85.png"]];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ListDetailViewController * lvc = [ListDetailViewController new];
    ListModel * model  =_dataArray[indexPath.row];
    lvc.Guid = model.Guid;
    [self.navigationController pushViewController:lvc animated:YES];
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

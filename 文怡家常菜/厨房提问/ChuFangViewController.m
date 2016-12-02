//
//  ChuFangViewController.m
//  文怡家常菜
//
//  Created by qf on 16/7/5.
//  Copyright (c) 2016年 qf. All rights reserved.
//

#import "ChuFangViewController.h"
#import "CFTableViewCell.h"
#import "CFDetailController.h"
@interface ChuFangViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,retain) UITableView * tableView;
@property (nonatomic,retain) NSMutableArray * dataArray;
@property (nonatomic,retain) UIButton * timeButton;
@property (nonatomic,retain) UIButton * hotButton;
@property (nonatomic,retain) NSString * urlStr;
//@property (nonatomic,retain) UISearchDisplayController * searchDisPlayController;
@property (nonatomic,assign) int pi;
@end

@implementation ChuFangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"厨房提问";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_navi.png"] forBarMetrics:UIBarMetricsDefault];
    _pi=1;
    [self createTableView];
    [self getData];
}
-(void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,30,WIDHR,HEIGHT-75) style:UITableViewStylePlain];
    _tableView.dataSource =self;
    _tableView.delegate =self;
    _tableView.rowHeight =100;
    _tableView.bounces = false;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    _dataArray =[[NSMutableArray alloc] init];
    [_tableView registerNib:[UINib nibWithNibName:@"CFTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [_tableView addHeaderWithTarget:self action:@selector(ation1)];
    [_tableView addFooterWithTarget:self action:@selector(ation2)];
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,WIDHR,30)];
    imageView.image = [UIImage imageNamed:@"secondBack@2x.png"];
    imageView.userInteractionEnabled =YES;
    [self.view addSubview:imageView];
    _timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _timeButton.frame =CGRectMake((WIDHR-160)/2,0,80, 25);
    [_timeButton setImage:[UIImage imageNamed:@"order-time-normal@2x.png"] forState:UIControlStateNormal];
    [_timeButton setImage:[UIImage imageNamed:@"order-time-press@2x.png"] forState:UIControlStateSelected];
    _timeButton.selected =YES;
    [_timeButton addTarget:self action:@selector(timeButtonAtion) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:_timeButton];
    _hotButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _hotButton.frame =CGRectMake((WIDHR-160)/2+80,0,80,25);
    [_hotButton setImage:[UIImage imageNamed:@"order-hot-normal@2x.png"] forState:UIControlStateNormal];
    [_hotButton setImage:[UIImage imageNamed:@"order-hot-press@2x.png"] forState:UIControlStateSelected];
    [_hotButton addTarget:self action:@selector(hotButtonAtion) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:_hotButton];
    

    
}
-(void)hotButtonAtion{
    _timeButton.selected = NO;
    _hotButton.selected = YES;
    _urlStr = @"http://wenyijcc.com/services/wenyiapp/topichandler.ashx?action=list&sort=comment&pi=";
    [self getData];
}
-(void)timeButtonAtion{
    _hotButton.selected = NO;
    _timeButton.selected = YES;
    _urlStr = @"http://wenyijcc.com/services/wenyiapp/topichandler.ashx?action=list&sort=date&pi=";
    [self getData];
}
-(void)ation1{
    _pi=1;
    [self getData];
}
-(void)ation2{
    _pi++;
    [self getData];
}
-(void)getData{
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"拼命加载中";
    if ([_timeButton isSelected]) {
         _urlStr = @"http://wenyijcc.com/services/wenyiapp/topichandler.ashx?action=list&sort=date&pi=";
    }
    NetWorkingManager * manager = [NetWorkingManager shareManager];
    [manager getCFData:[NSString stringWithFormat:@"%@%d",_urlStr,_pi] AndSuccess:^(id object) {
        if (_pi==1) {
            [_dataArray removeAllObjects];
        }
        for (CFModel * model in object) {
            [_dataArray addObject:model];
        }
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } AndFailure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CFTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    CFModel * model1 =_dataArray[indexPath.row];
    [cell.imageView1 setImageWithURL:[NSURL URLWithString:model1.ImageUrl]];
    cell.label1.text =model1.NickName;
    cell.label2.text =model1.MainContent;
    NSString * str = model1.TimeLine;
    NSArray * array = [str componentsSeparatedByString:@"T"];
    NSString * str1 =[array[1] substringToIndex:5];
    cell.label3.text = [NSString stringWithFormat:@"%@ %@",array[0],str1];
    cell.label4.text =[model1.Comment stringValue];
    cell.backgroundView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"secondBack@2x.png"]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CFDetailController * dcv =[CFDetailController new];
    CFModel * model = _dataArray[indexPath.row];
    dcv.Guid = model.Guid;
    [self.navigationController pushViewController:dcv animated:YES];
    [_delegate hiddenButton];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [_delegate showButton];
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

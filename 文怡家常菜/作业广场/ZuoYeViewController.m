//
//  ZuoYeViewController.m
//  文怡家常菜
//
//  Created by qf on 16/7/5.
//  Copyright (c) 2016年 qf. All rights reserved.
//

#import "ZuoYeViewController.h"
#import "ZYCollectionViewCell.h"
#import "ZYDetailViewController.h"
#import "ZYModel.h"
@interface ZuoYeViewController ()<UICollectionViewDataSource,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,retain) UICollectionView * collectionView;
@property (nonatomic,retain) NSMutableArray * dataArray;
@property (nonatomic,assign) int pi;
@property (nonatomic,retain) UIButton * timeButton;
@property (nonatomic,retain) UIButton * hotButton;
@property (nonatomic,retain) NSString * urlStr;
@end

@implementation ZuoYeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"作业广场";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_navi.png"] forBarMetrics:UIBarMetricsDefault];
    _dataArray = [[NSMutableArray alloc] init];
    UICollectionViewFlowLayout * layout= [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,30,WIDHR,HEIGHT) collectionViewLayout:layout];
    _collectionView.delegate =self;
    _collectionView.dataSource =self;
    [_collectionView addHeaderWithTarget:self action:@selector(ation1)];
    [_collectionView addFooterWithTarget:self action:@selector(ation2)];
    [_collectionView registerNib:[UINib nibWithNibName:@"ZYCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    _collectionView.backgroundView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"secondBack@2x.png"]];
    [self.view addSubview:_collectionView];
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
    _pi=1;
    [self getData];
    
}
-(void)timeButtonAtion{
    _hotButton.selected =NO;
    _timeButton.selected =YES;
    [self getData];
}
-(void)hotButtonAtion{
    _timeButton.selected =NO;
    _hotButton.selected =YES;
    _urlStr =@"http://wenyijcc.com/services/wenyiapp/submithandler.ashx?action=kitt&sort=good&pi=";
    [self getData];
}

#pragma mark 上拉刷新
-(void)ation1{
    _pi =1;
    [self getData];
}
#pragma mark 下拉加载更多
-(void)ation2{
    _pi++;
    [self getData];
}

-(void)getData{
    MBProgressHUD * hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText =@"拼命加载中";
     NetWorkingManager * manager =[NetWorkingManager shareManager];
    if ([_timeButton isSelected]) {
        _urlStr = @"http://wenyijcc.com/services/wenyiapp/submithandler.ashx?action=kitt&sort=date&pi=";
    }
    
    [manager getZYData:[NSString stringWithFormat:@"%@%d",_urlStr,_pi] AndSuccess:^(id object) {
        if (_pi==1) {
            [_dataArray removeAllObjects];
        }
        for (ZYModel * model in object) {
            [_dataArray addObject:model];
        }
        [_collectionView reloadData];
        [_collectionView headerEndRefreshing];
        [_collectionView footerEndRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } AndFailure:^(NSError *error) {
        
    }];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZYCollectionViewCell * cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    ZYModel *model =_dataArray[indexPath.row];
    [cell.imageView1 setImageWithURL:[NSURL URLWithString:model.ImageUrl]];
    [cell.imageView2 setImageWithURL:[NSURL URLWithString:model.HeadImageUrl]];
    cell.label1.text = [NSString stringWithFormat:@"%d",[model.Good intValue]];;
    cell.label2.text =[NSString stringWithFormat:@"%d",[model.Comment intValue]];
    cell.label3.text =model.NickName;
    cell.label4.text =model.UserLevel;
    
    return cell;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10,10,0,10);
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;{
    return CGSizeMake(WIDHR/2-20,205);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ZYDetailViewController * dvc = [ZYDetailViewController new];
    ZYModel * model =_dataArray[indexPath.row];
    dvc.Guid =model.Guid;
    [self.navigationController pushViewController:dvc animated:YES];
     self.navigationItem.hidesBackButton = YES;
    [_delegate hiddenButton];
}

-(void)viewWillAppear:(BOOL)animated{
    [_delegate showButton];
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

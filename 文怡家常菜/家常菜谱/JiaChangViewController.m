//
//  JiaChangViewController.m
//  文怡家常菜
//
//  Created by qf on 16/7/5.
//  Copyright (c) 2016年 qf. All rights reserved.
//

#import "JiaChangViewController.h"
#import "JCCollectionViewCell.h"
#import "DetailViewController.h"
@interface JiaChangViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,retain) UICollectionView * collectionView;
@property (nonatomic,retain) NSMutableArray * dataArray;
@property (nonatomic,retain) NSString * timeline;
@property (nonatomic,assign) int op;
@end

@implementation JiaChangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"每日更新";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_navi.png"] forBarMetrics:UIBarMetricsDefault];
    _dataArray = [[NSMutableArray alloc] init];
    _timeline =@"";
    _op =1;
    [self createCollectionView];
    [self getData];

}
-(void)createCollectionView{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 5.0f;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,WIDHR,HEIGHT-59) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate =self;
    _collectionView.dataSource =self;
    _collectionView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"secondBack@2x.png"]];
    [_collectionView registerNib:[UINib nibWithNibName:@"JCCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [_collectionView addHeaderWithTarget:self action:@selector(ation1)];
    [_collectionView addFooterWithTarget:self action:@selector(ation2)];
    [self.view addSubview:_collectionView];



}

-(void)ation1{
    _op =1;
    [self getData];
}
-(void)ation2{

    JCModel * model = _dataArray[_dataArray.count-1];
    _timeline =model.TimeLine;
    _op =0;
    [self getData];
}

-(void)getData{
    MBProgressHUD * hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText =@"拼命加载中";
    NetWorkingManager * manager = [NetWorkingManager shareManager];
    NSString * url =[NSString stringWithFormat:@"http://mobile.wenyijcc.com/services/wenyiapp/recipehandler.ashx?action=list&op=%d&timeline=%@&catalog=0&pagesize=16&EcodeStr=D4AEE941546C0F0C0F9CD914AC5F92EA",_op,_timeline];
//    NSLog(@"============%@",url);
//    [manager getJCData:url AndSuccess:^(id object) {
//        if (_op==1) {
//            [_dataArray removeAllObjects];
//        }
//        for (JCModel * model in object) {
//            [_dataArray addObject:model];
//        }
//        [_collectionView headerEndRefreshing];
//        [_collectionView footerEndRefreshing];
//        [_collectionView reloadData];
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//     
//    } AndFailure:^(NSError *error) {
//        
//    }];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    JCCollectionViewCell * cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    JCModel * model = _dataArray[indexPath.row];
    [cell.imageView setImageWithURL:[NSURL URLWithString:model.ThumbnailUrl]];
    cell.label.text =model.RecipeName;
    cell.label.textColor = [UIColor whiteColor];
    return cell;
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;{
    return CGSizeMake(WIDHR/2-20,180);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;{
    return UIEdgeInsetsMake(0,10,0,10);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailViewController * dvc = [DetailViewController new];
    JCModel * model = _dataArray[indexPath.row];
    dvc.RecipeGuid = model.RecipeGuid;
    dvc.RecipeName = model.RecipeName;
    [self.navigationController pushViewController:dvc animated:YES];
    [_delegate hiddenButton];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [_delegate showButton];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    //Dispose of any resources that can be recreated.
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

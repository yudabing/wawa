//
//  WenYiViewController.m
//  文怡家常菜
//
//  Created by qf on 16/7/5.
//  Copyright (c) 2016年 qf. All rights reserved.
//

#import "WenYiViewController.h"
#import "ListViewController.h"
#import "RollScrolleview.h"
@interface WenYiViewController ()<backDelegata>
@property (nonatomic,retain) NSMutableArray * dataArray;

@end

@implementation WenYiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"文怡家常菜";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_navi.png"] forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"secondBack@2x.png"]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self gerData];

    
}
-(void)gerData{
    _dataArray = [[NSMutableArray alloc] init];
    NetWorkingManager * manager = [NetWorkingManager shareManager];
    NSString * urlStr = @"http://wenyijcc.com/services/wenyiapp/noteshandler.ashx?action=catalog";
    [manager getData:urlStr AndSuccess:^(id object) {
        _dataArray = object;
        [self scrollViewinit];
    } AndFailure:^(NSError *error) {
        
    }];

}
-(void)scrollViewinit{
    RollScrolleview *picScrollView =[[RollScrolleview alloc] initWithFrame:CGRectMake(40,10,WIDHR-80,HEIGHT-200)];
    picScrollView.delegate =self;
    [picScrollView setImageArr:_dataArray];
    [self.view addSubview:picScrollView];
}

#pragma mark picScrollView的代理方法
-(void)back:(UITapGestureRecognizer *)tap{
    ListViewController * lvc = [ListViewController new];
    int i =(int)tap.view.tag;
    WYModel * model = _dataArray[i-1];
    lvc.titleStr = model.CatalogName;
    lvc.CatalogGuid = model.CatalogGuid;
    [self.navigationController pushViewController:lvc animated:YES];
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

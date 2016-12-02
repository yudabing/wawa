//
//  ComListController.m
//  文怡家常菜
//
//  Created by qf on 16/7/22.
//  Copyright © 2016年 qf. All rights reserved.
//

#import "ComListController.h"
#import "DetailModel.h"
#import "CommentCell.h"
#import "ComModel.h"
@interface ComListController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,retain) UITableView * tableView;
@property (nonatomic,retain) NSMutableArray * dtatArray;
@property (nonatomic,assign) int page;
@end

@implementation ComListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton =YES;
    self.title = @"评论";
    _dtatArray = [[NSMutableArray alloc] init];
    _page =1;
    [self getData];
    [self createTableView];
}

-(void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,WIDHR,HEIGHT-10) style:UITableViewStylePlain];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    [_tableView addHeaderWithTarget:self action:@selector(headRefresh)];
    [_tableView addFooterWithTarget:self action:@selector(footRefresh)];
    [_tableView registerClass:[CommentCell class] forCellReuseIdentifier:@"CommentCell"];
    _tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"secondBack@2x.png"]];
    _tableView.separatorStyle = UITableViewCellEditingStyleNone;
    [self.view addSubview:_tableView];
   
    
}
-(void)headRefresh{
    _page = 1;
    [self getData];
}
-(void)footRefresh{
    _page = 0;
    [self getData];
}
-(void)getData{
    NetWorkingManager * manager = [NetWorkingManager shareManager];
    NSString * url;
    if (_page==1) {
    url = [NSString stringWithFormat:@"http://wenyijcc.com/services/wenyiapp/recipecommenthandler.ashx?action=list&recipeguid=%@&op=%d",self.recipeguid,_page];
    }else{
    url = [NSString stringWithFormat:@"http://wenyijcc.com/services/wenyiapp/recipecommenthandler.ashx?action=list&recipeguid=%@&op=0&timeline=%@",self.recipeguid,self.TimeLine];
    }
    NSLog(@"%@",url);
    [manager getComListData:url AndSuccess:^(id object) {
        if (_page==1) {
            [_dtatArray removeAllObjects];
        }
        for (ComModel * model in object) {
            [_dtatArray addObject:model];
            self.TimeLine = model.TimeLine;
        }
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
    } AndFailure:^(NSError *error) {
        
    }];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    if (!cell) {
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CommentCell"];
    }
    cell.model = _dtatArray[indexPath.row];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"secondBack@2x.png"]];
    return cell;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dtatArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应步骤2 * >>>>>>>>>>>>>>>>>>>>>>>>
    /* model 为模型实例， keyPath 为 model 的属性名，通过 kvc 统一赋值接口 */
    return [self.tableView cellHeightForIndexPath:indexPath model:_dtatArray[indexPath.row] keyPath:@"model" cellClass:[CommentCell class] contentViewWidth:[self cellContentViewWith]];
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

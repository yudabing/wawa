//
//  LearnViewController.m
//  文怡家常菜
//
//  Created by qf on 16/7/16.
//  Copyright © 2016年 qf. All rights reserved.
//

#import "LearnViewController.h"
#import "LearnTableViewCell.h"
#import "LearnModel.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "UIView+SDAutoLayout.h"
@interface LearnViewController ()
@property (nonatomic,retain) NSMutableArray * dataArray;


@end

@implementation LearnViewController
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationItem setHidesBackButton:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"大家都在学";
    //消除底部视图一段空白
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.view.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"secondBack@2x.png"]];
    [self getData];
}

-(void)getData{
    _dataArray = [[NSMutableArray alloc] init];
    for (NSDictionary * dict in self.array) {
        LearnModel * model = [LearnModel new];
        model.UserImageUrl =dict[@"UserImageUrl"];
        model.ImageUrl =dict[@"ImageUrl"];
        model.NickName =dict[@"NickName"];
        model.Good =dict[@"Good"];
        model.Comment =dict[@"Comment"];
        model.DateCreated =dict[@"DateCreated"];
        model.Description =dict[@"Description"];
        NSArray * arr =dict[@"CommentList"];
        for (NSDictionary * dict1 in arr) {
            model.NickName1 =dict1[@"NickName"];
            model.CommentContent =dict1[@"CommentContent"];
        }
        [_dataArray addObject:model];
        [self.tableView reloadData];
           }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID =@"cell";
    LearnTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell =[[LearnTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.model =_dataArray[indexPath.row];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"secondBack@2x.png"]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应步骤2 * >>>>>>>>>>>>>>>>>>>>>>>>
    /* model 为模型实例， keyPath 为 model 的属性名，通过 kvc 统一赋值接口 */
    return [self.tableView cellHeightForIndexPath:indexPath model:_dataArray[indexPath.row] keyPath:@"model" cellClass:[LearnTableViewCell class] contentViewWidth:[self cellContentViewWith]];
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

//
//  LearnTableViewCell.m
//  文怡家常菜
//
//  Created by qf on 16/7/16.
//  Copyright © 2016年 qf. All rights reserved.
//

#import "LearnTableViewCell.h"
@implementation LearnTableViewCell
{
    UIImageView * _view0;
    UILabel * _view1;
    UILabel * _view2;
    UIImageView * _view3;
    UIImageView * _view4;
    UIImageView * _view5;
    UIImageView * _view6;
    UILabel * _view7;
    UILabel * _view8;
    UILabel * _view9;
    UILabel * _view10;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}
-(void)setup{
    UIImageView * view0 =[UIImageView new];
    _view0= view0;
    
    UILabel * view1 = [UILabel new];
    _view1 =view1;
    view1.font = [UIFont systemFontOfSize:13];
    view1.textColor = [UIColor grayColor];
    
    UILabel * view2 =[UILabel new];
    _view2 =view2;
    view2.font = [UIFont systemFontOfSize:13];
    view2.textColor = [UIColor grayColor];
    
    UIImageView * view3 =[UIImageView new];
    _view3 =view3;
    
    UIImageView * view4 =[UIImageView new];
    _view4 =view4;
    
    UIImageView * view5 =[UIImageView new];
    _view5 =view5;
    
    UIImageView * view6 =[UIImageView new];
    _view6 =view6;
    
    UILabel * view7 =[UILabel new];
    view7.textColor =[UIColor grayColor];
    view7.font = [UIFont systemFontOfSize:13];
    _view7 =view7;

    
    UILabel * view8 =[UILabel new];
    view8.textColor =[UIColor grayColor];
    view8.font = [UIFont systemFontOfSize:13];
    _view8 =view8;
    
    UILabel * view9 =[UILabel new];
    _view9 =view9;
    
    UILabel * view10 =[UILabel new];
    view10.textColor = [UIColor grayColor];
    view10.font = [UIFont systemFontOfSize:14];
    _view10 =view10;
    
    [self.contentView sd_addSubviews:@[view0,view1,view2,view3,view4,view5,view6,view7,view8,view9,view10]];
    
    _view0.sd_layout
    .widthIs(40)
    .heightIs(40)
    .topSpaceToView(self.contentView,5)
    .leftSpaceToView(self.contentView,10);
    
    _view1.sd_layout
    .heightIs(10)
    .widthIs(70)
    .topSpaceToView(self.contentView,15)
    .leftSpaceToView(_view0,10);
    
    _view2.sd_layout
    .widthIs(120)
    .heightRatioToView(_view1,1)
    .topEqualToView(_view1)
    .rightSpaceToView(self.contentView,20);
    
    _view3.sd_layout
    .rightSpaceToView(self.contentView,20)
    .heightIs(280)
    .topSpaceToView(_view0,15)
    .leftSpaceToView(self.contentView,20);
    
    _view4.sd_layout
    .widthIs(70)
    .heightIs(20)
    .rightSpaceToView(self.contentView,20)
    .bottomEqualToView(_view3);
    
    
    _view5.sd_layout
    .widthIs(15)
    .heightIs(10)
    .rightSpaceToView(self.contentView,70)
    .topSpaceToView(self.contentView,325);
    
    
    _view6.sd_layout
    .widthRatioToView(_view5,1)
    .heightRatioToView(_view5,1)
    .topEqualToView(_view5)
    .rightSpaceToView(self.contentView,45);
    
    _view7.sd_layout
    .widthIs(10)
    .heightIs(10)
    .topEqualToView(_view6)
    .rightSpaceToView(self.contentView,60);
    
    _view8.sd_layout
    .widthIs(10)
    .heightIs(10)
    .topEqualToView(_view6)
    .rightSpaceToView(self.contentView,30);
    
    _view9.sd_layout
    .rightSpaceToView(self.contentView,30)
    .leftSpaceToView(self.contentView,30)
    .topSpaceToView(_view3,10)
    .autoHeightRatio(0);
    
    _view10.sd_layout
    .widthRatioToView(_view9,1)
    .heightIs(20)
    .leftEqualToView(_view9)
    .topSpaceToView(view9,10);
    
    
    
    
    
    
    
    
    
    
    
    
}
-(void)setModel:(LearnModel *)model{
    _model =model;
   [_view0 setImageWithURL:[NSURL URLWithString:model.UserImageUrl]];
    _view1.text = model.NickName;
   NSArray * arr =[model.DateCreated componentsSeparatedByString:@"T"];
    NSString * str = [arr[1] substringToIndex:5];
    _view2.text = [NSString stringWithFormat:@"%@ %@",arr[0],str];
   [_view3 setImageWithURL:[NSURL URLWithString:model.ImageUrl]];
    _view4.image =[UIImage imageNamed:@"C77.png"];
    _view5.image =[UIImage imageNamed:@"C231@2x.png"];
    _view6.image =[UIImage imageNamed:@"C230@2x.png"];
    _view7.text =[NSString stringWithFormat:@"%d",[model.Good intValue]];
    _view8.text =[NSString stringWithFormat:@"%d",[model.Comment intValue]];
    _view9.text =model.Description;
    _view10.textColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"C77.png"]];
    if (model.NickName1) {
        _view10.text = [NSString stringWithFormat:@"%@:%@",model.NickName1,model.CommentContent];
        [self setupAutoHeightWithBottomView:_view10 bottomMargin:10];
    }else{
        _view10.hidden =YES;
        [self setupAutoHeightWithBottomView:_view9 bottomMargin:10];
    }
    
    
    
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

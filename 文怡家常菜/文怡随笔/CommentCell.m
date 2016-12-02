//
//  CommentCell.m
//  文怡家常菜
//
//  Created by qf on 16/7/22.
//  Copyright © 2016年 qf. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell{
    UIImageView * _view0;
    UILabel * _view1;
    UILabel * _view2;
    UILabel * _view3;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}
-(void)setup{
    UIImageView * view0 = [UIImageView new];
    _view0 = view0;
    
    UILabel * view1 = [UILabel new];
    view1.textColor = [UIColor grayColor];
    view1.font = [UIFont systemFontOfSize:15];
    _view1 = view1;
    
    UILabel * view2 = [UILabel new];
    view2.textColor = [UIColor grayColor];
    view2.font = [UIFont systemFontOfSize:15];
    _view2 = view2;
    
    UILabel * view3 = [UILabel new];
    view3.font = [UIFont systemFontOfSize:13];
    _view3  = view3;
    
   [self.contentView sd_addSubviews:@[view0,view1,view2,view3]];
    

    
   _view1.sd_layout
   .topSpaceToView(self.contentView,20)
   .leftSpaceToView(self.contentView,60)
   .rightSpaceToView(self.contentView,160)
   .heightIs(15);
    
   _view2.sd_layout
   .topEqualToView(_view1)
   .leftSpaceToView(_view1,100)
   .rightSpaceToView(self.contentView,0)
   .heightRatioToView(_view1,1);
    
   _view3.sd_layout
   .topSpaceToView(view1,10)
   .leftEqualToView(_view1)
   .rightSpaceToView(self.contentView,10)
   .autoHeightRatio(0);
    
    _view0.sd_layout
    .centerYEqualToView(self.contentView)
    .centerXIs(30)
    .widthIs(50)
    .heightIs(55);
    
    
}

-(void)setModel:(ComModel *)model{
    _model = model;
    [_view0 setImageWithURL:[NSURL URLWithString:model.ImageUrl] placeholderImage:[UIImage imageNamed:@"X01.png"]];
    _view1.text = model.NickName;
    NSArray * strArr = [model.TimeLine componentsSeparatedByString:@"T"];
    NSString * str =strArr[0];
    _view2.text = [str substringFromIndex:5];
    _view3.text = model.Comment;
    [self setupAutoHeightWithBottomView:_view3 bottomMargin:10];
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

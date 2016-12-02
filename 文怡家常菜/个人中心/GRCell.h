//
//  GRCell.h
//  文怡家常菜
//
//  Created by qf on 16/7/25.
//  Copyright © 2016年 qf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GRCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImg;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *expLabel;

@end

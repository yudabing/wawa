//
//  ZYDetailViewController.h
//  文怡家常菜
//
//  Created by qf on 16/7/14.
//  Copyright © 2016年 qf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (nonatomic,retain) NSString * Guid;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

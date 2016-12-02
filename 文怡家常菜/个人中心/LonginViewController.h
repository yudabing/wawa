//
//  LonginViewController.h
//  文怡家常菜
//
//  Created by qf on 16/7/27.
//  Copyright © 2016年 qf. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol massageBack <NSObject>
@optional
-(void)massageBack:(NSDictionary *)dict;
@end
@interface LonginViewController : UIViewController
@property (retain,nonatomic)id <massageBack> delegate;
-(void)loginAction;
@end

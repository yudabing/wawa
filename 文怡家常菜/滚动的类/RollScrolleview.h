//
//  RollScrolleview.h
//  YJWShare
//
//  Created by qf on 16/7/12.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
//协议
@protocol RollScrolleviewDelegate <NSObject>
@optional
@end
@protocol backDelegata<NSObject>
-(void)back:(UITapGestureRecognizer*)tap;
@optional
@property (nonatomic,retain) id<backDelegata>delegate;
/**
 * 图片的点击事情方法
 */
-(void)rollClickImage_index:(long)index;



@end


@interface RollScrolleview : UIView

/**
 * 设置代理
 */
@property (nonatomic,assign) id delegate;
/**
 * 设置图片
 *
 */
-(void)setImageArr:(NSMutableArray *)arr;

/**
 *开启timer方法
 */
-(void)startTimer;

/**
 *关闭timer方法
 */
-(void)colseTimer;



@end

//
//  NetWorkingManager.h
//  文怡家常菜
//
//  Created by qf on 16/7/5.
//  Copyright (c) 2016年 qf. All rights reserved.
//

#import <Foundation/Foundation.h>
//数据请求成功，返回数据
typedef void(^successBlock)(id object);
//数据请求失败，返回错误
typedef void(^failureBlock)(NSError * error);

@interface NetWorkingManager : NSObject

+(NetWorkingManager *)shareManager;
-(void)getData:(NSString*)url AndSuccess:(successBlock)success AndFailure:(failureBlock)fualure;
-(void)getJCData:(NSString*)url AndSuccess:(successBlock)success AndFailure:(failureBlock)fualure;
-(void)getCFData:(NSString*)url AndSuccess:(successBlock)success AndFailure:(failureBlock)fualure;
-(void)getDetailData:(NSString*)url AndSuccess:(successBlock)success AndFailure:(failureBlock)fualure;
-(void)getZYData:(NSString*)url AndSuccess:(successBlock)success AndFailure:(failureBlock)fualure;
-(void)getWYDetailData:(NSString *)url AndSuccess:(successBlock)success AndFailure:(failureBlock)fualure;
-(void)getCommentData:(NSString*)url AndSuccess:(successBlock)success AndFailure:(failureBlock)fualure;
-(void)getComListData:(NSString*)url AndSuccess:(successBlock)success AndFailure:(failureBlock)fualure;

@end

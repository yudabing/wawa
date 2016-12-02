//
//  NetWorkingManager.m
//  文怡家常菜
//
//  Created by qf on 16/7/5.
//  Copyright (c) 2016年 qf. All rights reserved.
//

#import "NetWorkingManager.h"

@implementation NetWorkingManager
+(NetWorkingManager *)shareManager{
     NetWorkingManager * manager = [NetWorkingManager new];
    return manager;
   }

-(void)getData:(NSString *)url AndSuccess:(successBlock)success AndFailure:(failureBlock)fualure{
    AFHTTPRequestOperationManager * manager = [[AFHTTPRequestOperationManager alloc]init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [manager GET:url parameters:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray  * dataArray = [ParseManager parserWithDictionary:responseObject];
        success(dataArray);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fualure(error);
    }];

}

-(void)getJCData:(NSString *)url AndSuccess:(successBlock)success AndFailure:(failureBlock)fualure{
    AFHTTPRequestOperationManager * manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.responseSerializer.acceptableContentTypes= [NSSet setWithObject:@"text/plain"];
    [manager GET:url parameters:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray * dataArray = [ParseManager parserJCWithDictionary:responseObject];
        success(dataArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fualure(error);
    }];

    
}

-(void)getCFData:(NSString *)url AndSuccess:(successBlock)success AndFailure:(failureBlock)fualure{
    AFHTTPRequestOperationManager * manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.responseSerializer.acceptableContentTypes= [NSSet setWithObject:@"text/plain"];
    [manager GET:url parameters:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray * dataArray = [ParseManager parserCFWithDictionary:responseObject];
        success(dataArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fualure(error);
    }];
}

-(void)getDetailData:(NSString *)url AndSuccess:(successBlock)success AndFailure:(failureBlock)fualure{
    AFHTTPRequestOperationManager * manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.responseSerializer.acceptableContentTypes= [NSSet setWithObject:@"text/plain"];
    [manager GET:url parameters:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray * dataArray = [ParseManager parserDetailWithDictionary:responseObject];
        success(dataArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fualure(error);
    }];
}

-(void)getZYData:(NSString *)url AndSuccess:(successBlock)success AndFailure:(failureBlock)fualure{
    AFHTTPRequestOperationManager * manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.responseSerializer.acceptableContentTypes= [NSSet setWithObject:@"text/plain"];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray * dataArray = [ParseManager parserZYWithDictionary:responseObject];
        success(dataArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fualure(error);
    }];

}

-(void)getWYDetailData:(NSString *)url AndSuccess:(successBlock)success AndFailure:(failureBlock)fualure{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray * dataArray = [ParseManager parserWYDetailWithDictionary:responseObject];
        success(dataArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fualure(error);
    }];
}

-(void)getCommentData:(NSString *)url AndSuccess:(successBlock)success AndFailure:(failureBlock)fualure{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray * dataArray = [ParseManager parserCommentDataWithDictionary:responseObject];
        success(dataArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fualure(error);
    }];
    
}

-(void)getComListData:(NSString*)url AndSuccess:(successBlock)success AndFailure:(failureBlock)fualure{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray * dataArray = [ParseManager parserComListDataWithDictionary:responseObject];
        success(dataArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fualure(error);
    }];

}

@end

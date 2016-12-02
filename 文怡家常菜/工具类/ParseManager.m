//
//  ParseManager.m
//  文怡家常菜
//
//  Created by qf on 16/7/5.
//  Copyright (c) 2016年 qf. All rights reserved.
//

#import "ParseManager.h"
#import "WYModel.h"
#import "DetailModel.h"
#import "ZYModel.h"
#import "ListDetailModel.h"
#import "ComModel.h"
@implementation ParseManager
+(NSMutableArray *)parserWithDictionary:(NSDictionary *)dict{
    NSMutableArray * dataArray = [[NSMutableArray alloc] init];
    NSArray *arr =dict[@"datas"];
    for (NSDictionary * dict1 in arr) {
        WYModel * model = [WYModel new];
       model.CatalogName =dict1[@"CatalogName"];
        NSArray * arr1 =dict1[@"ImageList"];
        for (NSDictionary * dict2 in arr1) {
            model.ImageUrl =dict2[@"ImageUrl"];
            model.ID =dict2[@"ID"];
            model.CatalogGuid =dict2[@"CatalogGuid"];
        }
        [dataArray addObject:model];
    }
    return dataArray;
}
#pragma mark 家常
+(NSMutableArray *)parserJCWithDictionary:(NSDictionary *)dict{
    NSMutableArray * dataArray = [[NSMutableArray alloc] init];
    NSArray * arr =dict[@"datas"];
    if (![arr isKindOfClass:[NSString class]]) {
    for (NSDictionary * dict1 in arr) {
        JCModel * model = [JCModel new];
        model.RecipeGuid =dict1[@"RecipeGuid"];
        model.RecipeName =dict1[@"RecipeName"];
        model.ThumbnailUrl =dict1[@"ThumbnailUrl"];
        model.TimeLine  =dict1[@"TimeLine"];
        [dataArray addObject:model];
    }
    }
    return dataArray;
}
#pragma mark 厨房提问
+(NSMutableArray *)parserCFWithDictionary:(NSDictionary *)dict{
    NSMutableArray * dataArray = [[NSMutableArray alloc] init];
    NSArray * arr = dict[@"datas"];
    for (NSDictionary * dict1 in arr) {
        CFModel * model =[CFModel new];
        model.NickName = dict1[@"NickName"];
        model.MainContent =dict1[@"MainContent"];
        model.ImageUrl =dict1[@"ImageUrl"];
        model.TimeLine =dict1[@"TimeLine"];
        model.Comment =dict1[@"Comment"];
        model.Guid =dict1[@"Guid"];
        [dataArray addObject:model];
    }
    return dataArray;
}
+(NSMutableArray *)parserDetailWithDictionary:(NSDictionary *)dict{
    NSMutableArray  *dataArray = [[NSMutableArray alloc] init];
    DetailModel * model =[DetailModel new];
    model.RecipeContent =dict[@"RecipeContent"];
    model.RecipeName =dict[@"RecipeName"];
    model.RecipeNotes =dict[@"RecipeNotes"];
    model.ThumbnailUrl =dict[@"ThumbnailUrl"];
    model.Ingredients =dict[@"Ingredients"];
    model.Seasoning =dict[@"Seasoning"];
    NSArray * arr =dict[@"GraphsList"];
    for (NSDictionary * dict1 in arr) {
        model.StepGraph =dict1[@"StepGraph"];
    }
    model.rcArray =dict[@"RecipeCommentList"];
    for (NSDictionary * dict2 in model.rcArray) {
        model.CommentContent =dict2[@"CommentContent"];
        model.NickName = dict2[@"NickName"];
        model.UserSmallImg =dict2[@"UserSmallImg"];
        model.DateCreated =dict2[@"DateCreated"];
    }
   model.hwArray =dict[@"HomeWorkList"];
    for (NSDictionary * dict3 in model.hwArray) {
        model.ImageUrl =dict3[@"ImageUrl"];
        model.Description =dict3[@"Description"];
    }
    [dataArray addObject:model];
    return dataArray;
}
#pragma mark 作业广场
+(NSMutableArray *)parserZYWithDictionary:(NSDictionary *)dict{
    NSMutableArray * dataArray = [[NSMutableArray alloc] init];
    NSArray * arr =dict[@"datas"];
    for (NSDictionary * dict1 in arr) {
        ZYModel * model = [ZYModel new];
        model.ImageUrl =dict1[@"ImageUrl"];
        model.Good =dict1[@"Good"];
        model.Comment =dict1[@"Comment"];
        model.HeadImageUrl=dict1[@"UserImageUrl"];
        model.NickName =dict1[@"NickName"];
        model.Guid =dict1[@"Guid"];
        model.UserLevel =dict1[@"UserEntity"][@"UserLevel"];
        [dataArray addObject:model];
    }
    return dataArray;
}
#pragma mark 文怡随笔详情
+(NSMutableArray *)parserWYDetailWithDictionary:(NSDictionary *)dict{
    NSMutableArray * dataArray = [[NSMutableArray alloc] init];
    NSArray * arr =dict[@"datas"];
    for (NSDictionary * dict1 in arr) {
        ListDetailModel * model = [ListDetailModel new];
        [model setValuesForKeysWithDictionary:dict1];
        [dataArray addObject:model];
    }
    return dataArray;
}
#pragma mark 评论数据
+(NSMutableArray *)parserCommentDataWithDictionary:(NSDictionary *)dict{
    NSMutableArray * dataArray = [[NSMutableArray alloc] init];
    NSArray * arr = dict[@"datas"];
    if (![dict[@"datas"] isKindOfClass:[NSString class]]) {
        for (NSDictionary * dict1 in arr) {
        ComModel * model =[ComModel new];
        model.NickName = dict1[@"NickName"];
        model.ImageUrl = dict1[@"ImageUrl"];
        model.Comment = dict1[@"Comment"];
        model.TimeLine = dict1[@"TimeLine"];
        [dataArray addObject:model];
    }
    }
    return  dataArray;
}
+(NSMutableArray *)parserComListDataWithDictionary:(NSDictionary *)dict{
    NSMutableArray * dataArray = [[NSMutableArray alloc] init];
    NSArray * arr = dict[@"datas"];
    if (![dict[@"datas"] isKindOfClass:[NSString class]]) {
        for (NSDictionary * dict1 in arr) {
            ComModel * model =[ComModel new];
            model.Comment = dict1[@"CommentContent"];
            model.TimeLine = dict1[@"DateCreated"];
            model.NickName = dict1[@"NickName"];
            model.ImageUrl = dict1[@"UserSmallImg"];
            [dataArray addObject:model];
        }
    }
    return  dataArray;
}

@end

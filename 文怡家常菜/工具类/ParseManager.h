//
//  ParseManager.h
//  文怡家常菜
//
//  Created by qf on 16/7/5.
//  Copyright (c) 2016年 qf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParseManager : NSObject
+(NSMutableArray *)parserWithDictionary:(NSDictionary *)dict;
+(NSMutableArray *)parserJCWithDictionary:(NSDictionary *)dict;
+(NSMutableArray *)parserCFWithDictionary:(NSDictionary *)dict;
+(NSMutableArray *)parserDetailWithDictionary:(NSDictionary *)dict;
+(NSMutableArray *)parserZYWithDictionary:(NSDictionary *)dict;
+(NSMutableArray *)parserWYDetailWithDictionary:(NSDictionary *)dict;
+(NSMutableArray *)parserCommentDataWithDictionary:(NSDictionary *)dict;
+(NSMutableArray *)parserComListDataWithDictionary:(NSDictionary *)dict;
@end

//
//  DataBaseManager.m
//  文怡家常菜
//
//  Created by qf on 16/7/29.
//  Copyright © 2016年 qf. All rights reserved.
//

#import "DataBaseManager.h"

@implementation DataBaseManager

+(DataBaseManager *)shareManager{
    static DataBaseManager * manager;
    if (manager==nil) {
        manager =[DataBaseManager new];
        [manager createDataBase];
    }
    return manager;
}
#pragma mark 创建数据库
-(void)createDataBase{
    NSString * dbPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    _dataBase = [FMDatabase databaseWithPath:[NSString stringWithFormat:@"%@/wenyi.db",dbPath]];
    NSLog(@"%@",[NSString stringWithFormat:@"%@/wenyi.db",dbPath]);
    BOOL b = [_dataBase open];
    if (!b) {
        NSLog(@"打开数据库失败");
    }else{
        NSString * sql = @"create table if not exists wenyi (Id integer primary key autoincrement,RecipeGuid text)";
        BOOL b = [_dataBase executeUpdate:sql];
        if (!b) {
            NSLog(@"创建失败");
        }
        
    }
}
#pragma mark 插入失败
-(void)insertDataBase:(NSString*)recipeGuid{
    NSString * sql = @"insert into wenyi (RecipeGuid) values (?)";
    BOOL b = [_dataBase executeUpdate:sql,recipeGuid];
    if (!b) {
        NSLog(@"插入失败");
    }
}
#pragma mark 查询数据
-(NSString*)selectDataBase:(NSString*)recipeGuid{
    NSString * str;
    NSString * sql = @"select * from wenyi where RecipeGuid=?";
    FMResultSet * set = [_dataBase executeQuery:sql,recipeGuid];
    while (set.next) {
        str =[set stringForColumn:@"RecipeGuid"];
    }
    return str;
}

#pragma mark 删除数据
-(void)deleteDataBase:(NSString*)recipeGuid{
    NSString * sql = @"delete from wenyi where RecipeGuid=?";
    BOOL b = [_dataBase executeUpdate:sql,recipeGuid];
    if (!b) {
        NSLog(@"删除失败");
    }
}
@end

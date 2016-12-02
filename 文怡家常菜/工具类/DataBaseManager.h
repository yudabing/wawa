//
//  DataBaseManager.h
//  文怡家常菜
//
//  Created by qf on 16/7/29.
//  Copyright © 2016年 qf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataBaseManager : NSObject
@property (nonatomic,retain) FMDatabase * dataBase;
+(DataBaseManager*)shareManager;
-(void)insertDataBase:(NSString*)recipeGuid;
-(NSString*)selectDataBase:(NSString*)recipeGuid;
-(void)deleteDataBase:(NSString*)recipeGuid;
@end

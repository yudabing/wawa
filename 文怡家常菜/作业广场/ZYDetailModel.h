//
//  ZYDetailModel.h
//  文怡家常菜
//
//  Created by qf on 16/7/15.
//  Copyright © 2016年 qf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYDetailModel : NSObject
@property (nonatomic,retain) NSString * RecipeGuid;
@property (nonatomic,retain) NSString * NickName;
@property (nonatomic,retain) NSString * UserImageUrl;
@property (nonatomic,retain) NSString * ImageUrl;
@property (nonatomic,retain) NSString * Good;
@property (nonatomic,retain) NSString * RecipeName;
@property (nonatomic,retain) NSString * Description;
@property (nonatomic,retain) NSString * CommentContent;
@property (nonatomic,retain) NSString * UserLevel;
@property (nonatomic,retain) NSString * UserImage;
@property (nonatomic,retain) NSString * DateCreated;
@property (nonatomic,retain) NSString * LastUpdTime;
@property (nonatomic,retain) NSString * NickName1;
@property (nonatomic,retain) NSArray * comListArray;
@end

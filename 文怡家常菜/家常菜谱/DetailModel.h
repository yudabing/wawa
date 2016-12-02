//
//  DetailModel.h
//  文怡家常菜
//
//  Created by qf on 16/7/9.
//  Copyright (c) 2016年 qf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailModel : NSObject
@property (nonatomic,retain) NSString * RecipeName;
@property (nonatomic,retain) NSString * RecipeContent;
@property (nonatomic,retain) NSString * RecipeNotes;
@property (nonatomic,retain) NSString * ThumbnailUrl;
@property (nonatomic,retain) NSString * Ingredients;
@property (nonatomic,retain) NSString * StepGraph;
@property (nonatomic,retain) NSString * Seasoning;
@property (nonatomic,retain) NSString * CommentContent;
@property (nonatomic,retain) NSString * NickName;
@property (nonatomic,retain) NSString * UserSmallImg;
@property (nonatomic,retain) NSString * DateCreated;
@property (nonatomic,retain) NSString * Description;
@property (nonatomic,retain) NSString * ImageUrl;
@property (nonatomic,retain) NSArray * rcArray;
@property (nonatomic,retain) NSArray * hwArray;
@end

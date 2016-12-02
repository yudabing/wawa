//
//  RollScrolleview.m
//  YJWShare
//
//  Created by qf on 16/7/12.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "RollScrolleview.h"
#import "WYModel.h"
#import "ListViewController.h"
@interface RollScrolleview ()<UIScrollViewDelegate>
{
     //图片的数量
    NSUInteger imageNumber;
     //滑动的图片数
    int currentPageIndex;
    //是否启动timer
    BOOL isTimerStart;

}
//计时器
@property (nonatomic,retain) NSTimer *timer;
//页数控制器
@property (nonatomic,retain) UIPageControl * pageControl;
//滚动视图
@property (nonatomic,retain) UIScrollView * scrollview;
//图片数组
@property (nonatomic,retain) NSArray * imageArray;
@end



@implementation RollScrolleview
//初始化代码
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;

}
//设置图片
-(void)setImageArr:(NSMutableArray *)arr{
    //设置滚动视图的属性
    self.imageArray =arr;
    NSMutableArray * picArray = [[NSMutableArray alloc] init];
    NSMutableArray * nameArray = [[NSMutableArray alloc] init];
        for (int i =0;i<arr.count;i++) {
            WYModel * model =arr[i];
            [picArray addObject:model.ImageUrl];
            [nameArray addObject:model.CatalogName];
    
       }
    UIScrollView * scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    scrollview.showsHorizontalScrollIndicator = NO;
    scrollview.showsVerticalScrollIndicator = NO;
    scrollview.pagingEnabled = YES;
    scrollview.delegate = self;
    scrollview.scrollsToTop = NO;
    scrollview.userInteractionEnabled = YES;
    self.scrollview = scrollview;
    [self addSubview:scrollview];
    
    //深拷贝imageview上的控件
    NSMutableArray * temArray = [NSMutableArray arrayWithArray:picArray];
    UIImageView * imageview1 = [picArray objectAtIndex:([picArray count]-1)];
    UIImageView * imageview2 = [picArray objectAtIndex:0];
    
//    NSData * data1 = [NSKeyedArchiver archivedDataWithRootObject:imageview1];
//    NSData * data2 = [NSKeyedArchiver archivedDataWithRootObject:imageview2];
//    
//    UIImageView * imageview3 = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
//    UIImageView * imageview4 = [NSKeyedUnarchiver unarchiveObjectWithData:data2];
    
    [temArray insertObject:imageview1 atIndex:0];
    [temArray addObject:imageview2];
    UILabel * label1 =[nameArray objectAtIndex:(nameArray.count-1)];
    UILabel * label2 =[nameArray objectAtIndex:0];
    [nameArray insertObject:label1 atIndex:0];
    [nameArray addObject:label2];
    imageNumber = temArray.count;
    //循环的添加图片
    for (int i = 0; i<imageNumber; i++) {
    UIImageView * imageview  = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width*i, 0, self.frame.size.width, self.frame.size.height)];
        [imageview setImageWithURL:[NSURL URLWithString:temArray[i]]];
        imageview.userInteractionEnabled = YES;
//        UIImageView * imageView5 = [[UIImageView alloc] initWithFrame:CGRectMake(imageview.width-80,20,80,30)];
//        imageView5.image = [UIImage imageNamed:@"C77.png"];
//        [imageview addSubview:imageView5];
//        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,80,30)];
//        label.textColor = [UIColor whiteColor];
//        label.text = nameArray[i];
//        [imageView5 addSubview:label];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageviewClick:)];
//        imageview.tag=i;
//        [imageview addGestureRecognizer:tap];
//        imageview.userInteractionEnabled=YES;
        [self.scrollview addSubview:imageview];
        
        
    }

 
    //添加分页控制器
    float pageControlWidth = (imageNumber-2)* 10.0f +40.f;
    UIPageControl * pageControl = [[UIPageControl alloc]
    initWithFrame:CGRectMake((self.frame.size.width/2-pageControlWidth/2), self.frame.size.height+20, pageControlWidth, 20)];
    
    self.pageControl = pageControl;
    pageControl.currentPage = 0;
    pageControl.numberOfPages = imageNumber-2;
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    [self addSubview:pageControl];
    
    //设置滚动视图的偏移内容大小
    self.scrollview.contentSize = CGSizeMake(self.frame.size.width * imageNumber, self.frame.size.height);
    [self.scrollview setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
    [self startTimer];
    

}

//计时器开始计时
-(void)startTimer
{

    if (self.timer == nil) {
        isTimerStart = YES;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2.5f target:self selector:@selector(timerStart) userInfo:nil repeats:YES];
        
    }

}
//计时器结束计时
-(void)colseTimer{

    if (self.timer) {
        isTimerStart = NO;
        [self.timer invalidate];
        self.timer = nil;
        
    }
}

-(void)timerStart{
    
    CGPoint pt = self.scrollview.contentOffset;
    if (pt.x == self.frame.size.width * (imageNumber-2)) {
        self.pageControl.currentPage = 0;
        //每隔一定的时间加滚动一页
        [self.scrollview scrollRectToVisible:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height) animated:YES];
        
    }else{
        //从当前页开始继续滚动一页
        [self.scrollview scrollRectToVisible:CGRectMake(pt.x + self.frame.size.width, 0, self.frame.size.width, self.frame.size.height) animated:YES];
    }
}
// 当手动滚动时，计时器停止。

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{

   [self colseTimer];
}

-(void)scrollViewDidScroll:(UIScrollView *)sender{
    // 在滚动完以后设置页码
    CGFloat pageWidth = self.scrollview.frame.size.width;
    int page = floor((self.scrollview.contentOffset.x - pageWidth / 2) /pageWidth)+1;
    
    self.pageControl.currentPage = (page - 1 );
    
    currentPageIndex = page;

}

//计时器重新开始工作
-(void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView{
    
    if (0 == currentPageIndex) {
        [self.scrollview setContentOffset:CGPointMake([self.imageArray count]*self.frame.size.width, 0)];
    }
    if ([self.imageArray count]+1 == currentPageIndex) {
        [self.scrollview setContentOffset:CGPointMake(self.frame.size.width, 0)];
    }

    [self startTimer];


}

-(void)imageviewClick:(UITapGestureRecognizer *)tap{
       [_delegate back:tap];

   
}








@end

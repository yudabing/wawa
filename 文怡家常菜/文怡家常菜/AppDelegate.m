//
//  AppDelegate.m
//  文怡家常菜
//
//  Created by qf on 16/7/5.
//  Copyright (c) 2016年 qf. All rights reserved.
//

#import "AppDelegate.h"
#import "WenYiViewController.h"
#import "JiaChangViewController.h"
#import "ChuFangViewController.h"
#import "ZuoYeViewController.h"
#import "GeRenViewController.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "TencentOpenAPI/QQApiInterface.h"
#import "TencentOpenAPI/TencentOAuth.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"
@interface AppDelegate ()
@property (nonatomic,retain) UITabBarController * tabBarController;
@property (nonatomic,retain) UIImageView * imageView;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    _tabBarController =[[UITabBarController alloc] init];

    WenYiViewController * wvc =[[WenYiViewController alloc] init];
    UINavigationController * nvc1 = [[UINavigationController alloc] initWithRootViewController:wvc];
    wvc.delegate =self;
    
    JiaChangViewController * jvc =[JiaChangViewController new];
    UINavigationController * nvc2 = [[UINavigationController alloc] initWithRootViewController:jvc];
    jvc.delegate =self;
    
    ChuFangViewController * cvc =[ChuFangViewController new];
    UINavigationController * nvc3 = [[UINavigationController alloc] initWithRootViewController:cvc];
    cvc.delegate =self;
    
    ZuoYeViewController * zvc = [ZuoYeViewController new];
    UINavigationController * nvc4 = [[UINavigationController alloc] initWithRootViewController:zvc];
    zvc.delegate =self;
    
    GeRenViewController * gvc =[GeRenViewController new];
    UINavigationController * nvc5 = [[UINavigationController alloc] initWithRootViewController:gvc];
    gvc.delegate =self;
    
    _tabBarController.tabBar.hidden = YES;
    _tabBarController.viewControllers =@[nvc1,nvc2,nvc3,nvc4,nvc5];
    self.window.rootViewController =_tabBarController;
    _imageView =[[UIImageView alloc] initWithFrame:CGRectMake(0,HEIGHT-40,WIDHR,40)];
    _imageView.tag =10;
    _imageView.image = [UIImage imageNamed:@"bg_tab.png"];
    [self.window addSubview:_imageView];
    _imageView.userInteractionEnabled =YES;
    
    NSArray * arr = @[@"文怡随笔",@"家常菜谱",@"厨房提问",@"作业广场",@"个人中心"];
    for (int i=0;i<arr.count;i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame =CGRectMake(WIDHR/5*i+15,5,40,30);
       [button setTitle:arr[i] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"C%d.png",i+1]] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"C%d.png",i+6] ]forState:UIControlStateSelected];
        button.tag =100+i;
        [_imageView addSubview:button];
        button.titleEdgeInsets=UIEdgeInsetsMake(20, 0, 0, 0);
        button.titleLabel.font = [UIFont systemFontOfSize:9];
        [button setTitleColor:[UIColor colorWithRed:3/255.0 green:128/255.0 blue:214/255.0 alpha:1] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAtion:) forControlEvents:UIControlEventTouchUpInside];
        if (button.tag ==100) {
            button.selected =YES;
            
        }
        
    }
    [UMSocialData setAppKey:@"507fcab25270157b37000010"];
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wxd930ea5d5a258f4f" appSecret:@"db426a9829e4b49a0dcac7b4162da6b6" url:@"http://www.umeng.com/social"];
    //设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
    [UMSocialQQHandler setQQWithAppId:@"100424468" appKey:@"c7394704798a158208a74ab60104f0ba" url:@"http://www.umeng.com/social"];
    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。需要 #import "UMSocialSinaSSOHandler.h"
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"3921700954"
                                              secret:@"04b48b094faeb16683c32669824ebdad"
                                         RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    

    
    return YES;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
    }
    return result;
}
-(void)buttonAtion:(UIButton *)button{
   
    for (int i =0;i<5;i++) {
        UIButton * button1 = (UIButton*)[_imageView viewWithTag:100+i];
        button1.selected =NO;
        button1.userInteractionEnabled = YES;
    }
    button.selected=YES;
    if (button.selected==YES) {
        button.userInteractionEnabled = NO;
    }
    _tabBarController.selectedIndex =button.tag-100;
}
-(void)hiddenButton{
   UIImageView * imageView =(UIImageView *)[self.window viewWithTag:10];
     imageView.hidden =YES;
  
}
-(void)showButton{
     UIImageView * imageView =(UIImageView *)[self.window viewWithTag:10];
     imageView.hidden =NO;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

//
//  AppDelegate.m
//  Saki004
//
//  Created by 丸山　咲 on 2014/09/15.
//  Copyright (c) 2014年 Saki Maruyama. All rights reserved.
//

#import "AppDelegate.h"
#import "Withdrawalmemo.h"


@implementation AppDelegate


@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


//アプリの初回起動時のみ呼ばれるメソッド
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    // Override point for customization after application launch.
    
    
    //0.コアデータを扱うためにpersistentStoreCoodinaterを呼び出す
    [self persistentStoreCoordinator];
    [self managedObjectContext];

    //window初期化
//    CGRect bounds = [[UIScreen mainScreen] bounds];
//    _window = [[UIWindow alloc] initWithFrame:bounds];
    
    //UITabBarController初期化
//    [self initTabBarController];
    
    
    return YES;
}

////UITabBarController初期化
//- (void)initTabBarController
//{
////    //基点となる Controller生成
////    tabBarController_ = [[UITabBarController alloc] init];
//    
////    //タブの背景画像と選択時の背景画像を設定
////    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"tab_background.png"]];
////    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"tab_selection_indicator.png"]];
//    
//    //タブメニュー選択時のビュー生成
//    UIViewController *viewcontroller =[UIViewController new];
////    
////    
////    FirstViewController  *tabFirstVC  = [[FirstViewController alloc] init];
////    SecondViewController *tabSecondVC = [[SecondViewController alloc] init];
////    ThirdViewController  *tabThirdVC  = [[ThirdViewController alloc] init];
////    FourthViewController *tabFourthVC = [[FourthViewController alloc] init];
////    FifthViewController  *tabFifthVC  = [[FifthViewController alloc] init];
////    
////    //タブのアイコン指定
////    [tabFirstVC.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tab_icon1-o.png"]
////                        withFinishedUnselectedImage:[UIImage imageNamed:@"tab_icon1.png"]];
////    [tabSecondVC.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tab_icon2-o.png"]
////                         withFinishedUnselectedImage:[UIImage imageNamed:@"tab_icon2.png"]];
////    [tabThirdVC.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tab_icon3-o.png"]
////                        withFinishedUnselectedImage:[UIImage imageNamed:@"tab_icon3.png"]];
////    [tabFourthVC.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tab_icon4-o.png"]
////                         withFinishedUnselectedImage:[UIImage imageNamed:@"tab_icon4.png"]];
////    [tabFifthVC.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tab_icon5-o.png"]
////                        withFinishedUnselectedImage:[UIImage imageNamed:@"tab_icon5.png"]];
////    
////    //タブのタイトル指定
////    [tabFirstVC setTitle:@"First"];
////    [tabSecondVC setTitle:@"Second"];
////    [tabThirdVC setTitle:@"Third"];
////    [tabFourthVC setTitle:@"Fourth"];
////    [tabFifthVC setTitle:@"Fifth"];
//    
//    //タブのタイトル位置設定
//    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -1)];
//    
//    
//    //タブのフォントを指定
//    UIFont *font = [UIFont systemFontOfSize:10.0f];
//    
//    //タブのタイトル色指定
//    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor], UITextAttributeTextColor,nil] forState:UIControlStateNormal];
//
//    
//    //タブのタイトル色指定(選択中)
//    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:0.180 green:0.925 blue:0.443 alpha:1.0], UITextAttributeTextColor,nil] forState:UIControlStateSelected];
//    
////    //ビューを Controllerに追加
////    NSArray *controllers = [NSArray arrayWithObjects:viewcontroller, tabSecondVC, tabThirdVC, tabFourthVC, tabFifthVC, nil];
////    [(UITabBarController *)tabBarController_ setViewControllers:controllers animated:NO];
////    
////    //windowに Controllerのビュー追加
////    [_window addSubview:tabBarController_.view];
////    [_window makeKeyAndVisible];
//}

//タブ切り替え
//- (void)switchTabBarController:(NSInteger)selectedViewIndex
//{
//    UITabBarController *controller = (UITabBarController *)tabBarController;
//    controller.selectedViewController = [controller.viewControllers objectAtIndex:selectedViewIndex];
//}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


//コアデータ
-(void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }

}

#pragma mark - Core Data stack

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"User" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"User.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
        //コアデータに関するError？
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}



@end

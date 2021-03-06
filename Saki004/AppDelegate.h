//
//  AppDelegate.h
//  Saki004
//
//  Created by 丸山　咲 on 2014/09/15.
//  Copyright (c) 2014年 Saki Maruyama. All rights reserved.
//

#import <UIKit/UIKit.h>
//コアデータ
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UITabBarController *tabBarController;
}

#pragma mark method prototype
- (void)switchTabBarController:(NSInteger)selectedViewIndex;


//日付取得用
@property (nonatomic, assign) long year;
@property (nonatomic, assign) long month;
@property (nonatomic, assign) long day;

@property (strong, nonatomic) UIWindow *window;

//Coredata
//NSManagedObjectContext　はデータの管理(データをの追加、削除)をするオブジェクト(①)
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

//NSManagedObjectModel　のModelはデータのいれもの。入れ物を扱うメソッド(②)
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;

//NSPersistentStoreCoordinator　は①②の橋渡し役
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

//currencyListのグローバル変数をつくる
@property(strong,nonatomic) NSString *_localCurrency;
@property(strong,nonatomic) NSString *_convertCurrency;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

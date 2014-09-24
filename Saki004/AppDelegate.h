//
//  AppDelegate.h
//  Saki004
//
//  Created by 丸山　咲 on 2014/09/15.
//  Copyright (c) 2014年 Saki Maruyama. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//コアデータ
//NSManagedObjectContext　はデータの管理(データをの追加、削除)をするオブジェクト(①)
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

//NSManagedObjectModel　のModelはデータのいれもの。入れ物を扱うメソッド(②)
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;

//NSPersistentStoreCoordinator　は①②の橋渡し役
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

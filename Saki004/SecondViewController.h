//
//  SecondViewController.h
//  Saki003
//
//  Created by 丸山　咲 on 2014/09/10.
//  Copyright (c) 2014年 Saki Maruyama. All rights reserved.
//

#import <UIKit/UIKit.h>

//広告バナー追加
#import <iAd/iAd.h>

@interface SecondViewController : UIViewController<ADBannerViewDelegate,UITableViewDataSource,UITabBarDelegate,NSFetchedResultsControllerDelegate>


//コアデータ
#import <CoreData/CoreData.h>

@property(strong,nonatomic)NSManagedObjectContext *managedObjectContext;

@property(strong,nonatomic)NSFetchedResultsController *fechedResultController;









@end

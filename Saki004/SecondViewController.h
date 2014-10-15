//
//  SecondViewController.h
//  Saki003
//
//  Created by 丸山　咲 on 2014/09/10.
//  Copyright (c) 2014年 Saki Maruyama. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

//広告バナー追加
#import <iAd/iAd.h>

//コアデータ
#import <CoreData/CoreData.h>

@interface SecondViewController : UIViewController<ADBannerViewDelegate,UITableViewDataSource,UITableViewDelegate,UITabBarDelegate,NSFetchedResultsControllerDelegate>



//
//@protocol SecondViewDelegate <NSObject>
//-(void) modalViewWillClose;
//@end
//
//@interface openview : UIViewController {
//	id delegate;
//}
//
//@property (nonatomic,retain) id delegate;
//
//
//@end



@property(strong,nonatomic)NSManagedObjectContext *managedObjectContext;

@property(strong,nonatomic)NSFetchedResultsController *fechedResultController;




@property (weak, nonatomic) IBOutlet UITableView *withdrawalTableView;
@property (weak, nonatomic) IBOutlet UILabel *todayLabel;
@property (strong,nonatomic) NSString *selectedDate;





@end

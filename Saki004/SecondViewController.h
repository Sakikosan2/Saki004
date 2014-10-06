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

@interface SecondViewController : UIViewController<ADBannerViewDelegate,UITableViewDataSource,UITabBarDelegate,NSFetchedResultsControllerDelegate>


//コアデータ
#import <CoreData/CoreData.h>


@property(strong,nonatomic)NSManagedObjectContext *managedObjectContext;

@property(strong,nonatomic)NSFetchedResultsController *fechedResultController;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

- (IBAction)tapCancel:(id)sender;
- (IBAction)tapSave:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *hikidashiTextField;

@property (weak, nonatomic) IBOutlet UITextField *tesuryouTextField;
- (IBAction)insertHikidashi:(id)sender;
- (IBAction)insertTesuryou:(id)sender;







@end

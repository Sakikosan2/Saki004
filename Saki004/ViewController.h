//
//  ViewController.h
//  Saki004
//
//  Created by 丸山　咲 on 2014/09/15.
//  Copyright (c) 2014年 Saki Maruyama. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDVCalendarViewController.h"
#import <CoreData/CoreData.h>
#import "SecondViewController.h"
#import "Withdrawalmemo.h"

@interface ViewController : RDVCalendarViewController<NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) UILabel *balanceLabel;
@property (strong, nonatomic) UILabel *lastwithdrawalLabel;

//NSManagedObjectContext　はデータの管理(データをの追加、削除)をするオブジェクト(①)
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic)NSFetchedResultsController *fetchedResultController;

@end

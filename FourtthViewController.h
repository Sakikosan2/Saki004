//
//  FourtthViewController.h
//  
//
//  Created by 丸山　咲 on 2014/09/16.
//
//

#import <UIKit/UIKit.h>
#import "dateViewController.h"
#import "budgetViewController.h"
#import <iAd/iAd.h>


@interface FourtthViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ADBannerViewDelegate>


@property(weak,nonatomic) IBOutlet UITableView *setBTableView;


@end

//
//  ThirdViewController.h
//  Saki003
//
//  Created by 丸山　咲 on 2014/09/10.
//  Copyright (c) 2014年 Saki Maruyama. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "changeCViewController.h"
#import <iAd/iAd.h>

@interface ThirdViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ADBannerViewDelegate>



//APIで取得したデータをラベルに返す
@property (weak,nonatomic)IBOutlet UILabel *resultLabel;

//selectnamに行番号を格納して、スイッチ文で振り分けている
@property(nonatomic,assign) NSInteger selectnum;


-(IBAction)tapBtn:(id)sender;


@property (weak, nonatomic) IBOutlet UITableView *setTableView;



                  


@end

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

//現地通貨/換算通貨を設定するTableView
@property (weak, nonatomic) IBOutlet UITableView *setTableView;
//APIで取得したレートを表示するLabel
@property (weak,nonatomic)IBOutlet UILabel *resultLabel;
//Cancelボタン
@property (weak, nonatomic) IBOutlet UIButton *cancel;
//Saveボタン
@property (weak, nonatomic) IBOutlet UIButton *Save;
//TableViewの行番号を格納するselectnum
@property(nonatomic,assign) NSInteger selectnum;


//再取得ボタンがTapされた時
-(IBAction)tapBtn:(id)sender;
//CancelボタンがTapされた時
- (IBAction)tapCancel:(id)sender;
//SaveボタンがTapされた時
- (IBAction)tapSave:(id)sender;
                  


@end

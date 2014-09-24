//
//  changeCViewController.h
//  Saki004
//
//  Created by 丸山　咲 on 2014/09/15.
//  Copyright (c) 2014年 Saki Maruyama. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThirdViewController.h"

@interface changeCViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

{
    NSArray *_currencyArray;

    
    
}

//メンバ変数
//selectnumに行番号を格納。スイッチ文で振り分ける
@property(nonatomic,assign) NSInteger selectnum;

@property(weak,nonatomic)IBOutlet UILabel *resultLabel;


//
//@property(weak,nonatomic) NSDictionary *CurrencyList;
@property (weak, nonatomic) IBOutlet UITableView *currencyTableView;





@end

//
//  FourtthViewController.h
//  
//
//  Created by 丸山　咲 on 2014/09/16.
//
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>


@interface FourtthViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ADBannerViewDelegate,UITextFieldDelegate>



@property(weak,nonatomic) IBOutlet UITableView *setBTableView;


@end

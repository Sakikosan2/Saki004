//
//  FourtthViewController.h
//  
//
//  Created by 丸山　咲 on 2014/09/16.
//
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>


@interface FourtthViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ADBannerViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>



@property(weak,nonatomic) IBOutlet UITableView *setBTableView;

//ユーザーデフォルト
@property(strong,nonatomic) NSUserDefaults *_budgetDefaults;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
- (IBAction)tapCancel:(id)sender;
- (IBAction)tapSave:(id)sender;


@end

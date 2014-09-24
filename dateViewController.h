//
//  dateViewController.h
//  
//
//  Created by 丸山　咲 on 2014/09/16.
//
//

#import <UIKit/UIKit.h>
#import "FourtthViewController.h"

@interface dateViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *decideBtn;
- (IBAction)tapBtn:(id)sender;
- (IBAction)changeDatetime:(id)sender;

//ユーザーデフォルト
@property(strong,nonatomic) NSDateFormatter *datePickerdate;






@end

//
//  Entity.h
//  Saki004
//
//  Created by 丸山　咲 on 2014/10/13.
//  Copyright (c) 2014年 Saki Maruyama. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Withdrawalmemo : NSManagedObject

@property (nonatomic, retain) NSString * convertcurrency;
@property (nonatomic, retain) NSString * withdrawalcurrency;
@property (nonatomic, retain) NSString * commissioncurrency;
@property (nonatomic, retain) NSString * startdate;
@property (nonatomic, retain) NSNumber * commissionprice;
@property (nonatomic, retain) NSNumber * rate;
@property (nonatomic, retain) NSNumber * accountresult;
@property (nonatomic, retain) NSDate   * withdrawaldate;
@property (nonatomic, retain) NSNumber * withdrawalprice;

@end

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
@property (nonatomic, retain) NSString * localcurrency;
@property (nonatomic, retain) NSString * commitcurrency;
@property (nonatomic, retain) NSNumber * commissionprice;
@property (nonatomic, retain) NSNumber * rate;
@property (nonatomic, retain) NSNumber * accountresult;
@property (nonatomic, retain) NSString * startdate;
@property (nonatomic, retain) NSString * withdrawaldate;
@property (nonatomic, retain) NSNumber * withdrawalprice;

@end

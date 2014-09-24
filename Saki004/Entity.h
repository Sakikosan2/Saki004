//
//  Entity.h
//  Saki004
//
//  Created by 丸山　咲 on 2014/09/22.
//  Copyright (c) 2014年 Saki Maruyama. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Entity : NSManagedObject

@property (nonatomic, retain) NSNumber * date;
@property (nonatomic, retain) NSString * withdraw;
@property (nonatomic, retain) NSNumber * commission;
@property (nonatomic, retain) NSNumber * credit;
@property (nonatomic, retain) NSNumber * result;
@property (nonatomic, retain) NSString * before;
@property (nonatomic, retain) NSString * after;
@property (nonatomic, retain) NSString * cbefore;
@property (nonatomic, retain) NSString * cafter;
@property (nonatomic, retain) NSNumber * rate;

@end

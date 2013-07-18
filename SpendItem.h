//
//  SpendItem.h
//  daily Expenses
//
//  Created by renan veloso silva on 13/06/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpendItem : NSObject

@property (strong) NSNumber *item_id;
@property (strong) NSString *label;
@property (strong) NSString *type;
@property (strong) NSNumber *parcel;
@property (strong) NSNumber *value;
@property (strong) NSDate *date;
@property (strong) NSString *dateStr;
@property (strong) NSDateFormatter *dateFormat;
@property (strong) NSString *notes;
@property (strong) UIImage *typeImg;



//cartao
  //if cartao ->

@end

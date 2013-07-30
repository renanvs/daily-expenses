//
//  SpendItem.h
//  daily Expenses
//
//  Created by renan veloso silva on 13/06/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpendItem : NSObject

@property (strong) NSString *item_id;
@property (strong) NSString *label;
@property (strong) NSString *type;
@property (strong) NSString *parcel;
@property (strong) NSString *value;
@property (strong) NSString *dateSpent;
@property (strong) NSString *notes;
@property (strong) UIImage *typeImg;


@property (strong) NSString *dateCreated;
@property (strong) NSString *dateUpdated;



//cartao
  //if cartao ->

@end

//
//  ItemModel.h
//  daily Expenses
//
//  Created by Renan Veloso Silva on 14/01/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ItemModel : NSManagedObject

@property (nonatomic, retain) NSString * dateCreated;
@property (nonatomic, retain) NSString * dateSpent;
@property (nonatomic, retain) NSString * dateUpdated;
@property (nonatomic, retain) NSNumber * isCredit;
@property (nonatomic, retain) NSNumber * isSpent;
@property (nonatomic, retain) NSString * item_id;
@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * parcel;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * value;

@end

//
//  ItemModel.m
//  daily Expenses
//
//  Created by renan veloso silva on 13/06/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import "ItemModel.h"

@implementation ItemModel

-(NSString *)description{
	NSString *desc = [NSString stringWithFormat:@"ID: %@,\nLabel: %@,\nType: %@,\nParcel: %@,\nValue: %@,\nDateSpent: %@,\nDateCreated: %@,\nDateUpdated: %@ \nisSpent: %d \nisCredit: %d \n",self.item_id, self.label, self.type, self.parcel, self.value, self.dateSpent, self.dateCreated, self.dateUpdated, self.isSpent, self.isCredit];
	
	return desc;
}

@end
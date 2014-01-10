//
//  PopoverDaily.h
//  daily Expenses
//
//  Created by renan veloso silva on 11/07/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemModelC.h"

@interface PopoverItem : UIViewController{
    ItemModelC * item;
}

@property (retain, nonatomic) IBOutlet UILabel *name;
@property (retain, nonatomic) IBOutlet UILabel *category;
@property (retain, nonatomic) IBOutlet UILabel *parcel;
@property (retain, nonatomic) IBOutlet UILabel *value;
@property (retain, nonatomic) IBOutlet UILabel *date;
@property (retain, nonatomic) IBOutlet UITextView *notes;

-(id)initWithId:(NSString*)idValue;


@end

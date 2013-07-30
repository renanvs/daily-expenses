//
//  PopoverDaily.m
//  daily Expenses
//
//  Created by renan veloso silva on 11/07/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import "PopoverDaily.h"
#import "ItemCollection.h"


@implementation PopoverDaily

-(id)initWithId:(NSString*)idValue{
    self = [super init];
    if(self){
        item = [[ItemCollection sharedInstance] getSpendItemById:idValue];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    _name.text = item.label;
    _category.text = item.type;
    _parcel.text = item.parcel;
    _value.text = item.value;
    _date.text = item.dateSpent;
    _notes.text = item.notes;
}

- (void)dealloc {
    [_name release];
    [_category release];
    [_parcel release];
    [_value release];
    [_date release];
    [_notes release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setName:nil];
    [self setCategory:nil];
    [self setParcel:nil];
    [self setValue:nil];
    [self setDate:nil];
    [self setNotes:nil];
    [super viewDidUnload];
}
@end

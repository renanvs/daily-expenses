//
//  ItemListModel.m
//  daily Expenses
//
//  Created by renan veloso silva on 02/07/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import "ItemListModel.h"

@implementation NSString(isNull)

+ (BOOL ) IsEmpty:(NSString *) aString {
    
    if ((NSNull *) aString == [NSNull null]) {
        return YES;
    }
    
    if (aString == nil) {
        return YES;
    } else if ([aString length] == 0) {
        return YES;
    } else {
        aString = [aString stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([aString length] == 0) {
            return YES;
        }
    }
    
    return NO;
}

@end

@implementation ItemListModel

static id _instance;
@synthesize listItens;

+ (ItemListModel *) sharedInstance{
    @synchronized(self){
        if (!_instance) {
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}

-(id)init{
    self = [super init];
    
    if (self) {
        [self inicialize];
    }
    
    return self;
}

-(void)inicialize{
    listItens = [[NSMutableArray alloc]init];
    self.totalValue = [[NSNumber alloc] init];
    [self loadData];
}


-(void)addItemToList:(SpendItem*)item{
    int addId = [[[listItens lastObject] item_id] intValue] +1;
    item.item_id = [NSNumber numberWithInt:addId];
    //item.typeImg = [UIImage imageNamed:item.type];
    item = [self verifyAllFields:item];
    [listItens addObject:item];
    [self saveToPlist];
    self.totalValue = [NSNumber numberWithFloat:[self.totalValue floatValue] + [item.value floatValue]];
}

-(SpendItem*)verifyAllFields:(SpendItem*)item{
    if ([NSString IsEmpty:item.label])item.label = @"";
    if ([NSString IsEmpty:item.type])item.type = @"label";
    if ([NSString IsEmpty:item.dateStr])item.dateStr = @"";
    if ([NSString IsEmpty:item.notes])item.notes = @"";
    
    if (!item.value)item.value = [NSNumber numberWithInt:0];
    
    
    if (!item.parcel)item.parcel = [NSNumber numberWithInt:0];
    
    
    return item;
}

-(void)loadData{
    NSArray *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentFolder = [documentPath objectAtIndex:0];
    newPlistFile = [documentFolder stringByAppendingPathComponent:@"NewPlist.plist"];
    NSArray *arrayPlist = [NSArray arrayWithContentsOfFile:newPlistFile];
    if (!arrayPlist) {
        NSString *bundlePathOfPlist = [[NSBundle mainBundle] pathForResource:@"itemList" ofType:@"plist"];
        arrayPlist = [NSArray arrayWithContentsOfFile:bundlePathOfPlist];
    }
        
    for (NSDictionary *dict in arrayPlist) {
        SpendItem *item = [[SpendItem alloc] init];
        item.item_id = [dict objectForKey:@"id"];
        item.label = [dict objectForKey:@"label"];
        item.type = [dict objectForKey:@"type"];
        item.parcel = [dict objectForKey:@"parcel"];
        item.value = [dict objectForKey:@"value"];
        item.dateStr = [dict objectForKey:@"dateStr"];
        item.notes = [dict objectForKey:@"notes"];
        item.typeImg = [self getTypeImage:item.type];
        self.totalValue = [NSNumber numberWithFloat:[self.totalValue floatValue] + [item.value floatValue]];
        [listItens addObject:item];
    }
    
    
}

-(void)saveToPlist{
    NSArray *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentFolder = [documentPath objectAtIndex:0];
    
    newPlistFile = [documentFolder stringByAppendingPathComponent:@"NewPlist.plist"];
    
    NSString *bundleFile = [[NSBundle mainBundle]pathForResource:@"itemList" ofType:@"plist"];
    
    [[NSFileManager defaultManager]copyItemAtPath:bundleFile toPath:newPlistFile error:nil];
    
    
    NSMutableArray *addData = [NSMutableArray arrayWithContentsOfFile:newPlistFile];
    
    [addData addObject:[self addItem:[listItens lastObject]]];
    
    [addData writeToFile:newPlistFile atomically:YES];


}

-(NSDictionary*)addItem:(SpendItem*)item{
    NSDictionary* itemDict = [[NSDictionary alloc]initWithObjectsAndKeys:
                              item.item_id, @"id",
                              item.dateStr,@"dateStr",
                              item.label, @"label",
                              item.notes, @"notes",
                              item.parcel, @"parcel",
                              item.value, @"value",
                              item.type, @"type", nil];
    return itemDict;
}

-(UIImage*)getTypeImage:(NSString*)type{
    NSDictionary *catategoryList = [[Config sharedInstance] categoryList];
    
    UIImage *image = [UIImage imageNamed:[catategoryList objectForKey:type]];
    
    return image;
}

-(SpendItem*)getSpendItemById:(NSNumber*)idValue{
    SpendItem *itemToReturn;
    for (SpendItem* item in listItens) {
        if (item.item_id == idValue) {
            itemToReturn = item;
            break;
        }
    }
    return itemToReturn;
}

@end

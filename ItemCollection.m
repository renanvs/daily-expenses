//
//  ItemListModel.m
//  daily Expenses
//
//  Created by renan veloso silva on 02/07/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import "ItemCollection.h"
#import "Utility.h"

//@implementation NSString(isNull)
//
//+ (BOOL) IsEmpty:(NSString *) aString {
//    
//    if ((NSNull *) aString == [NSNull null]) {
//        return YES;
//    }
//    
//    if (aString == nil) {
//        return YES;
//    } else if ([aString length] == 0) {
//        return YES;
//    } else {
//        aString = [aString stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
//        if ([aString length] == 0) {
//            return YES;
//        }
//    }
//    
//    return NO;
//}
//
//@end

@implementation ItemCollection

static id _instance;
@synthesize listItens;

+ (ItemCollection *) sharedInstance{
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
    item = [self verifyAllFields:item];
    [listItens addObject:item];
    [self saveItemToPlist];
    self.totalValue = [NSNumber numberWithFloat:[self.totalValue floatValue] + [item.value floatValue]];
}

-(void)updateItemToList:(SpendItem*)item{
    NSNumber *totalValue;
    item = [self verifyAllFields:item];
    
    [listItens setObject:item atIndexedSubscript:[self findIndexById:item.item_id]];
    [self saveItemToPlist];
    
    for (SpendItem *itemR in listItens) {
        totalValue = [NSNumber numberWithFloat:[totalValue floatValue] + [itemR.value floatValue]];
    }
    
    self.totalValue = totalValue;
}

-(NSInteger)findIndexById:(NSNumber*)item_id{
    
    for (int i=0; i<listItens.count; i++) {
        if ([[listItens objectAtIndex:i] item_id] == item_id) {
            return i;
        }
    }
    
    return 0;
}

-(SpendItem*)verifyAllFields:(SpendItem*)item{
    if ([[Utility sharedInstance]IsEmptyString:item.label]) item.label = @"";
	if ([[Utility sharedInstance]IsEmptyString:item.type]) item.type = @"label";
	if ([[Utility sharedInstance]IsEmptyString:item.dateSpent]) item.dateSpent = @"";
	if ([[Utility sharedInstance]IsEmptyString:item.notes]) item.notes = @"";
	
	if ([[Utility sharedInstance]IsEmptyString:item.dateCreated]) item.dateCreated = [[Utility sharedInstance] getCurrentDate];
	if ([[Utility sharedInstance]IsEmptyString:item.dateUpdated]) item.dateUpdated = @"";
	
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
        item.dateSpent = [dict objectForKey:@"dateSpent"];
        item.dateUpdated = [dict objectForKey:@"dateUpdated"];
        item.dateCreated = [dict objectForKey:@"dateCreated"];
        item.notes = [dict objectForKey:@"notes"];
        item.typeImg = [self getTypeImage:item.type];
        self.totalValue = [NSNumber numberWithFloat:[self.totalValue floatValue] + [item.value floatValue]];
        [listItens addObject:item];
    }
}

-(void)saveItemToPlist{
    NSArray *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentFolder = [documentPath objectAtIndex:0];
    
    newPlistFile = [documentFolder stringByAppendingPathComponent:@"NewPlist.plist"];
    
    NSString *bundleFile = [[NSBundle mainBundle]pathForResource:@"itemList" ofType:@"plist"];
    
    [[NSFileManager defaultManager]copyItemAtPath:bundleFile toPath:newPlistFile error:nil];
    
    
    NSMutableArray *addData = [NSMutableArray arrayWithContentsOfFile:newPlistFile];
    
    [addData addObject:[self addItem:[listItens lastObject]]];
    
    [addData writeToFile:newPlistFile atomically:YES];
}

-(void)refreshPlistFileBasedOnList{
    NSArray *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentFolder = [documentPath objectAtIndex:0];
    
    newPlistFile = [documentFolder stringByAppendingPathComponent:@"NewPlist.plist"];
    
    NSString *bundleFile = [[NSBundle mainBundle]pathForResource:@"itemList" ofType:@"plist"];
    
    [[NSFileManager defaultManager]copyItemAtPath:bundleFile toPath:newPlistFile error:nil];
    
    
    NSMutableArray *addData = [NSMutableArray arrayWithContentsOfFile:newPlistFile];
    
    NSInteger verify = 0;
    NSMutableArray *itensToRemove = [[NSMutableArray alloc] init];
    
    for (NSDictionary *item in addData) {
        for (SpendItem *itemC in listItens) {
            NSString *itemId = [[item objectForKey:@"id"] stringValue];
            NSString *itemCId = [itemC.item_id stringValue];
            if ([itemId isEqualToString:itemCId]) {
                verify++;
            }
        }
        
        if (verify == 0) {
            [itensToRemove addObject:item];
        }
        
        verify = 0;
    }
    
	[addData removeObjectsInArray:itensToRemove];
    [addData writeToFile:newPlistFile atomically:YES];
}

-(NSDictionary*)addItem:(SpendItem*)item{
    NSDictionary* itemDict = [[NSDictionary alloc]initWithObjectsAndKeys:
                              item.item_id, @"id",
                              item.dateSpent,@"dateSpent",
							  item.dateCreated,@"dateCreated",
							  item.dateUpdated,@"dateUpdated",
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

-(void)removeItemByIndexPath :(NSInteger)index{
    [listItens removeObjectAtIndex:index];
    [self refreshPlistFileBasedOnList];
}

@end

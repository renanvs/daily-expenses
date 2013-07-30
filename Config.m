//
//  Config.m
//  daily Expenses
//
//  Created by renan veloso silva on 09/07/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import "Config.h"

@implementation Config
@synthesize categoryList;

static id _instance;

+ (Config *) sharedInstance{
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
        [self loadData];
    }
    
    return self;
}

-(void)loadData{
    //NSArray *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *documentFolder = [documentPath objectAtIndex:0];
    NSString *bundlePathOfPlist = [[NSBundle mainBundle] pathForResource:@"defaultConfig" ofType:@"plist"];
    NSDictionary *arrayPlist = [NSDictionary dictionaryWithContentsOfFile:bundlePathOfPlist];
    
    categoryList = [[NSDictionary alloc]initWithDictionary:[arrayPlist objectForKey:@"categories"]];
}


-(UIImage*)getImageByCategoryLabel:(NSString*)label{
    NSString *value;
    for (NSString *key in categoryList) {
        value = [categoryList objectForKey:key];
        if ([key isEqualToString:label]) {
            break;
        }
    }
    
    return [UIImage imageNamed:value];
}
@end

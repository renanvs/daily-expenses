//
//  Config.h
//  daily Expenses
//
//  Created by renan veloso silva on 09/07/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Config : NSObject

+(Config*)sharedInstance;

@property (strong) NSDictionary *categoryList;

@end

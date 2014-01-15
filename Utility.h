//
//  Utility.h
//  daily Expenses
//
//  Created by Renan Veloso Silva on 29/07/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    GraphCircle,
    
}GraphType;

@interface Utility : NSObject{
    NSArray* monthList;
}

+(Utility *) sharedInstance;

-(NSString*)getCurrentDate;

-(NSString*)getDayBefore:(NSString*)currentDate;

-(NSString*)getDayAfter:(NSString*)currentDate;

-(NSString*)getMonthByDate:(NSString*)dateS;

-(NSString*)getYearByDate:(NSString*)dateS;

- (BOOL)isEmptyString:(NSString *) aString;

-(void)removeElementsFromView:(UIView*)viewR;

- (void)setItem:(UIView*)subView inCenterView:(UIView*)viewR padLeft:(CGFloat)l  padTop:(CGFloat)t padRight:(CGFloat)r padBottom:(CGFloat)b;

- (void)setItem:(UIView*)subView inView:(UIView*)viewR side:(NSString*)side UpDown:(NSString*)updown padLeft:(CGFloat)l  padTop:(CGFloat)t padRight:(CGFloat)r padBottom:(CGFloat)b;

@end

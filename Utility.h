//
//  Utility.h
//  daily Expenses
//
//  Created by Renan Veloso Silva on 29/07/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

+(Utility *) sharedInstance;

-(NSString*)getCurrentDate;

- (BOOL) IsEmptyString:(NSString *) aString;

-(void)removeElementsFromView:(UIView*)viewR;

- (void)setItem:(UIView*)subView inCenterView:(UIView*)viewR padLeft:(CGFloat)l  padTop:(CGFloat)t padRight:(CGFloat)r padBottom:(CGFloat)b;

- (void)setItem:(UIView*)subView inView:(UIView*)viewR side:(NSString*)side UpDown:(NSString*)updown padLeft:(CGFloat)l  padTop:(CGFloat)t padRight:(CGFloat)r padBottom:(CGFloat)b;

@end

//
//  Utility.m
//  daily Expenses
//
//  Created by Renan Veloso Silva on 29/07/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import "Utility.h"

@implementation Utility

static id _instance;
+ (Utility*) sharedInstance{
    @synchronized(self){
        if (!_instance) {
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}

- (BOOL) IsEmptyString:(NSString *) aString{
    
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

-(NSString*)getCurrentDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    return [formatter stringFromDate:[NSDate date]];
}

-(void)removeElementsFromView:(UIView*)viewR{
	for (id object in [viewR subviews]) {
		[object removeFromSuperview];
	}
}

- (void)setItem:(UIView*)subView inCenterView:(UIView*)viewR padLeft:(CGFloat)l  padTop:(CGFloat)t padRight:(CGFloat)r padBottom:(CGFloat)b{
    CGRect CGItem = subView.frame;
    CGRect CGView = viewR.frame;
    
    CGFloat w = CGItem.size.width;
    CGFloat h = CGItem.size.height;
    CGFloat x = (CGView.size.width/2) - (CGItem.size.width/2) + l - r;
    CGFloat y = (CGView.size.height/2) - (CGItem.size.height/2) + t - b;
    
    CGRect newRect = CGRectMake(x, y, w, h);
    
    subView.frame = newRect;
    
}

- (void)setItem:(UIView*)subView inView:(UIView*)viewR side:(NSString*)side UpDown:(NSString*)updown padLeft:(CGFloat)l  padTop:(CGFloat)t padRight:(CGFloat)r padBottom:(CGFloat)b{
    CGRect CGItem = subView.frame;
    CGRect CGView = viewR.frame;
    
    CGFloat newX;
    CGFloat newY;
    
    if([updown isEqualToString:@"up"]){
        newY = CGView.origin.y - CGItem.size.height + t - b;
    }else{
        newY = CGView.origin.y + CGView.size.height + t - b;
    }
    
    if([side isEqualToString:@"left"]){
        newX = CGView.origin.x +l - r;
    }else{
        newX = CGView.origin.x + CGView.size.width - CGItem.size.width + l - r;
    }
    
    CGRect newRect = CGRectMake(newX, newY, CGItem.size.width, CGItem.size.height);
    
    subView.frame = newRect;
    
}
@end
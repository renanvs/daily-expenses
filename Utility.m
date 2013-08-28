//
//  Utility.m
//  daily Expenses
//
//  Created by Renan Veloso Silva on 29/07/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import "Utility.h"
@implementation NSString (custom)

-(BOOL)test{

    return YES;
}

@end


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

-(id)init{
    self = [super init];
    if (self) {
        monthList =[[NSArray alloc]initWithObjects:@"janeiro",
                    @"fevereiro",
                    @"março",
                    @"abril",
                    @"maio",
                    @"junho",
                    @"julho",
                    @"agosto",
                    @"setembro",
                    @"outubro",
                    @"novembro",
                    @"dezembro",nil];
    }
    return self;
}

#pragma mark - validate

- (BOOL)isEmptyString:(NSString *) aString{
    
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

-(BOOL)stringToBool:(NSString*)value{
    if ([value isEqualToString:@"0"]) {
        return NO;
    }else if ([value isEqualToString:@"1"]) {
        return YES;
    }else{
        return NO;
    }
}

-(NSString*)boolToString:(BOOL)value{
    if (value) {
        return @"1";
    }else if (!value) {
        return @"0";
    }else{
        return @"0";
    }
}

#pragma mark - get methods

-(NSString*)getCurrentDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    return [formatter stringFromDate:[NSDate date]];
}

-(NSString*)getDayBefore:(NSString*)currentDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDateComponents *component = [[NSDateComponents alloc] init];
    [component setDay:-1];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    
    NSDate *currentDay= [formatter dateFromString:currentDate];
    NSDate *dayBefore = [[NSCalendar currentCalendar] dateByAddingComponents:component toDate:currentDay options:0];
    return [formatter stringFromDate:dayBefore];
}

-(NSString*)getDayAfter:(NSString*)currentDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDateComponents *component = [[NSDateComponents alloc] init];
    [component setDay:+1];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    
    NSDate *currentDay= [formatter dateFromString:currentDate];
    NSDate *dayAfter = [[NSCalendar currentCalendar] dateByAddingComponents:component toDate:currentDay options:0];
    return [formatter stringFromDate:dayAfter];
}

-(NSString*)getMonthByDate:(NSString*)dateS{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSDate* dateFromString = [dateFormatter dateFromString:dateS];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:(NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit) fromDate:dateFromString];
    
    NSInteger monthIndex = [components month];
    NSString* monthStr = [monthList objectAtIndex:(monthIndex-1)];
    [monthStr test];
    return monthStr;
}


#pragma mark - remove

-(void)removeElementsFromView:(UIView*)viewR{
	for (id object in [viewR subviews]) {
		[object removeFromSuperview];
	}
}

#pragma mark - setItem position

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

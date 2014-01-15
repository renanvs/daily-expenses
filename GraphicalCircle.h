//
//  GraphCircle.h
//  daily Expenses
//
//  Created by Renan Veloso Silva on 14/01/14.
//  Copyright (c) 2014 renan veloso silva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GraphicalCircle : UIView{
    
    NSString *width;
    NSString *height;
    NSString *title;
    NSString *type;
    NSDictionary *data;
    
    UIWebView *webView;
    NSString *format_tool;
    NSString *format_label;
}

@property (nonatomic, assign) NSString *width;
@property (nonatomic, assign) NSString *height;
@property (nonatomic, assign) NSString *title;
@property (nonatomic, assign) NSString *type;
@property (nonatomic, assign) NSDictionary *data;

-(void)initGraphCreation;

@end

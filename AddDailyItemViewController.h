//
//  AddDailyItemViewController.h
//  daily Expenses
//
//  Created by renan veloso silva on 19/05/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddDailyItemViewController : UIViewController{
    NSInteger numberOfPages;
    UIView *categoryView;
}

- (IBAction)iqualOrAcceptSender:(id)sender;
@property(assign) IBOutlet UIScrollView *categoryScrollView;

@end

//
//  AddDailyItemFormViewController.h
//  daily Expenses
//
//  Created by renan veloso silva on 02/07/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopoverView.h"
#import "SpendItem.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface AddDailyItemFormViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, PopoverViewDelegate>{
    NSDictionary * categoryList;
    CGPoint point;
    SpendItem *item;
    
    UIDatePicker *datePicker;
    UIButton *dataPickerDoneBt;
    UIView *bgView;
}

@property (assign, nonatomic) IBOutlet UITextField *label;
@property (assign, nonatomic) IBOutlet UITextField *type;
@property (retain, nonatomic) IBOutlet UIButton *typeBt;
@property (retain, nonatomic) IBOutlet UILabel *typeLabel;
@property (assign, nonatomic) IBOutlet UITextField *parcel;
@property (assign, nonatomic) IBOutlet UITextField *value;
@property (assign, nonatomic) IBOutlet UITextField *dateStr;
@property (assign, nonatomic) IBOutlet UITextView *note;
@property (assign, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *tpScrollView;

-(IBAction)cadastrar:(id)sender;
-(IBAction)back:(id)sender;
- (IBAction)selectType:(id)sender;
- (IBAction)showDatePicker:(id)sender;
- (IBAction)test:(id)sender;

- (IBAction)closeCategoryChooseView:(id)sender;
@property (assign, nonatomic) IBOutlet UITableView *categoryChooseTable;
@property (assign, nonatomic) IBOutlet UIView *categoryView;


@end

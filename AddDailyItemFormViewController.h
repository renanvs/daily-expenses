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

@interface AddDailyItemFormViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, PopoverViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>{
    NSDictionary * categoryList;
    CGPoint point;
    SpendItem *item;
    
    UIDatePicker *datePicker;
    UIPickerView *parcelPicker;
    UIButton *dataPickerDoneBt;
    UIButton *parcelPickerDoneBt;
    UIView *bgView;
    NSArray *parcelDatasource;
}

@property (assign, nonatomic) IBOutlet UITextField *label;
@property (retain, nonatomic) IBOutlet UILabel *typeLabel;
@property (assign, nonatomic) IBOutlet UITextField *parcel;
@property (assign, nonatomic) IBOutlet UITextField *value;
@property (assign, nonatomic) IBOutlet UITextField *dateStr;
@property (assign, nonatomic) IBOutlet UITextView *note;
@property (assign, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *tpScrollView;
@property (assign, nonatomic) IBOutlet UIButton *typeBt;

-(IBAction)cadastrar:(id)sender;
-(IBAction)back:(id)sender;
- (IBAction)selectType:(id)sender;
- (IBAction)showDatePicker:(id)sender;
- (IBAction)showParcelPicker:(id)sender;
- (IBAction)test:(id)sender;

- (IBAction)closeCategoryChooseView:(id)sender;
@property (assign, nonatomic) IBOutlet UITableView *categoryChooseTable;
@property (assign, nonatomic) IBOutlet UIView *categoryView;


@end

//
//  AddDailyItemFormViewController.h
//  daily Expenses
//
//  Created by renan veloso silva on 02/07/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopoverView.h"
#import "ItemModel.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "SSCheckBoxView.h"

@interface ItemFormViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, PopoverViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>{
    
    ItemModel *item;
    
    UIDatePicker *datePicker;
    UIButton *dataPickerDoneBt;
	
	UIPickerView *parcelPicker;
    UIButton *parcelPickerDoneBt;
    NSArray *parcelDatasource;
	
	NSDictionary * categoryList;
	UIButton *categoryTableDoneBt;
	UITableView *categoryTableView;
	
	UIView *bgView;
    
    UIButton *closeKeyboardBt;
	
	NSString *state;
    
    SSCheckBoxView* spent;
    SSCheckBoxView* credit;
}

@property (assign, nonatomic) IBOutlet UITextField *label;
@property (retain, nonatomic) IBOutlet UILabel *typeLabel;
@property (assign, nonatomic) IBOutlet UITextField *parcel;
@property (assign, nonatomic) IBOutlet UITextField *value;
@property (assign, nonatomic) IBOutlet UITextField *dateStr;
@property (assign, nonatomic) IBOutlet UITextView *note;
@property (assign, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *tpScrollView;
@property (assign, nonatomic) IBOutlet UIButton *typeBt;
@property (assign, nonatomic) IBOutlet UIBarButtonItem *add;
@property (retain, nonatomic) IBOutlet UIView *typeView;

-(IBAction)cadastrar:(id)sender;
-(IBAction)back:(id)sender;
- (IBAction)selectType:(id)sender;
- (IBAction)showDatePicker:(id)sender;
- (IBAction)showParcelPicker:(id)sender;

-(id)initWithId:(NSString*)itemId;


@end

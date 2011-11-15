//
//  DCTTextFieldValidator.h
//  DCTTextFieldValidator
//
//  Created by Daniel Tull on 15.11.2011.
//  Copyright (c) 2011 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DCTTextFieldValidatorReturnPressedBlock) ();
typedef void (^DCTTextFieldValidatorEnableButtonBlock) (BOOL enabled);

@interface DCTTextFieldValidator : NSObject <UITextFieldDelegate>

@property (nonatomic, strong) IBOutletCollection(UITextField) NSArray *textFields;

@property (nonatomic, strong) DCTTextFieldValidatorReturnPressedBlock returnPressedHandler;
@property (nonatomic, strong) DCTTextFieldValidatorEnableButtonBlock enableButtonHandler;

@property (nonatomic, strong) IBOutlet UIControl *actionControl;

- (IBAction)action1:(id)sender;
- (IBAction)action2:(id)sender;
- (IBAction)action3:(id)sender;
- (IBAction)action4:(id)sender;
- (IBAction)action5:(id)sender;
- (IBAction)action6:(id)sender;
- (IBAction)action7:(id)sender;
- (IBAction)action8:(id)sender;
- (IBAction)action9:(id)sender;
- (IBAction)action10:(id)sender;
- (IBAction)action11:(id)sender;
- (IBAction)action12:(id)sender;
- (IBAction)action13:(id)sender;
- (IBAction)action14:(id)sender;

@end

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

@end

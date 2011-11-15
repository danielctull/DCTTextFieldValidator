//
//  DCTTextFieldValidator.h
//  DCTTextFieldValidator
//
//  Created by Daniel Tull on 15.11.2011.
//  Copyright (c) 2011 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DCTTextFieldValidatorEnabledObject <NSObject>
@property(nonatomic) BOOL enabled;
@end

typedef void (^DCTTextFieldValidatorReturnPressedBlock) ();
typedef void (^DCTTextFieldValidatorEnableButtonBlock) (BOOL enabled);

@interface DCTTextFieldValidator : NSObject <UITextFieldDelegate>

@property (nonatomic, strong) IBOutletCollection(UITextField) NSArray *textFields;

@property (nonatomic, strong) DCTTextFieldValidatorReturnPressedBlock returnPressedHandler;
@property (nonatomic, strong) DCTTextFieldValidatorEnableButtonBlock enableButtonHandler;

@property (nonatomic, strong) IBOutlet id<DCTTextFieldValidatorEnabledObject> actionControl;

@end




@interface UIBarItem (DCTTextFieldValidator) <DCTTextFieldValidatorEnabledObject> @end
@interface UIControl (DCTTextFieldValidator) <DCTTextFieldValidatorEnabledObject> @end
@interface UILabel (DCTTextFieldValidator) <DCTTextFieldValidatorEnabledObject> @end
@interface UIGestureRecognizer (DCTTextFieldValidator) <DCTTextFieldValidatorEnabledObject> @end

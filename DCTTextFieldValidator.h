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

typedef BOOL (^DCTTextFieldValidatorValidationBlock) (UITextField *textField, NSString *string);

typedef void (^DCTTextFieldValidatorReturnBlock) ();
typedef void (^DCTTextFieldValidatorValidBlock) (BOOL valid);

@interface DCTTextFieldValidator : NSObject <UITextFieldDelegate>

@property (nonatomic, strong) IBOutletCollection(UITextField) NSArray *textFields;

@property (nonatomic, copy) DCTTextFieldValidatorReturnBlock returnHandler;

@property (nonatomic, copy) DCTTextFieldValidatorValidBlock validationChangeHandler;

@property (nonatomic, copy) DCTTextFieldValidatorValidationBlock validator;

@property (nonatomic, strong) IBOutlet id<DCTTextFieldValidatorEnabledObject> enabledObject;

@end




@interface UIBarItem (DCTTextFieldValidator) <DCTTextFieldValidatorEnabledObject> @end
@interface UIControl (DCTTextFieldValidator) <DCTTextFieldValidatorEnabledObject> @end
@interface UILabel (DCTTextFieldValidator) <DCTTextFieldValidatorEnabledObject> @end
@interface UIGestureRecognizer (DCTTextFieldValidator) <DCTTextFieldValidatorEnabledObject> @end

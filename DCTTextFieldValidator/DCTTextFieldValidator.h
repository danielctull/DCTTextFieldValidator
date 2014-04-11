/*
 DCTTextFieldValidator.h
 DCTTextFieldValidator
 
 Created by Daniel Tull on 15.11.2011.
 
 
 
 Copyright (c) 2011 Daniel Tull. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 * Neither the name of the author nor the names of its contributors may be used
 to endorse or promote products derived from this software without specific
 prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

@import UIKit;

/** 
 *  Used to represent a class which has an enabled property, such as UIControl, UIBarItem, UILabel or
 *  UIGestureRecognizer. If I've missed one that you wish to use, just add it to the list at the bottom
 *  of DCTTextFieldValidator.h, a fork and pull request on GitHub would also be most appreciated.
 */
@protocol DCTTextFieldValidatorEnabledObject <NSObject>
/**
 *  Conforming classes must have an enabled property.
 */
@property(nonatomic) BOOL enabled;
@end


/** 
 *  This class takes an array of UITextFields and validates them before allowing an action to take place.
 *
 *  If switches the return key depending on if the text fields are valid, if one or more text fields are
 *  not valid, it will make the next one in the array the first responder upon tapping the return key. Once
 *  all fields are valid, the keyboard return key will become (for all text fields in the array) that which
 *  is assigned to the last text field in the array.
 *
 *  The main thinking is to make sure all of the fields are filled out, and not blank. Though I am considering
 *  a post-validation, which would validate each one after the return key is hit, such as checking emails are
 *  correct and such. I've filed this as a bug on GitHub and would be grateful for any input on this.
 */
@interface DCTTextFieldValidator : NSObject

@property (nonatomic, readonly, getter = isValid) BOOL valid;


- (void)addTextField:(UITextField *)textField;



- (void)removeTextField:(UITextField *)textField;

/**
 *  The text fields that require validating.
 *
 *  This can either be set using IB, making use of the IBOutletCollection, or in 
 *  code.
 */
@property (nonatomic, copy) IBOutletCollection(UITextField) NSArray *textFields;

- (void)addRequiredTextField:(UITextField *)textField;
- (void)removeRequiredTextField:(UITextField *)textField;
@property (nonatomic, copy) IBOutletCollection(UITextField) NSArray *requiredTextFields;

/**
 *  This block will get called when the text fields are valid and the return key on the keyboard is tapped.
 */
@property (nonatomic, copy) void (^returnHandler)();

/**
 *  A block that gets called when the validity of the text fields as a whole changes.
 */
@property (nonatomic, copy) void (^validationChangeHandler)(BOOL isValid);


/**
 *  Predicate to check if the text is valid.
 *
 *  When checking the string, you must use the given string and not rely on the one currently in the
 *  textField. The textField's string may be different as this block may be called before the change
 *  happens on the text field.
 *
 *  The default validationPredicate returns TRUE if the string is not empty.
 */
@property (nonatomic, copy) NSPredicate *validationPredicate;


/**
 *  An object that requires enabling when the text fields are valid.
 *
 *  As there a few objects you may want to have set as enabled when the text fields are
 *  valid, the DCTTextFieldValidatorEnabledObject protocol is used. Currently the following classes
 *  are set up to conform to this protocol:
 *
 *  * UIBarItem
 *  * UIControl (UIButton etc)
 *  * UILabel
 *  * UIGestureRecognizer
 *
 *  It is recommended that any class you wish to conform to this protocol you create a category for.
 *  If it is a standard UIKit class that I may have overlooked, it would be great if you could add it
 *  to the bottom of DCTTextFieldValidator.h and create a pull request on GitHub. :)
 */
@property (nonatomic, strong) IBOutlet id<DCTTextFieldValidatorEnabledObject> enabledObject;

@end

/**
 *  Adds conformation of DCTTextFieldValidatorEnabledObject to UIBarItem.
 */
@interface UIBarItem (DCTTextFieldValidator) <DCTTextFieldValidatorEnabledObject> @end

/**
 *  Adds conformation of DCTTextFieldValidatorEnabledObject to UIControl.
 */
@interface UIControl (DCTTextFieldValidator) <DCTTextFieldValidatorEnabledObject> @end

/**
 *  Adds conformation of DCTTextFieldValidatorEnabledObject to UILabel.
 */
@interface UILabel (DCTTextFieldValidator) <DCTTextFieldValidatorEnabledObject> @end

/**
 *  Adds conformation of DCTTextFieldValidatorEnabledObject to UIGestureRecognizer.
 */
@interface UIGestureRecognizer (DCTTextFieldValidator) <DCTTextFieldValidatorEnabledObject> @end

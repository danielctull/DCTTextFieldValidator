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

#import "DCTTextFieldValidator.h"

@interface DCTTextFieldValidator ()
- (BOOL)dctInternal_anotherTextFieldIsEmpty:(UITextField *)textField;
- (void)dctInternal_setupEnabled;
- (void)dctInternal_setValid:(BOOL)isValid;
@end

@implementation DCTTextFieldValidator {
	UIReturnKeyType returnKeyType;
}

@synthesize valid;
@synthesize textFields;
@synthesize returnHandler;
@synthesize validationChangeHandler;
@synthesize validator;
@synthesize enabledObject;

- (id)init {
    
    if (!(self = [super init])) return nil;
	
	self.validator = ^BOOL(UITextField *textField, NSString *string) {
		return ![string isEqualToString:@""];
	};
	
    return self;
}

- (void)setTextFields:(NSArray *)tfs {
	
	textFields = tfs;
	
	for (UITextField *textField in self.textFields) {
		textField.delegate = self;
		textField.enablesReturnKeyAutomatically = YES;
		returnKeyType = textField.returnKeyType;
	}
	
	[self dctInternal_setupEnabled];
}

- (void)setValidator:(DCTTextFieldValidatorValidationBlock)newValidator {
	validator = newValidator;
	[self dctInternal_setupEnabled];
}

- (void)setEnabledObject:(id<DCTTextFieldValidatorEnabledObject>)newEnabledObject {
	enabledObject = newEnabledObject;
	[self dctInternal_setupEnabled];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	
	if ([self dctInternal_anotherTextFieldIsEmpty:textField])
		textField.returnKeyType = UIReturnKeyNext;
	else
		textField.returnKeyType = returnKeyType;
	
	return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	
	if (!self.validationChangeHandler && !self.enabledObject) return YES;
	
	NSString *s = [textField.text stringByReplacingCharactersInRange:range withString:string];
	
	if (textField.returnKeyType == returnKeyType && self.validator(textField, s))
		[self dctInternal_setValid:YES];
	else
		[self dctInternal_setValid:NO];
	
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	if (textField.returnKeyType == returnKeyType && self.validator(textField, textField.text)) {
		if (self.returnHandler) self.returnHandler();
		return YES;
	}
		
	NSUInteger index = [self.textFields indexOfObject:textField];
	
	NSArray *end = [self.textFields subarrayWithRange:NSMakeRange(index+1, [self.textFields count] - (index+1))];
	NSArray *begin = [self.textFields subarrayWithRange:NSMakeRange(0, index)];
	NSArray *tf = [end arrayByAddingObjectsFromArray:begin];
	
	[tf enumerateObjectsUsingBlock:^(UITextField *otherTextField, NSUInteger idx, BOOL *stop) {
		
		if (!otherTextField.text || [otherTextField.text isEqualToString:@""]) {
			[otherTextField becomeFirstResponder];
			*stop = YES;
		}
	}];
	
	return YES;
}

- (BOOL)dctInternal_anotherTextFieldIsEmpty:(UITextField *)textField {
	
	__block BOOL anotherTextFieldIsEmpty = NO;
	
	[textFields enumerateObjectsUsingBlock:^(UITextField *otherTextField, NSUInteger idx, BOOL *stop) {
				
		if ([otherTextField isEqual:textField])
			return;
		
		if (!otherTextField.text || !self.validator(otherTextField, otherTextField.text)) {
			anotherTextFieldIsEmpty = YES;
			*stop = YES;
		}
	}];
	
	return anotherTextFieldIsEmpty;
}

- (void)dctInternal_setupEnabled {
	
	BOOL newValid = YES;
	
	for (UITextField *textField in self.textFields) {
		BOOL v = self.validator(textField, textField.text);		
		if (!v) newValid = NO;
	}
	
	[self dctInternal_setValid:newValid];
}

- (void)dctInternal_setValid:(BOOL)isValid {
	valid = isValid;
	if (self.validationChangeHandler != NULL) self.validationChangeHandler(isValid);
	self.enabledObject.enabled = isValid;
}

@end

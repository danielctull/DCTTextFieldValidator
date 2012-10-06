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

@implementation DCTTextFieldValidator {
	UIReturnKeyType _returnKeyType;
}

- (id)init {
    
	self = [super init];
    if (!self) return nil;
	
	self.validator = ^BOOL(UITextField *textField, NSString *string) {
		return [string length] > 0;
	};
	
    return self;
}

- (void)setTextFields:(NSArray *)textFields {
		
	[_textFields enumerateObjectsUsingBlock:^(UITextField *textField, NSUInteger idx, BOOL *stop) {
		[textField removeTarget:self action:@selector(_editingChanged:) forControlEvents:UIControlEventEditingChanged];
		[textField removeTarget:self action:@selector(_editingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
		[textField removeTarget:self action:@selector(_editingDidEndOnExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
	}];
	
	_textFields = [textFields copy];
	
	[_textFields enumerateObjectsUsingBlock:^(UITextField *textField, NSUInteger idx, BOOL *stop) {
		[textField addTarget:self action:@selector(_editingChanged:) forControlEvents:UIControlEventEditingChanged];
		[textField addTarget:self action:@selector(_editingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
		[textField addTarget:self action:@selector(_editingDidEndOnExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
		_returnKeyType = textField.returnKeyType;
	}];
	
	if (!self.requiredTextFields) self.requiredTextFields = _textFields;
}

- (void)setRequiredTextFields:(NSArray *)requiredTextFields {

	_requiredTextFields = [requiredTextFields copy];
	
	[_requiredTextFields enumerateObjectsUsingBlock:^(UITextField *textField, NSUInteger idx, BOOL *stop) {
		textField.enablesReturnKeyAutomatically = YES;
		[self _addTextFieldIfNeeded:textField];
	}];
	
	[self _validate];
}

- (void)setValidator:(BOOL (^)(UITextField *, NSString *))validator {
	_validator = validator;
	[self _validate];
}

- (void)setEnabledObject:(id<DCTTextFieldValidatorEnabledObject>)enabledObject {
	_enabledObject = enabledObject;
	[self _validate];
}

#pragma mark - UIControlEvents

- (void)_editingDidBegin:(UITextField *)textField {
	
	if ([self _nextTextField:textField])
		textField.returnKeyType = UIReturnKeyNext;
	else
		textField.returnKeyType = _returnKeyType;
}

- (void)_editingChanged:(UITextField *)textField {
	[self _validate];
}

- (void)_editingDidEndOnExit:(UITextField *)textField {
	
	UITextField *nextTextField = [self _nextTextField:textField];
	if (nextTextField) {
		[nextTextField becomeFirstResponder];
		return;
	}
	
	if (self.returnHandler) self.returnHandler();
}

#pragma mark - Internal

- (void)_addTextFieldIfNeeded:(UITextField *)textField {
	if ([self.textFields containsObject:textField]) return;
	NSMutableArray *textFields = [self.textFields mutableCopy];
	if (!textFields) textFields = [NSMutableArray new];
	[textFields addObject:textField];
	self.textFields = textFields;
}

- (UITextField *)_nextTextField:(UITextField *)textField {
	
	NSUInteger index = [self.textFields indexOfObject:textField];
	NSArray *end = [self.textFields subarrayWithRange:NSMakeRange(index+1, [self.textFields count] - (index+1))];
	NSArray *begin = [self.textFields subarrayWithRange:NSMakeRange(0, index)];
	NSArray *nextTextFields = [end arrayByAddingObjectsFromArray:begin];
	
	__block UITextField *nextTextField;
	
	[nextTextFields enumerateObjectsUsingBlock:^(UITextField *otherTextField, NSUInteger idx, BOOL *stop) {
		if (!self.validator(otherTextField, otherTextField.text)) {
			nextTextField = otherTextField;
			*stop = YES;
		}
	}];
	
	return nextTextField;
}

- (void)_validate {
	
	__block BOOL isValid = YES;
	
	[self.requiredTextFields enumerateObjectsUsingBlock:^(UITextField *textField, NSUInteger idx, BOOL *stop) {
		if (!self.validator(textField, textField.text)) {
			isValid = NO;
			*stop = YES;
		}
	}];
	
	[self _setValid:isValid];
	self.enabledObject.enabled = isValid;
}

- (void)_setValid:(BOOL)isValid {
	if (_valid == isValid);
	_valid = isValid;
	if (self.validationChangeHandler != NULL) self.validationChangeHandler(isValid);
}

@end

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
		return ![string isEqualToString:@""];
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
		textField.enablesReturnKeyAutomatically = YES;
		_returnKeyType = textField.returnKeyType;
	}];
	
	[self _setupEnabled];
}

- (void)setValidator:(BOOL (^)(UITextField *, NSString *))validator {
	_validator = validator;
	[self _setupEnabled];
}

- (void)setEnabledObject:(id<DCTTextFieldValidatorEnabledObject>)enabledObject {
	_enabledObject = enabledObject;
	[self _setupEnabled];
}

#pragma mark - UIControlEvents

- (void)_editingDidBegin:(UITextField *)textField {
	
	if ([self _anotherTextFieldIsEmpty:textField])
		textField.returnKeyType = UIReturnKeyNext;
	else
		textField.returnKeyType = _returnKeyType;
}

- (void)_editingChanged:(UITextField *)textField {
	
	if (!self.validationChangeHandler && !self.enabledObject) return;
	
	if (textField.returnKeyType == _returnKeyType && self.validator(textField, textField.text))
		[self _setValid:YES];
	else
		[self _setValid:NO];
}

- (void)_editingDidEndOnExit:(UITextField *)textField {
	
	if (textField.returnKeyType == _returnKeyType && self.validator(textField, textField.text)) {
		if (self.returnHandler) self.returnHandler();
		return;
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
}

#pragma mark - Internal

- (BOOL)_anotherTextFieldIsEmpty:(UITextField *)textField {
	
	__block BOOL anotherTextFieldIsEmpty = NO;
	
	[self.textFields enumerateObjectsUsingBlock:^(UITextField *otherTextField, NSUInteger idx, BOOL *stop) {
				
		if ([otherTextField isEqual:textField])
			return;
		
		if (!otherTextField.text || !self.validator(otherTextField, otherTextField.text)) {
			anotherTextFieldIsEmpty = YES;
			*stop = YES;
		}
	}];
	
	return anotherTextFieldIsEmpty;
}

- (void)_setupEnabled {
	
	BOOL newValid = YES;
	
	for (UITextField *textField in self.textFields) {
		BOOL v = self.validator(textField, textField.text);		
		if (!v) newValid = NO;
	}
	
	[self _setValid:newValid];
}

- (void)_setValid:(BOOL)isValid {
	_valid = isValid;
	if (self.validationChangeHandler != NULL) self.validationChangeHandler(isValid);
	self.enabledObject.enabled = isValid;
}

@end

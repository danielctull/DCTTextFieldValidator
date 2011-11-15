//
//  DCTTextFieldValidator.m
//  DCTTextFieldValidator
//
//  Created by Daniel Tull on 15.11.2011.
//  Copyright (c) 2011 Daniel Tull. All rights reserved.
//

#import "DCTTextFieldValidator.h"

@interface DCTTextFieldValidator ()
- (BOOL)dctInternal_anotherTextFieldIsEmpty:(UITextField *)textField;
@end

@implementation DCTTextFieldValidator

@synthesize textFields;
@synthesize returnPressedHandler;
@synthesize enableButtonHandler;

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
		
	if ([self dctInternal_anotherTextFieldIsEmpty:textField])
		textField.returnKeyType = UIReturnKeyNext;
	else
		textField.returnKeyType = UIReturnKeyGo;
	
	return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	
	if (!self.enableButtonHandler) return YES;
	
	NSString *s = [textField.text stringByReplacingCharactersInRange:range withString:string];
	
	if (textField.returnKeyType == UIReturnKeyGo && ![s isEqualToString:@""])
		self.enableButtonHandler(YES);
	else
		self.enableButtonHandler(NO);
	
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	if (textField.returnKeyType == UIReturnKeyGo) {
		if (self.returnPressedHandler) self.returnPressedHandler();
		return YES;
	}
	
	__block UITextField *nextTextField = nil;
	
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
		
		if (!otherTextField.text || [otherTextField.text isEqualToString:@""]) {
			anotherTextFieldIsEmpty = YES;
			*stop = YES;
		}
	}];
	
	return anotherTextFieldIsEmpty;
}

@end

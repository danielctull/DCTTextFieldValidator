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
@synthesize actionControl;

- (void)setTextFields:(NSArray *)tfs {
	
	textFields = tfs;
	
	NSLog(@"%@:%@", self, NSStringFromSelector(_cmd));
	
	for (UITextField *textField in self.textFields) {
		textField.delegate = self;
		textField.enablesReturnKeyAutomatically = YES;
	}
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	
	if ([self dctInternal_anotherTextFieldIsEmpty:textField])
		textField.returnKeyType = UIReturnKeyNext;
	else
		textField.returnKeyType = UIReturnKeyGo;
	
	return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	
	if (!self.enableButtonHandler && !self.actionControl) return YES;
	
	NSString *s = [textField.text stringByReplacingCharactersInRange:range withString:string];
	
	if (textField.returnKeyType == UIReturnKeyGo && ![s isEqualToString:@""]) {
		if (self.enableButtonHandler) self.enableButtonHandler(YES);
		self.actionControl.enabled = YES;
	} else {
		if (self.enableButtonHandler) self.enableButtonHandler(NO);
		self.actionControl.enabled = NO;
	}
	
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	NSLog(@"%@:%@", self, NSStringFromSelector(_cmd));
	
	if (textField.returnKeyType == UIReturnKeyGo) {
		if (self.returnPressedHandler) self.returnPressedHandler();
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
		
		if (!otherTextField.text || [otherTextField.text isEqualToString:@""]) {
			anotherTextFieldIsEmpty = YES;
			*stop = YES;
		}
	}];
	
	return anotherTextFieldIsEmpty;
}

- (IBAction)action1:(id)sender {
	NSLog(@"%@:%@", self, NSStringFromSelector(_cmd));
}
- (IBAction)action2:(id)sender {
	NSLog(@"%@:%@", self, NSStringFromSelector(_cmd));
}
- (IBAction)action3:(id)sender {
	NSLog(@"%@:%@", self, NSStringFromSelector(_cmd));
}
- (IBAction)action4:(id)sender {
	NSLog(@"%@:%@", self, NSStringFromSelector(_cmd));
}
- (IBAction)action5:(id)sender {
	NSLog(@"%@:%@", self, NSStringFromSelector(_cmd));
}
- (IBAction)action6:(id)sender {
	NSLog(@"%@:%@", self, NSStringFromSelector(_cmd));
}
- (IBAction)action7:(id)sender {
	NSLog(@"%@:%@", self, NSStringFromSelector(_cmd));
}
- (IBAction)action8:(id)sender {
	NSLog(@"%@:%@", self, NSStringFromSelector(_cmd));
}
- (IBAction)action9:(id)sender {
	NSLog(@"%@:%@", self, NSStringFromSelector(_cmd));
}
- (IBAction)action10:(id)sender {
	NSLog(@"%@:%@", self, NSStringFromSelector(_cmd));
}
- (IBAction)action11:(id)sender {
	NSLog(@"%@:%@", self, NSStringFromSelector(_cmd));
}
- (IBAction)action12:(id)sender {
	NSLog(@"%@:%@", self, NSStringFromSelector(_cmd));
}
- (IBAction)action13:(id)sender {
	NSLog(@"%@:%@", self, NSStringFromSelector(_cmd));
}
- (IBAction)action14:(id)sender {
	NSLog(@"%@:%@", self, NSStringFromSelector(_cmd));
}

@end

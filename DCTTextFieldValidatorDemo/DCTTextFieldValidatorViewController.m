//
//  DCTTextFieldValidatorViewController.m
//  DCTTextFieldValidator
//
//  Created by Daniel Tull on 15.11.2011.
//  Copyright (c) 2011 Daniel Tull. All rights reserved.
//

#import "DCTTextFieldValidatorViewController.h"
#import "DCTTextFieldValidator.h"

@implementation DCTTextFieldValidatorViewController

@synthesize validator;

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.validator.actionControl = [[UIBarButtonItem alloc] init];
}

@end
